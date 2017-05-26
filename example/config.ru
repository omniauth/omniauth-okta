require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'omniauth-okta'

class OktaExample < Sinatra::Base
  use Rack::Session::Cookie

  get '/' do
    redirect '/auth/okta'
  end

  get '/auth/:provider/callback' do
    content_type 'text/plain'
    request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
  end

  get '/auth/failure' do
    content_type 'text/plain'
    request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
  end

  use OmniAuth::Builder do
    provider OmniAuth::Strategies::Okta, "consumer_key", "consumer_secret"
  end
end

run OktaExample.run!
