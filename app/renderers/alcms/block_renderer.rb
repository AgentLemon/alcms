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
      @block = Block.get(@block_name, @time).last
      @text = (@block.texts.get(@text_name).last if @block.present?)
    end

    def fill_data
      @data = {
        block: @block_name,
        text: @text_name,
        block_id: @block.try(:id),
        text_id: @text.try(:id)
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
  end
end
