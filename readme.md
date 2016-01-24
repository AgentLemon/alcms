[![Code Climate](https://codeclimate.com/github/AgentLemon/alcms/badges/gpa.svg)](https://codeclimate.com/github/AgentLemon/alcms)
[![Test Coverage](https://codeclimate.com/github/AgentLemon/alcms/badges/coverage.svg)](https://codeclimate.com/github/AgentLemon/alcms/coverage)
[![Build Status](https://semaphoreci.com/api/v1/projects/07454e9e-b76d-48ee-9e1f-b1ce919c3dd3/645416/badge.svg)](https://semaphoreci.com/AgentLemon/alcms)

Summary
-------

Simple CMS feature with content scheduling for rails apps.

**Live DEMO:** [http://alcms-demo.herokuapp.com/](http://alcms-demo.herokuapp.com/ "Live demo")

Setup
-----

Put into gemfile:

    gem 'alcms', git: 'https://github.com/AgentLemon/alcms.git'

Run:
    
    bundle exec rake alcms:install
    
Modify layouts:

    <head>
      ...
      = alcms_header    
    </head>
    <body>
      = alcms_editor
      ...
    </body>


Configuration
-------------

Edit mode and permissions - config/initializers/alcms.rb:

    Alcms::Engine.setup do |config|
      config.editor_mode_condition do
        params[:editor]
      end
      
      config.can_save_condition do
        current_user.admin?
      end
    end
    
Additional styles - public/alcms/styles.js:

    CKEDITOR.stylesSet.add('alcms_styles', [
      {
        name: 'Red marker text',
        element: 'div',
        styles: {
          'color': 'red',
          'font-weight': 'bold',
          'background-color': 'yellow'
        },
        attributes: {
          class: 'red-marker-bold'
        }
      }
    ]);

Usage
-----

In a view:

    = render_cms_block <block name>, <text name>, classes: <additional classes>, readonly: <true|false> do
      default markup

Tests
-----

    rake app:db:migrate && rake app:db:test:prepare
    bundle exec rspec
