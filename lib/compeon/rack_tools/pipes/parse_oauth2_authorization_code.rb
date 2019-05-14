# frozen_string_literal: true

require 'compeon/rack_tools/http_errors'
require 'compeon/rack_tools/pipes/log'
require 'compeon/rack_tools/token'

module Compeon
  module RackTools
    module Pipes
      PARSE_OAUTH2_AUTHORIZATION_CODE = lambda do |code:, **rest|
        token = Compeon::RackTools::Token.parse_authorization_token(code)

        LOG.call("Parsed OAuth2 authorization code: #{token}")

        { token: token, **rest }
      rescue Compeon::RackTools::Token::ParseError
        raise Compeon::RackTools::UnprocessableEntityError
      end
    end
  end
end
