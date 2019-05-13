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
        AUTH_KEY = OpenSSL::PKey::RSA.new(512)

        def build_request(token: nil)
          header = token ? { 'HTTP_AUTHORIZATION' => "token #{token}" } : {}
          Rack::Request.new(header)
        end

        def test_parse_token_ok
          request = build_request(token: JWT.encode({ cid: 'client-id', knd: 'access', role: 'role', uid: 'user-id' }, AUTH_KEY, 'RS256'))
          result = nil

          Compeon::RackTools::Token.stub :public_key, AUTH_KEY.public_key do
            result = Compeon::RackTools::Pipes::PARSE_TOKEN.call(request: request)
          end

          assert_equal(request, result[:request])

          token = result[:token]

          assert_equal('client-id', token.client_id)
          assert_equal('role', token.role)
          assert_equal('user-id', token.user_id)
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
