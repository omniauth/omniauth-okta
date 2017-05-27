require 'omniauth-oauth2'

module Omniauth
  module Strategies
    class Okta < OmniAuth::Strategies::OAuth2

      ORG = 'techstars'
      DOMAIN = 'oktapreview'
      BASE_URL = "https://#{ORG}.#{DOMAIN}.com"

      option :name, 'okta'

      option :client_options, {
        :site => BASE_URL,
        :authorize_url => "#{BASE_URL}/oauth2/v1/authorize",
        :token_url => "#{BASE_URL}/oauth2/v1/token",
        :response_type => 'id_token',
        :client_id => 'nxww2IW6uB51i76PJGrq',
      }

      option :scope, 'openid profile email'

      uid { info['sub'] }

      info do
        raw_info.parsed
      end

      extra do
        { :raw_info => raw_info }
      end

      alias :oauth2_access_token :access_token

      def access_token
        ::OAuth2::AccessToken.new(client, oauth2_access_token.token, {
          :expires_in => oauth2_access_token.expires_in,
          :expires_at => oauth2_access_token.expires_at
        })
      end

      def raw_info
        @_raw_info ||= access_token.get('/oauth2/v1/userinfo')
      end

      def request_phase
        super
      end

      def callback_phase
        super
      end

      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end
    end
  end
end
