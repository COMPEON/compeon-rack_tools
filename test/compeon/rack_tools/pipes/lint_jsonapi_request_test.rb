# frozen_string_literal: true

require 'test_helper'

require 'compeon/rack_tools/pipes/lint_jsonapi_request'

module Compeon
  module RackTools
    module Pipes
      class LintJSONAPIRequestTest < Minitest::Test
        def body
          @body ||= {
            data: {
              type: 'test-type',
              attributes: {}
            }
          }
        end

        def linter
          LintJSONAPIRequest.call(type: 'test-type')
        end

        def test_ok
          result = linter.call(body: body, something: :else)

          assert_equal 2, result.size
          assert_equal result[:body], body
          assert_equal result[:something], :else
        end

        def test_type_missing
          body.dig(:data).delete :type

          assert_raises Compeon::RackTools::UnprocessableEntityError do
            linter.call(body: body)
          end
        end

        def test_type_wrong
          body[:data][:type] = 'wrong-type'

          assert_raises Compeon::RackTools::UnprocessableEntityError do
            linter.call(body: body)
          end
        end

        def test_attributes_missing
          body.dig(:data).delete :attributes

          assert_raises Compeon::RackTools::UnprocessableEntityError do
            linter.call(body: body)
          end
        end
      end
    end
  end
end
