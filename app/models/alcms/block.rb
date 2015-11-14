module Alcms
  class Block < ActiveRecord::Base
    belongs_to :origin_block, class_name: Alcms::Block
    has_many :texts

    scope :get, -> (name, time) {
      time ||= Time.now
      where('name = ? and (starts_at > ? or starts_at is null) and (expires_at < ? or expires_at is null)')
        .order(:id).first
    }
  end
end
