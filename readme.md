[![Code Climate](https://codeclimate.com/github/AgentLemon/alcms/badges/gpa.svg)](https://codeclimate.com/github/AgentLemon/alcms)

Setup
-----

config/initializers/alcms.rb

    Alcms::Engine.setup do |config|
      config.editor_mode_condition do
        params[:editor]
      end
      
      config.can_save_condition do
        current_user.admin?
      end
    end

layouts

    <head>
      ...
      = alcms_header    
    </head>
    <body>
      = alcms_editor
      ...
    </body>

Tests
-----

    rake app:db:migrate && rake app:db:test:prepare
    bundle exec rspec
