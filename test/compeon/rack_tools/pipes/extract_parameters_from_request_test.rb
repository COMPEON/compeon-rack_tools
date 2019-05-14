# frozen_string_literal: true

require 'test_helper'

require 'compeon/rack_tools/pipes/extract_parameters_from_request'

module Compeon
  module RackTools
    module Pipes
      class ExtractParametersTest < Minitest::Test
        def test_with_present_params
          request = Rack::Request.new(
            Rack::RACK_INPUT => '',
            Rack::QUERY_STRING => 'param=present&param2=another-param'
          )
          extractor = Compeon::RackTools::Pipes::EXTRACT_PARAMETERS_FROM_REQUEST.call(parameter_names: %w[param param2])

          assert_equal(extractor.call(request: request), request: request, param: 'present', param2: 'another-param')
        end

        def test_with_missing_params
          request = Rack::Request.new(
            Rack::RACK_INPUT => '',
            Rack::QUERY_STRING => 'param=present'
          )
          extractor = Compeon::RackTools::Pipes::EXTRACT_PARAMETERS_FROM_REQUEST.call(parameter_names: %w[param param2])

          assert_raises Compeon::RackTools::UnprocessableEntityError do
            extractor.call(request: request)
          end
        end

        def test_with_unrequired_params
          request = Rack::Request.new(Rack::RACK_INPUT => '', Rack::QUERY_STRING => 'param=present')
          extractor = Compeon::RackTools::Pipes::EXTRACT_PARAMETERS_FROM_REQUEST.call(
            parameter_names: %w[param param2],
            required: false
          )

          assert_equal(extractor.call(request: request), request: request, param: 'present', param2: nil)
        end

        def test_with_symbol_names
          request = Rack::Request.new(
            Rack::RACK_INPUT => '',
            Rack::QUERY_STRING => 'param=present&param2=another-param'
          )
          extractor = Compeon::RackTools::Pipes::EXTRACT_PARAMETERS_FROM_REQUEST.call(parameter_names: %i[param param2])

          assert_equal(extractor.call(request: request), request: request, param: 'present', param2: 'another-param')
        end
      end
    end
  end
end
