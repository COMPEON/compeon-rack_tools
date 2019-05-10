# frozen_string_literal: true

require 'compeon/rack_tools/http_errors'

begin
  require 'compeon/access_token'
rescue LoadError
  raise <<~ERROR
    You need to add `gem 'compeon-access_token'`,
    to use `Compeon::RackTools::Pipes::PARSE_TOKEN`.
  ERROR
end

module Compeon
  module RackTools
    module Pipes
      PARSE_TOKEN = lambda do |request:, **rest|
        token_string = request.env['HTTP_AUTHORIZATION']&.match(/^token (?<token>.*)/)&.named_captures&.[]('token')

        raise Compeon::RackTools::UnauthorizedError unless token_string

        token = Compeon::AccessToken.parse(token_string)

        {
          token: token,
          request: request,
          **rest
        }
      end
    end
  end
end
