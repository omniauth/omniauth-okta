# frozen_string_literal: true

# Sample app for Okta OAuth2 Strategy
# Make sure to setup the ENV variables OKTA_CLIENT_ID and OKTA_CLIENT_SECRET
# Run with "bundle exec rackup"

require 'bundler/setup'
require 'sinatra/base'
require 'omniauth-okta'

class OktaExample < Sinatra::Base
  use Rack::Session::Cookie, :secret => 'sUp3rs3cr3t'

  get '/' do
    redirect '/auth/okta'
  end

  get '/auth/:provider/callback' do
    content_type 'application/json'
    request.env['omniauth.auth'].to_hash.inspect rescue 'No Data'
  end

  get '/auth/failure' do
    content_type 'text/plain'
    request.env['omniauth.auth'].to_hash.inspect rescue 'No Data'
  end

  use OmniAuth::Builder do
    provider :okta, ENV['OKTA_CLIENT_ID'], ENV['OKTA_CLIENT_SECRET']
  end
end

run OktaExample.run!
