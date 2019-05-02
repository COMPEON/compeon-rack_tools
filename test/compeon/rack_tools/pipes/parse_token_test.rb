# frozen_string_literal: true

require 'test_helper'

require 'compeon/rack_tools/pipes/parse_token'

module Compeon
  class AccessToken
    def self.parse(*); end
  end

  module RackTools
    module Pipes
      class ParseTokenTest < Minitest::Test
        def build_request(token: nil)
          header = token ? { 'HTTP_AUTHORIZATION' => "token #{token}" } : {}
          Rack::Request.new(header)
        end

        def test_parse_token_ok
          api_token_mock = :api_token_mock
          request = build_request(token: 'asd123')
          result = nil

          Compeon::AccessToken.stub :parse, api_token_mock do
            result = Compeon::RackTools::Pipes::PARSE_TOKEN.call(request: request)
          end

          assert_equal({ token: api_token_mock, request: request }, result)
        end

        def test_parse_no_token
          assert_raises Compeon::RackTools::UnauthorizedError do
            Compeon::RackTools::Pipes::PARSE_TOKEN.call(request: build_request)
          end
        end
      end
    end
  end
end
