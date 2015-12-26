[![Code Climate](https://codeclimate.com/github/AgentLemon/alcms/badges/gpa.svg)](https://codeclimate.com/github/AgentLemon/alcms)

Setup
-----

config/initializers/alcms.rb

    Alcms::Engine.setup do |config|
      config.editor_mode_if do
        params[:editor] && current_user.admin?
      end
    end

Tests
-----

    rake app:db:migrate && rake app:db:test:prepare
    bundle exec rspec
