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

      content_tag(:div, class: classes, data: { block: block_name, text: text_name }) do
        yield if block_given?
        "There will be block #{block_name}:#{text_name}:#{time.to_s(:db)}"
      end
    end
  end
end
