# frozen_string_literal: true

require 'compeon/rack_tools/http_errors'
require 'compeon/token'

module Compeon
  module RackTools
    module Pipes
      PARSE_TOKEN = lambda do |key: nil|
        raise "Invalid key of class `#{key.class}` given." unless key.is_a?(OpenSSL::PKey::RSA)

        lambda do |request:, **rest|
          token_string = request.env['HTTP_AUTHORIZATION']&.match(/^token (?<token>.*)/)&.named_captures&.[]('token')

          raise Compeon::RackTools::UnauthorizedError unless token_string

          token = Compeon::Token::Access.decode(encoded_token: token_string, key: key)

          {
            token: token,
            request: request,
            **rest
          }
        rescue Compeon::Token::DecodeError
          raise Compeon::RackTools::UnauthorizedError
        end
      end
    end
  end
end
