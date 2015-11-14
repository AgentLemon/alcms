module Alcms
  class Block < ActiveRecord::Base
    belongs_to :origin_block, class_name: Alcms::Block
    has_many :texts

    accepts_nested_attributes_for :texts

    scope :get, -> (name, time = nil) {
      time ||= Time.now
      where('name = ? and (starts_at > ? or starts_at is null) and (expires_at < ? or expires_at is null)', name, time, time)
        .order(:id)
    }

    def prepare_for_publish
      texts.each(&:prepare_for_publish)
    end

    def publish!
      prepare_for_publish
      save!
    end
  end
end
