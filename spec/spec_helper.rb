require 'rubygems'
require 'bundler'
require 'hub/samples'
require 'spree/testing_support/controllers'

Bundler.require(:default, :test)

require File.join(File.dirname(__FILE__), '..', 'mailchimp_endpoint.rb')
Dir["./spec/support/**/*.rb"].each(&method(:require))

Sinatra::Base.environment = 'test'

def app
  AuguryEndpoint
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Spree::TestingSupport::Controllers
end

ENV['ENDPOINT_KEY'] = 'x123'
