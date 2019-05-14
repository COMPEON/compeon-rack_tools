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
          token = JWT.encode({ cid: 'client-id', knd: 'access', role: 'role', uid: 'user-id' }, AUTH_KEY, 'RS256')
          request = Rack::Request.new('HTTP_AUTHORIZATION' => "token #{token}")
          result = Compeon::RackTools::Pipes::PARSE_TOKEN.call(request: request)

          assert_equal(request, result[:request])

          token = result[:token]

          assert_equal('client-id', token.client_id)
          assert_equal('role', token.role)
          assert_equal('user-id', token.user_id)
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
