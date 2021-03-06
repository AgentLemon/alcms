module Alcms
  class Block < ActiveRecord::Base
    belongs_to :origin_block, class_name: Alcms::Block
    has_many :texts, dependent: :destroy

    accepts_nested_attributes_for :texts

    scope :get, -> (name, time = nil, draft = false) {
      time ||= Time.now
      fields = 'starts_at', 'expires_at'
      fields.each{ |f| f << '_draft' } if draft
      where(name: name)
        .where("#{fields.first} < ? or #{fields.first} is null", time)
        .where("#{fields.last} > ? or #{fields.last} is null", time)
        .order(%Q{
          case
            when #{fields.first} is null and #{fields.last} is null then 0
            when #{fields.first} is null or #{fields.last} is null then 1
            else 2
          end })
        .order(:id)
    }

    def prepare_for_publish
      texts.each(&:prepare_for_publish)
      self.starts_at = starts_at_draft
      self.expires_at = expires_at_draft
    end

    def publish!
      prepare_for_publish
      save!
    end

    def duplicate!
      block = self.dup
      self.texts.each { |text| block.texts << text.dup }
      block.save!
      block
    end
  end
end
