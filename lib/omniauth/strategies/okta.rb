require 'omniauth-oauth2'

module Omniauth
  module Strategies

    class Okta < OmniAuth::Strategies::OAuth2

      BASE_URL = "https://#{ORG}.okta.com/api/v1/authn"

      option :name, 'okta'

      option :client_options, {
        :site => BASE_URL,
        :authorize_url => "#{BASE_URL}/v1/oauth/authorize",
        :token_url => "#{BASE_URL}/oauth/v2/accessToken"
      }

      uid { raw_info.id }

      info do
        {
          :id => raw_info.id,
          :name => raw_info.name
        }
      end

      extra do
        { :raw_info => raw_info }
      end

      def raw_info
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
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
