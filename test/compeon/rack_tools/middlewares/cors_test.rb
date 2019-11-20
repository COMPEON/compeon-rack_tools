# frozen_string_literal: true

require 'test_helper'

require 'compeon/rack_tools/middlewares/cors'
require 'rack/test'

module Compeon
  module RackTools
    module Middlewares
      class CorsTest < Minitest::Test
        include Rack::Test::Methods

        def app
          Rack::Builder.new do
            use Rack::Lint # verifies that Compeon::RackTools::Middlewares::Cors returns an valid response
            use Compeon::RackTools::Middlewares::Cors
            run ->(*) { [200, {}, ['ok']] }
          end
        end

        def test_options
          header 'Access-Control-Request-Method', 'GET'
          header 'Access-Control-Request-Headers', 'authorization'
          header 'Origin', 'http://example.com'
          options '/'

          response_header = last_response.header
          assert_equal 'http://example.com', response_header['Access-Control-Allow-Origin']
          assert_equal 'GET, HEAD, POST, PUT, PATCH, DELETE, OPTIONS', response_header['Access-Control-Allow-Methods']
          assert_equal 'link, per-page, total', response_header['Access-Control-Expose-Headers']
          assert_equal '7200', response_header['Access-Control-Max-Age']
          assert_equal 'authorization', response_header['Access-Control-Allow-Headers']
        end

        def test_post
          header 'Access-Control-Request-Method', 'POST'
          header 'Access-Control-Request-Headers', 'authorization,content-type'
          header 'Origin', 'http://example.com'
          options '/'

          response_header = last_response.header
          assert_equal 'http://example.com', response_header['Access-Control-Allow-Origin']
          assert_equal 'GET, HEAD, POST, PUT, PATCH, DELETE, OPTIONS', response_header['Access-Control-Allow-Methods']
          assert_equal 'link, per-page, total', response_header['Access-Control-Expose-Headers']
          assert_equal '7200', response_header['Access-Control-Max-Age']
          assert_equal 'true', response_header['Access-Control-Allow-Credentials']
          assert_equal 'authorization,content-type', response_header['Access-Control-Allow-Headers']
        end
      end
    end
  end
end
