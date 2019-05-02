# frozen_string_literal: true

require 'test_helper'

require 'compeon/rack_tools/middlewares/jsonapi_error'
require 'rack/test'

module Compeon
  module RackTools
    module Middlewares
      class JSONAPIErrorTest < Minitest::Test
        include Rack::Test::Methods

        CustomError = Class.new(StandardError)

        def app # rubocop:disable Metrics/MethodLength
          Rack::Builder.new do
            use Rack::Lint # verifies that Compeon::RackTools::Middlewares::JSONAPIError returns an valid response
            use Compeon::RackTools::Middlewares::JSONAPIError

            map '/no_error' do
              run ->(*) { [200, { 'Content-Type' => 'application/json' }, ['ok']] }
            end

            map '/rack_tools_error' do
              run ->(*) { raise Compeon::RackTools::UnauthorizedError }
            end

            map '/custom_error' do
              run ->(*) { raise CustomError }
            end
          end
        end

        def header(content_length)
          {
            'Content-Type' => 'application/json',
            'Content-Length' => content_length.to_s
          }
        end

        def test_do_nothing_without_error
          assert_silent do
            get '/no_error'
          end

          assert_equal 200, last_response.status
          assert_equal header(2), last_response.header
          assert_equal 'ok', last_response.body
        end

        def test_rack_tools_error
          assert_output nil, /#{__FILE__}.*Compeon::RackTools::UnauthorizedError/ do
            get '/rack_tools_error'
          end

          assert_equal 401, last_response.status
          assert_equal header(122), last_response.header
          assert_equal <<~JSON.chomp, last_response.body
            {
              "errors": [
                {
                  "status": "401",
                  "code": "unauthorized",
                  "title": "401 (Unauthorized)"
                }
              ]
            }
          JSON
        end

        def test_custom_error
          assert_output nil, /#{__FILE__}.*CustomError/ do
            get '/custom_error'
          end

          assert_equal 500, last_response.status
          assert_equal header(124), last_response.header
          assert_equal <<~JSON.chomp, last_response.body
            {
              "errors": [
                {
                  "status": "500",
                  "code": "unknown-error",
                  "title": "500 (Unknown Error)"
                }
              ]
            }
          JSON
        end
      end
    end
  end
end
