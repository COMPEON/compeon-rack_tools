# frozen_string_literal: true

require 'test_helper'

require 'compeon/rack_tools/pipes/parse_token'

module Compeon
  module RackTools
    module Pipes
      class ParseTokenTest < Minitest::Test
        AUTH_KEY = OpenSSL::PKey::RSA.new(512)

        def setup
          Compeon::RackTools::Token.public_key = AUTH_KEY.public_key
        end

        def teardown
          Compeon::RackTools::Token.public_key = nil
        end

        def test_parse_token_ok
          parser = Compeon::RackTools::Pipes::PARSE_TOKEN.call
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
          parser = Compeon::RackTools::Pipes::PARSE_TOKEN.call
          assert_raises Compeon::RackTools::UnauthorizedError do
            parser.call(request: Rack::Request.new({}))
          end
        end

        def test_parse_gibberish_token
          parser = Compeon::RackTools::Pipes::PARSE_TOKEN.call
          request = Rack::Request.new('HTTP_AUTHORIZATION' => 'token ulf')

          assert_raises Compeon::RackTools::UnauthorizedError do
            parser.call(request: request)
          end
        end

        def test_parse_token_with_key_ok
          parser = Compeon::RackTools::Pipes::PARSE_TOKEN.call(key: AUTH_KEY.public_key)
          token = JWT.encode({ cid: 'client-id', knd: 'access', role: 'role', uid: 'user-id' }, AUTH_KEY, 'RS256')
          request = Rack::Request.new('HTTP_AUTHORIZATION' => "token #{token}")
          result = parser.call(request: request)

          assert_equal(request, result[:request])

          token = result[:token]

          assert_equal('client-id', token.client_id)
          assert_equal('role', token.role)
          assert_equal('user-id', token.user_id)
        end

        def test_parse_no_token_with_key
          parser = Compeon::RackTools::Pipes::PARSE_TOKEN.call(key: AUTH_KEY.public_key)
          assert_raises Compeon::RackTools::UnauthorizedError do
            parser.call(request: Rack::Request.new({}))
          end
        end

        def test_parse_gibberish_token_with_key
          parser = Compeon::RackTools::Pipes::PARSE_TOKEN.call(key: AUTH_KEY.public_key)
          request = Rack::Request.new('HTTP_AUTHORIZATION' => 'token ulf')

          assert_raises Compeon::RackTools::UnauthorizedError do
            parser.call(request: request)
          end
        end
      end
    end
  end
end
