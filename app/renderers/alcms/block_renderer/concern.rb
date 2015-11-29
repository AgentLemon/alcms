module Alcms::BlockRenderer::Concern
  extend ActiveSupport::Concern

  included do
    def versions
      @versions ||= begin
        result = ::Alcms::Block.where.not(id: @block.try(:id))
          .where(name: @block_name)
          .order(:starts_at_draft).map{ |b| format_version(b) }
        result.unshift(format_version(@block))
      end
    end

    def format_version(block)
      {
        id: block.try(:id),
        starts_at_draft: format_time(block.try(:starts_at_draft)),
        expires_at_draft: format_time(block.try(:expires_at_draft)),
        initial: block.try(:id).nil?
      }
    end

    def format_time(time)
      time.present? ? I18n.l(time, format: :alcms) : I18n.t('alcms.nil_time')
    end
  end
end
