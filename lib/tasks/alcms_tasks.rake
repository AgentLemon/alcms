namespace :alcms do
  task :install do
    color_print "\ninstalling alcms..."

    # bundle exec rake alcms:install:migrations
    install_migrations
    # application_helper.rb << include Alcms::ApplicationHelper
    modify_application_helper
    # routes.rb << mount Alcms::Engine => '/alcms'
    modify_routes_rb
    # create config/initializers/alcms.rb
    create_alcms_rb
    # create public/alcms/styles.js
    create_styles_js

    color_print "\ninstalling alcms - done!", :green
  end

  COLORS = { black: 0, red: 31, green: 32, blue: 34 }

  def color_print(msg, color = :black)
    print("\033[0;#{COLORS[color]};49m#{msg}\n\033[0m")
  end

  def dir
    @dir ||= Dir.new(File.dirname(__FILE__))
  end

  def file_path(filename)
    File.join(dir, 'files', filename)
  end

  def create_alcms_rb
    color_print "\ncreating config/initializers/alcms.rb..."
    path = Rails.root.join('config', 'initializers', 'alcms.rb')

    if File.exists?(path)
      color_print "config/initializers/alcms.rb already exists\nskip!", :red
    else
      FileUtils.copy_file(file_path('alcms.rb'), path)
      color_print "success!", :green
    end
  end

  def create_styles_js
    color_print "\ncreating public/alcms/styles.js..."
    path = Rails.root.join('public', 'alcms', 'styles.js')

    if File.exists?(path)
      color_print "public/alcms/styles.js already exists\nskip!", :red
    else
      dir_path = Rails.root.join('public', 'alcms')
      FileUtils.mkdir(dir_path) unless File.exists?(dir_path)

      FileUtils.copy_file(file_path('styles.js'), path)
      color_print "success!", :green
    end
  end

  def install_migrations
    color_print "\ninstalling migrations..."
    %x[bundle exec rake alcms:install:migrations]
    color_print "success!", :green
  end

  def modify_application_helper
    file_path = Rails.root.join('app', 'helpers', 'application_helper.rb')
    predicate_line = 'module ApplicationHelper'
    line = 'include Alcms::ApplicationHelper'
    modify_file(file_path, predicate_line, line)
  end

  def modify_routes_rb
    file_path = Rails.root.join('config', 'routes.rb')
    predicate_line = 'Rails.application.routes.draw do'
    line = "mount Alcms::Engine => '/alcms'"
    modify_file(file_path, predicate_line, line)
  end

  def modify_file(file_path, predicate_line, line)
    color_print "\nmodifying #{file_path}..."
    return color_print("can't find #{file_path}\nfail!", :red) unless File.exists?(file_path)
    return color_print("already modified\nskip!", :red) if file_contains?(file_path, line)
    if insert_line(file_path, predicate_line, line)
      color_print("success!", :green)
    else
      color_print("can't modify\nfail!", :red)
    end
  end

  def file_contains?(file_path, line)
    regexp = Regexp.new(line.gsub(' ', '\\s+'))
    File.open(file_path, 'r') do |f|
      f.each_line { |l| return true if l.match(regexp) }
    end
    false
  end

  def insert_line(file_path, predicate_line, line)
    regexp = Regexp.new(predicate_line.gsub(' ', '\\s+'))

    temp_path = "#{file_path}.tmp"
    temp_file = File.open(temp_path, 'w')
    found_predicate = false
    File.open(file_path) do |f|
      f.each do |l|
        temp_file << l
        if l.match(regexp)
          temp_file << "  #{line}\n\n"
          found_predicate = true
        end
      end
    end
    temp_file.close

    if found_predicate
      FileUtils.mv(temp_path, file_path)
      true
    else
      false
    end
  end
end
