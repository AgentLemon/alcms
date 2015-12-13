module Alcms
  class Engine < ::Rails::Engine
    require 'jquery-rails'

    isolate_namespace Alcms
    config.autoload_paths << File.expand_path('../app/renderers', __FILE__)

    initializer "static assets" do |app|
      app.middleware.insert_before(::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public")
    end

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

    config.generators do |g|
      g.test_framework      :rspec,        fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end
  end

end
