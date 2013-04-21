source 'https://rubygems.org'

require 'rubygems'
source 'http://gemcutter.org'

gem 'rails', '3.2.13'
gem "mongoid", "~> 3.1.2"
gem 'workflow_on_mongoid'
gem 'haml'
gem 'haml-rails'


# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'



# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :development, :test do
  gem "rspec-rails", ">= 2.8.1"
end

group :test do
  gem "factory_girl_rails", ">= 1.6.0"
  gem 'mongoid-rspec'
  gem "cucumber-rails", ">= 1.2.1", :require => false
  gem 'cucumber-rails-training-wheels' # some pre-fabbed step definitions  
  gem "capybara", ">= 1.1.2"
  gem "database_cleaner"
  gem "ZenTest"
  gem 'spork'
  gem "launchy"
  gem "random_text"
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
