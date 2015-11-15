module Alcms
  module ApplicationHelper
    def editor_mode?
      instance_eval(&Alcms::Engine.editor_mode_condition)
    end

    def alcms_header
      %Q(
        #{ javascript_include_tag 'alcms/application' }
        #{ stylesheet_link_tag 'alcms/application' }
      ).html_safe if editor_mode?
    end

    def alcms_editor
      render 'alcms/editor' if editor_mode?
    end

    def render_cms_block(block_name, text_name, time: Time.now, classes: [])
      classes = Array.wrap(classes)
      classes << 'alcms-editable'

      block = Block.get(block_name, time).last
      text = block.present? ? block.texts.get(text_name).last : nil
      data = ({
        block: block_name,
        text: text_name,
        block_id: block.try(:id),
        text_id: text.try(:id)
      } if editor_mode?)

      content_tag(:div, class: classes, data: data) do
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
