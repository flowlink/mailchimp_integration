source 'https://rubygems.org'

gem 'activesupport'
gem 'capistrano'
gem 'honeybadger'
gem 'mailchimp-api', require: 'mailchimp'
gem 'sinatra'
gem 'tilt', '~> 1.4.1'
gem 'tilt-jbuilder', require: 'sinatra/jbuilder'

# Must come after sinatra
gem 'endpoint_base', github: 'flowlink/endpoint_base'

group :development do
  gem 'pry'
  gem 'awesome_print'
  gem 'shotgun'
end

group :test do
  gem 'vcr'
  gem 'rspec'
  gem 'webmock'
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'rack-test'
  gem 'hub_samples', github: 'spree/hub_samples'
end

group :production do
  gem 'foreman'
  gem 'unicorn'
end
