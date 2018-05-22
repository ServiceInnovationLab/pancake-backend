# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.0'

# Database
gem 'pg'

# Use Puma as the app server
gem 'puma', '~> 3.7'

# Logins
gem 'devise'
gem 'devise_invitable'

gem 'loofah', '>= 2.2.1'
gem 'rails-html-sanitizer', '>= 1.0.4'

gem 'haml-rails'
gem 'purecss-rails'

gem 'rack-cors', require: 'rack/cors'

gem 'font-awesome-rails'

gem 'raygun4ruby' # exception catcher/logger

gem 'mini_magick' # makes image previews (and can do other stuff)

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'jsonapi-rails', '~> 0.3.0'
gem 'jsonapi_spec_helpers', '~> 0.4', require: false
gem 'jsonapi_suite', '~> 0.7'
gem 'jsonapi_swagger_helpers', '~> 0.6', require: false
gem 'kaminari', '~> 1.0'

gem 'httparty'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'dotenv-rails'
  gem 'factory_bot_rails', '~> 4.0'
  gem 'faker', '~> 1.7'
  gem 'letter_opener'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 3.5.2'
  gem 'rubocop'
  gem 'swagger-diff', '~> 1.1'
end

group :development do
  gem 'travis'
end

group :test do
  gem 'database_cleaner', '~> 1.6'
  gem 'simplecov', require: false
end
