$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "alcms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "alcms"
  s.version     = Alcms::VERSION
  s.authors     = ["Agent Lemon"]
  s.email       = ["omelemon@gmail.com"]
  s.homepage    = "http://localhost"
  s.summary     = "CMS for rails"
  s.description = "A gem to help users edit their site content"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails"
  s.add_dependency "slim"
  s.add_dependency "sass-rails"
  s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "codeclimate-test-reporter"
  s.add_development_dependency "tzinfo-data"
end
