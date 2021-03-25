# frozen_string_literal: true

require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Okta < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = %{openid profile email}.freeze

      option :name, 'okta'
      option :skip_jwt, false
      option :jwt_leeway, 60

      # These are defaults that need to be overriden on an implementation
      option :client_options, {
        site:                 'https://your-org.okta.com',
        authorize_url:        'https://your-org.okta.com/oauth2/default/v1/authorize',
        token_url:            'https://your-org.okta.com/oauth2/default/v1/token',
        user_info_url:        'https://your-org.okta.com/oauth2/default/v1/userinfo',
        response_type:        'id_token',
        authorization_server: 'default',
        audience:             'api://default'
      }
      option :scope, DEFAULT_SCOPE

      uid { raw_info['sub'] }

      info do
        {
          name:       raw_info['name'],
          email:      raw_info['email'],
          first_name: raw_info['given_name'],
          last_name:  raw_info['family_name'],
          image:      raw_info['picture']
        }
      end

      extra do
        {}.tap do |h|
          h[:raw_info] = raw_info unless skip_info?

          if access_token
            h[:id_token] = access_token.token

            if !options[:skip_jwt] && !access_token.token.nil?
              h[:id_info] = validated_token(access_token.token)
            end
          end
        end
      end

      def client_options
        options.fetch(:client_options)
      end

      alias :oauth2_access_token :access_token

      def access_token
        if oauth2_access_token
          ::OAuth2::AccessToken.new(client, oauth2_access_token.token, {
            refresh_token: oauth2_access_token.refresh_token,
            expires_in:    oauth2_access_token.expires_in,
            expires_at:    oauth2_access_token.expires_at
          })
        end
      end

      def raw_info
        @_raw_info ||= access_token.get(client_options.fetch(:user_info_url)).parsed || {}
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end

      def callback_url
        options[:redirect_uri] || (full_host + callback_path)
      end

      # Returns the qualified URL for the authorization server
      #
      # This is necessary in the case where there is a custom authorization server.
      #
      # Okta provides a default, by default.
      #
      # @return [String]
      def authorization_server_path
        site                 = client_options.fetch(:site)
        authorization_server = client_options.fetch(:authorization_server, 'default')

        "#{site}/oauth2/#{authorization_server}"
      end

      # Specifies the audience for the authorization server
      #
      # By default, this is +'default'+. If using a custom authorization
      # server, this will need to be set
      #
      # @return [String]
      def authorization_server_audience
        client_options.fetch(:audience, 'default')
      end

      def validated_token(token)
        JWT.decode(token,
                   nil,
                   false,
                   verify_iss:        true,
                   verify_aud:        true,
                   iss:               authorization_server_path,
                   aud:               authorization_server_audience,
                   verify_sub:        true,
                   verify_expiration: true,
                   verify_not_before: true,
                   verify_iat:        true,
                   verify_jti:        false,
                   leeway:            options[:jwt_leeway]
        ).first
      end
    end
  end
end
