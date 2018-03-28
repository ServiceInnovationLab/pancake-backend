# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.5'

gem 'pg' # Use postgresql database
gem 'puma', '~> 3.7' # Use Puma as the app server
gem 'sass-rails', '~> 5.0' # Use SCSS for stylesheets

gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'jsonapi-resources'
gem 'turbolinks', '~> 5'

gem 'coffee-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'travis'
end
gem 'loofah', '>= 2.2.1'
gem 'rails-html-sanitizer', '>= 1.0.4'
