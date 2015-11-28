module Alcms
  class BlockRenderer
    include ActionView::Helpers::TagHelper

    attr_accessor :output_buffer

    def initialize(block_name, text_name, time, classes, editor_mode, default_text = '')
      @block_name = block_name
      @text_name = text_name
      @time = time
      @classes = Array.wrap(classes)
      @editor_mode = editor_mode
      @default_text = default_text
    end

    def render
      load_records
      fill_data
      expand_classes
      get_content
    end

    private

    def editor_mode?
      @editor_mode
    end

    def expand_classes
      @classes << 'alcms-editable'
      if editor_mode?
        @classes << 'draft' unless @text.try(:content) == @text.try(:content_draft)
        @classes << 'initial' if @text.blank?
      end
    end

    def load_records
      @block = Block.get(@block_name, @time, editor_mode?).last
      @text = (@block.texts.get(@text_name).last if @block.present?)
    end

    def fill_data
      @data = {
        block_name: @block_name,
        text_name: @text_name,
        block_id: @block.try(:id),
        text_id: @text.try(:id),
        block: (@block || {}).as_json,
        versions: versions.as_json
      } if editor_mode?
    end

    def get_content
      field = editor_mode? ? :content_draft : :content

      content_tag(:div, class: @classes, data: @data) do
        if @text.try(field).present?
          @text.send(field).html_safe
        else
          @default_text
        end
      end
    end

    def versions
      @versions ||= begin
        result = Block.where.not(id: @block.try(:id))
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
