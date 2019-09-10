# frozen_string_literal: true

require 'test_helper'

require 'compeon/rack_tools/pipes/parse_token'

module Compeon
  module RackTools
    module Pipes
      class ParseTokenTest < Minitest::Test
        AUTH_KEY = OpenSSL::PKey::RSA.new(512)

        def parser
          Compeon::RackTools::Pipes::PARSE_TOKEN.call(key: AUTH_KEY.public_key)
        end

        def test_parse_token_ok
          token = JWT.encode({ cid: 'client-id', knd: 'access', role: 'role', uid: 'user-id' }, AUTH_KEY, 'RS256')
          request = Rack::Request.new('HTTP_AUTHORIZATION' => "token #{token}")
          result = parser.call(request: request)

          assert_equal(request, result[:request])

          token = result[:token]

          assert_equal('client-id', token.client_id)
          assert_equal('role', token.role)
          assert_equal('user-id', token.user_id)
        end

        def test_parse_no_token
          assert_raises Compeon::RackTools::UnauthorizedError do
            parser.call(request: Rack::Request.new({}))
          end
        end

        def test_parse_gibberish_token
          request = Rack::Request.new('HTTP_AUTHORIZATION' => 'token ulf')

          assert_raises Compeon::RackTools::UnauthorizedError do
            parser.call(request: request)
          end
        end


        def test_parse_no_key
          assert_raises 'Invalid key of class `NilClass` given.' do
            Compeon::RackTools::Pipes::PARSE_TOKEN.call(key: nil)
          end
        end
      end
    end
  end
end
