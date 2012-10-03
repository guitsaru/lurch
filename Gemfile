require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']

source 'https://rubygems.org'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'json'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'haml-rails',     '~> 0.3.5'
  gem 'sass-rails',     '~> 3.2.3'
  gem 'bootstrap-sass', '~> 2.1.0.0'
  gem 'coffee-rails',   '~> 3.2.1'
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
gem 'jbuilder'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

gem "capybara", :group => [:development, :test]
guard_notifications = true
group :development do
  case HOST_OS
  when /darwin/i
    gem 'rb-fsevent'
    gem 'ruby_gntp' if guard_notifications
  when /linux/i
    gem 'libnotify'
    gem 'rb-inotify'
  when /mswin|windows/i
    gem 'rb-fchange'
    gem 'win32console'
    gem 'rb-notifu' if guard_notifications
  end
end

group :development do
  gem "guard-livereload"
  gem "yajl-ruby"
  gem "rack-livereload"
  gem "guard-bundler"
  gem "guard-rspec"
end

gem "pg"
gem "httparty"
gem "octokit"
gem "rspec-rails", :group => [:development, :test]
gem "factory_girl_rails", :group => :test
gem 'shoulda-matchers', :group => :test
gem 'fakeweb', :group => :test
gem "simple_form"
