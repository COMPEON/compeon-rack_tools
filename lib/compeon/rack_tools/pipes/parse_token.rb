require 'compeon/rack_tools/http_errors'

module Compeon
  module RackTools
    module Pipes
      PARSE_TOKEN = lambda do |request:, **rest|
        token_string = request.get_header('HTTP_AUTHORIZATION')&.match(/^token (?<token>.*)/)&.named_captures&.dig('token')
        token = Compeon::AccessToken.parse(token_string) if token_string

        {
          token: token,
          request: request,
          **rest
        }
      end

      PARSE_TOKEN_BANG = lambda do |**rest|
        data = PARSE_TOKEN.call(**rest)

        raise Compeon::RackTools::UnauthorizedError unless data[:token]

        data
      end
    end
  end
end
