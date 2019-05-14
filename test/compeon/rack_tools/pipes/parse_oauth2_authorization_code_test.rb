# frozen_string_literal: true

require 'test_helper'

require 'compeon/rack_tools/pipes/parse_oauth2_authorization_code'

module Compeon
  module RackTools
    module Pipes
      class ParseOauth2AuthorizationCodeTest < Minitest::Test
        AUTH_KEY = OpenSSL::PKey::RSA.new(512)

        def setup
          Compeon::RackTools::Token.public_key = AUTH_KEY.public_key
        end

        def teardown
          Compeon::RackTools::Token.public_key = nil
        end

        def test_with_a_valid_code
          code = JWT.encode({ cid: 'client-id', knd: 'auth', uid: 'user-id' }, AUTH_KEY, 'RS256')

          result = Compeon::RackTools::Pipes::PARSE_OAUTH2_AUTHORIZATION_CODE.call(code: code, other_parameter: :stub)
          token = result[:auth_token]

          assert_equal('client-id', token.client_id)
          assert_equal('user-id', token.user_id)

          assert_equal(:stub, result[:other_parameter])
        end

        def test_with_and_invalid_code
          assert_raises Compeon::RackTools::UnprocessableEntityError do
            Compeon::RackTools::Pipes::PARSE_OAUTH2_AUTHORIZATION_CODE.call(code: 'invlid code')
          end
        end
      end
    end
  end
end
