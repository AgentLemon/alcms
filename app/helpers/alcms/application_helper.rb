module Alcms
  module ApplicationHelper
    def alcms_header
      %Q(
        #{ javascript_include_tag 'alcms/application' }
        #{ stylesheet_link_tag 'alcms/application' }
      ).html_safe
    end

    def alcms_editor
      render 'alcms/editor'
    end

    def alcms_initialized?
      @alcms_header && @alcms_editor
    end

    def render_cms_block(block_name, text_name, time: Time.now, classes: [])
      classes = Array.wrap(classes)
      classes << 'alcms-editable'

      block = Block.get(block_name, time).last
      text = block.present? ? block.texts.get(text_name).last : nil

      content_tag(:div, class: classes, data: { block: block_name, text: text_name, block_id: block.try(:id), text_id: text.try(:id) }) do
        if text.try(:content).present?
          text.content.html_safe
        elsif block_given?
          yield
        else
          ""
        end
      end
    end
  end
end
