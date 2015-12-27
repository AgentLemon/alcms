module Alcms
  module ApplicationHelper
    def editor_mode?
      instance_eval(&Alcms::Engine.can_save) && instance_eval(&Alcms::Engine.editor_mode)
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

    def render_cms_block(block_name, text_name, time: nil, classes: [], readonly: false, &block)
      time ||= params[:alcms_date].to_time if editor_mode? && params[:alcms_date].present?
      time ||= Time.now
      BlockRenderer.new(
        block_name,
        text_name,
        time,
        classes,
        editor_mode?,
        readonly,
        (capture(&block) if block_given?)
      ).render
    end
  end
end
