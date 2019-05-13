# frozen_string_literal: true

require 'compeon/rack_tools/http_errors'
require 'compeon/rack_tools/pipes/log'
require 'compeon/rack_tools/token'

module Compeon
  module RackTools
    module Pipes
      PARSE_OAUTH2_AUTHORIZATION_CODE = lambda do |code:, **rest|
        token = Compeon::RackTools::Token.parse_authorization_token(code)

        { token: token, **rest }
      rescue Compeon::RackTools::Token::ParseError => e
        raise Compeon::RackTools::UnprocessableEntityError
      end
    end
  end
end
