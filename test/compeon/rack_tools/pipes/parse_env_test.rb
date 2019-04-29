# frozen_string_literal: true

require 'test_helper'

require 'compeon/rack_tools/pipes/parse_env'

module Compeon
  module RackTools
    module Pipes
      class ParseEnvTest < Minitest::Test
        def env
          Rack::MockRequest.env_for('', input: 'foobar', method: 'POST')
        end

        def test_parser
          parsed_env = Compeon::RackTools::Pipes::PARSE_ENV.call(env)

          assert_kind_of Hash, parsed_env
          assert_equal 'foobar', parsed_env[:body]
          assert_kind_of Rack::Request, parsed_env[:request]
        end
      end
    end
  end
end
