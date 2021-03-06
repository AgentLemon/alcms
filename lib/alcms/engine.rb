module Alcms
  class Engine < ::Rails::Engine
    require 'jquery-rails'

    isolate_namespace Alcms
    config.autoload_paths << File.expand_path('../app/renderers', __FILE__)

    initializer "static assets" do |app|
      app.middleware.use(::ActionDispatch::Static, "#{root}/public")
    end

    mattr_accessor :editor_mode
    mattr_accessor :can_save
    mattr_accessor :admin_path

    self.editor_mode = Proc.new do
      params[:edit]
    end

    self.can_save = Proc.new do
      true
    end

    self.admin_path = nil

    def self.editor_mode_condition(&block)
      self.editor_mode = Proc.new(&block)
    end

    def self.can_save_condition(&block)
      self.can_save = Proc.new(&block)
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
