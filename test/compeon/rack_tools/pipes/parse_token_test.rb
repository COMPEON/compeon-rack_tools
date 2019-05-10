# frozen_string_literal: true

require 'test_helper'

require 'compeon/rack_tools/pipes/parse_token'

module Compeon
  module RackTools
    module Pipes
      class ParseTokenTest < Minitest::Test
        KEY = OpenSSL::PKey::RSA.new(512)

        def setup
          Compeon::AccessToken.public_key_string = KEY.public_key.to_s
        end

        def teardown
          Compeon::AccessToken.public_key_string = nil
        end

        def test_parse_token_ok
          token = JWT.encode({
            exp: (Time.now.to_i + 10),
            cid: 'compeon-marketplace',
            knd: 'access',
            role: 'role',
            uid: '1234'
          }, KEY, 'RS256')
          request = Rack::Request.new('HTTP_AUTHORIZATION' => "token #{token}")

          result = Compeon::RackTools::Pipes::PARSE_TOKEN.call(request: request)

          assert_instance_of Compeon::AccessToken, result[:token]
          assert_equal request, result[:request]
        end

        def test_parse_no_token
          assert_raises Compeon::RackTools::UnauthorizedError do
            Compeon::RackTools::Pipes::PARSE_TOKEN.call(request: Rack::Request.new({}))
          end
        end
      end
    end
  end
end
