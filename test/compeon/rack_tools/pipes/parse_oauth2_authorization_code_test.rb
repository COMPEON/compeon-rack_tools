# frozen_string_literal: true

require 'test_helper'

require 'compeon/rack_tools/pipes/parse_oauth2_authorization_code'

module Compeon
  module RackTools
    module Pipes
      class ParseOauth2AuthorizationCodeTest < Minitest::Test
        AUTH_KEY = OpenSSL::PKey::RSA.new(512)

        def parser
          Compeon::RackTools::Pipes::PARSE_OAUTH2_AUTHORIZATION_CODE.call(key: AUTH_KEY.public_key)
        end

        def test_with_a_valid_code
          code = JWT.encode({ cid: 'client-id', knd: 'auth', uid: 'user-id', uri: 'uri' }, AUTH_KEY, 'RS256')

          result = parser.call(code: code, other_parameter: :stub)
          token = result[:auth_token]

          assert_equal('client-id', token.client_id)
          assert_equal('user-id', token.user_id)

          assert_equal(:stub, result[:other_parameter])
        end

        def test_with_and_invalid_code
          assert_raises Compeon::RackTools::UnprocessableEntityError do
            parser.call(code: 'invlid code')
          end
        end

        def test_parse_no_key
          assert_raises 'Invalid key of class `NilClass` given.' do
            Compeon::RackTools::Pipes::PARSE_OAUTH2_AUTHORIZATION_CODE.call(key: nil)
          end
        end
      end
    end
  end
end
