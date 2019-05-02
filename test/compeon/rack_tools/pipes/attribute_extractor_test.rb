# frozen_string_literal: true

require 'test_helper'

require 'compeon/rack_tools/pipes/extract_json_api_attributes'

module Compeon
  module RackTools
    module Pipes
      class ExtractJsonApiAttributesTest < Minitest::Test
        def body
          @body ||= {
            data: {
              attributes: {
                foo: 'Foo',
                bar: 'Bar'
              }
            }
          }
        end

        def attribute_extractor
          EXTRACT_JSON_API_ATTRIBUTES.call(required_attributes: %i[foo bar])
        end

        def test_ok
          result = attribute_extractor.call(body: body, something: :else)

          assert_equal 4, result.size
          assert_equal result[:foo], 'Foo'
          assert_equal result[:bar], 'Bar'
          assert_equal result[:something], :else
        end

        def test_data_missing
          body.delete :data

          assert_raises Compeon::RackTools::UnprocessableEntityError do
            attribute_extractor.call(body: body)
          end
        end

        def test_attributes_missing
          body.dig(:data).delete :attributes

          assert_raises Compeon::RackTools::UnprocessableEntityError do
            attribute_extractor.call(body: body)
          end
        end

        def test_attribute_missing
          body.dig(:data, :attributes).delete :foo

          assert_raises Compeon::RackTools::UnprocessableEntityError do
            attribute_extractor.call(body: body)
          end
        end
      end
    end
  end
end
