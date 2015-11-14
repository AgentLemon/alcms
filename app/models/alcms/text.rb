module Alcms
  class Text < ActiveRecord::Base
    belongs_to :block

    scope :get, -> (name) {
      where(name: name)
    }

    def prepare_for_publish
      self.content = content_draft
    end
  end
end
