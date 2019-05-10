# frozen_string_literal: true

require 'test_helper'

require 'compeon/rack_tools/pipes/parse_oauth2_authorization_code'

module Compeon
  module RackTools
    module Pipes
      class ParseOauth2AuthorizationCodeTest < Minitest::Test
        def test_with_a_valid_code
          api_token_stub = :api_token_stub

          Compeon::AccessToken.stub :parse, api_token_stub do
            assert_equal(Compeon::RackTools::Pipes::PARSE_OAUTH2_AUTHORIZATION_CODE.call(code: 'code'), { token: api_token_stub })
          end
        end

        def test_with_and_invalid_code
          Compeon::AccessToken.stub :parse, -> { raise Compeon::AccessToken::ParseError } do
            assert_raises Compeon::RackTools::UnprocessableEntityError do
              Compeon::RackTools::Pipes::PARSE_OAUTH2_AUTHORIZATION_CODE.call(code: 'code')
            end
          end
        end
      end
    end
  end
end
