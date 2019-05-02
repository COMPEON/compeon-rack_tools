# frozen_string_literal: true

require 'test_helper'

require 'compeon/rack_tools/pipes/respond_json'

module Compeon
  module RackTools
    module Pipes
      class RespondTest < Minitest::Test
        def teardown
          Compeon::RackTools::Pipes.logging = false
        end

        def respond(*args)
          Compeon::RackTools::Pipes::RESPOND_JSON.call(*args)
        end

        def test_with_defaults
          result = respond(body: { result: :ok })

          assert_kind_of Array, result

          status, header, body = result
          assert_equal 200, status
          assert_equal({ 'Content-Type' => 'application/json' }, header)
          assert_equal ["{\n  \"result\": \"ok\"\n}"], body
        end

        def test_with_custom_header
          result = respond(body: { result: :ok }, header: { 'Content-Type' => 'application/vnd.api+json' })

          assert_kind_of Array, result

          status, header, body = result
          assert_equal 200, status
          assert_equal({ 'Content-Type' => 'application/vnd.api+json' }, header)
          assert_equal ["{\n  \"result\": \"ok\"\n}"], body
        end

        def test_with_custom_status
          result = respond(body: { result: :ok }, status: 201)

          assert_kind_of Array, result

          status, header, body = result
          assert_equal 201, status
          assert_equal({ 'Content-Type' => 'application/json' }, header)
          assert_equal ["{\n  \"result\": \"ok\"\n}"], body
        end

        def test_with_logging
          Compeon::RackTools::Pipes.logging = true

          assert_output(<<~JSON) { respond(body: 1337) }
            {:status=>200, :header=>{"Content-Type"=>"application/json"}, :body=>"1337"}
          JSON
        end
      end
    end
  end
end
