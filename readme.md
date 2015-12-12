Setup
-----

config/initializers/alcms.rb

    Alcms::Engine.setup do |config|
      config.editor_mode_if do
        params[:editor]
      end
    end

Tests
-----

    rake app:db:migrate && rake app:db:test:prepare
    bundle exec rspec
