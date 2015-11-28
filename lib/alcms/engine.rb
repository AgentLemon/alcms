module Alcms
  class Engine < ::Rails::Engine
    isolate_namespace Alcms
    config.autoload_paths << File.expand_path('../app/renderers', __FILE__)

    mattr_accessor :editor_mode_condition

    self.editor_mode_condition = Proc.new do
      params[:edit]
    end

    def self.editor_mode_if(&block)
      self.editor_mode_condition = Proc.new(&block)
    end

    def self.setup(&block)
      yield self
    end
  end
  
end
