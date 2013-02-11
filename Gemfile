require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']

source 'https://rubygems.org'

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'json', '1.7.7'

gem 'haml-rails',     '~> 0.3.5'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
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

group :development do
  gem "guard-livereload"
  gem "yajl-ruby"
  gem "rack-livereload"
  gem "guard-bundler"
  gem "guard-rspec"
end

gem "httparty"
gem "octokit", :git => 'https://github.com/pengwynn/octokit.git'
gem "rspec-rails", :group => [:development, :test]
gem "factory_girl_rails", :group => :test
gem 'shoulda-matchers', :group => :test
gem 'fakeweb', :group => :test
gem "simple_form"
gem "kaminari"
gem 'bootstrap_kaminari'
gem 'tinder'
