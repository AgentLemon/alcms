[![Code Climate](https://codeclimate.com/github/AgentLemon/alcms/badges/gpa.svg)](https://codeclimate.com/github/AgentLemon/alcms)
[![Test Coverage](https://codeclimate.com/github/AgentLemon/alcms/badges/coverage.svg)](https://codeclimate.com/github/AgentLemon/alcms/coverage)
[![Build Status](https://semaphoreci.com/api/v1/projects/07454e9e-b76d-48ee-9e1f-b1ce919c3dd3/645416/badge.svg)](https://semaphoreci.com/AgentLemon/alcms)

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
