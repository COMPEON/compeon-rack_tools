# frozen_string_literal: true

require 'compeon/rack_tools/http_errors'

module Compeon
  module RackTools
    module Pipes
      PARSE_TOKEN = lambda do |request:, **rest|
        token_string = request.env['HTTP_AUTHORIZATION']&.match(/^token (?<token>.*)/)&.named_captures&.[]('token')

        raise Compeon::RackTools::UnauthorizedError unless token_string

        token = Compeon::RackTools::Token.parse_access_token(token_string)

        {
          token: token,
          request: request,
          **rest
        }
      rescue Compeon::RackTools::Token::ParseError
        raise Compeon::RackTools::UnauthorizedError
      end
    end
  end
end
