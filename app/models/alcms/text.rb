module Alcms
  class Text < ActiveRecord::Base
    belongs_to :block

    scope :get, -> (name) {
      where(name: name).first
    }
  end
end
