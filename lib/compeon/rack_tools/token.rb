# frozen_string_literal: true

require 'jwt'
require 'open-uri'

module Compeon
  module RackTools
    module Token
      class ParseError < RuntimeError; end
      class InvalidTokenKindError < ParseError; end

      AccessToken = Struct.new(:client_id, :role, :user_id, keyword_init: true)
      AuthorizationToken = Struct.new(:client_id, :user_id, :redirect_uri, keyword_init: true)

      class << self
        def parse_access_token(token)
          access_token = parse_token(token, 'access')

          AccessToken.new(
            client_id: access_token.fetch('cid'),
            role: access_token.fetch('role'),
            user_id: access_token.fetch('uid')
          )
        end

        def parse_authorization_token(token)
          access_token = parse_token(token, 'auth')

          AuthorizationToken.new(
            client_id: access_token.fetch('cid'),
            user_id: access_token.fetch('uid'),
            redirect_uri: access_token['uri']
          )
        end

        private

        def environment
          ENV.fetch('ENVIRONMENT')
        end

        def public_key
          @public_key ||= begin
            env_subdomain = environment != 'production' ? ".#{environment}" : nil
            public_key_string = URI.parse("https://login#{env_subdomain}.compeon.de/public-key").read
            OpenSSL::PKey::RSA.new(public_key_string)
          end
        end

        def parse_token(token, kind)
          JWT.decode(token, public_key, true, algorithm: 'RS256')[0].tap do |parsed_token|
            raise InvalidTokenKindError unless parsed_token['knd'] == kind
          end
        rescue JWT::DecodeError => e
          raise ParseError, e
        end
      end
    end
  end
end
