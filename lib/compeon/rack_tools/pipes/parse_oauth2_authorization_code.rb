# frozen_string_literal: true

require 'compeon/rack_tools/http_errors'
require 'compeon/rack_tools/pipes/log'

module Compeon
  module RackTools
    module Pipes
      PARSE_OAUTH2_AUTHORIZATION_CODE = lambda do |code:, **rest|
        token = Compeon::AccessToken.parse(code)

        { token: token, **rest }
      rescue Compeon::AccessToken::ParseError
        raise Compeon::RackTools::UnprocessableEntityError
      end
    end
  end
end
