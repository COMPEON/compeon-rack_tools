# frozen_string_literal: true

require 'test_helper'

require 'compeon/rack_tools/pipes/parse_jsonapi_body'

module Compeon
  module RackTools
    module Pipes
      class ParseJsonapiBodyTest < Minitest::Test
        def valid_body
          <<~JSON
            {
              "data": {
                "attributes": {
                  "foo-bar": "baz"
                }
              }
            }
          JSON
        end

        def test_valid
          result = Compeon::RackTools::Pipes::PARSE_JSONAPI_BODY.call(body: valid_body, request: :request)

          expection = {
            data: {
              attributes: {
                foo_bar: 'baz'
              }
            }
          }

          assert_equal expection, result[:body]
          assert_equal :request, result[:request]
        end

        def test_invalid
          assert_raises Compeon::RackTools::UnprocessableEntityError do
            Compeon::RackTools::Pipes::PARSE_JSONAPI_BODY.call(body: '')
          end
        end
      end
    end
  end
end
