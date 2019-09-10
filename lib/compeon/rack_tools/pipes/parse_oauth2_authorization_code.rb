# frozen_string_literal: true

require 'compeon/rack_tools/http_errors'
require 'compeon/rack_tools/pipes/log'
require 'compeon/token'

module Compeon
  module RackTools
    module Pipes
      PARSE_OAUTH2_AUTHORIZATION_CODE = lambda do |key:|
        raise "Invalid key of class `#{key.class}` given." unless key.is_a?(OpenSSL::PKey::RSA)

        lambda do |code:, **rest|
          token = Compeon::Token::Authorization.decode(encoded_token: code, key: key)

          LOG.call("Parsed OAuth2 authorization code: #{token}")

          { auth_token: token, **rest }
        rescue Compeon::Token::DecodeError
          raise Compeon::RackTools::UnprocessableEntityError
        end
      end
    end
  end
end
