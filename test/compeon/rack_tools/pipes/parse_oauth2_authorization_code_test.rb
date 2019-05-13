# frozen_string_literal: true

require 'test_helper'

require 'compeon/rack_tools/pipes/parse_oauth2_authorization_code'

module Compeon
  module RackTools
    module Pipes
      class ParseOauth2AuthorizationCodeTest < Minitest::Test
        AUTH_KEY = OpenSSL::PKey::RSA.new(512)

        def test_with_a_valid_code
          code = JWT.encode({ cid: 'client-id', knd: 'auth', uid: 'user-id' }, AUTH_KEY, 'RS256')

          Compeon::RackTools::Token.stub :public_key, AUTH_KEY.public_key do
            result = Compeon::RackTools::Pipes::PARSE_OAUTH2_AUTHORIZATION_CODE.call(code: code, other_parameter: :stub)
            token = result[:token]

            assert_equal('client-id', token.client_id)
            assert_equal('user-id', token.user_id)

            assert_equal(:stub, result[:other_parameter])
          end
        end

        def test_with_and_invalid_code
          Compeon::RackTools::Token.stub :public_key, AUTH_KEY.public_key do
            assert_raises Compeon::RackTools::UnprocessableEntityError do
              Compeon::RackTools::Pipes::PARSE_OAUTH2_AUTHORIZATION_CODE.call(code: 'invlid code')
            end
          end
        end
      end
    end
  end
end
