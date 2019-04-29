# frozen_string_literal: true

require 'test_helper'

require 'compeon/rack_tools/pipes/log'

module Compeon
  module RackTools
    module Pipes
      class LogTest < Minitest::Test
        def teardown
          Compeon::RackTools::Pipes.logging = false
        end

        def log(*args)
          Compeon::RackTools::Pipes::LOG.call(*args)
        end

        def test_logger_enabled
          Compeon::RackTools::Pipes.logging = true
          result = nil

          assert_output "{:test=>:ok}\n" do
            result = log(test: :ok)
          end

          assert_equal({ test: :ok }, result)
        end

        def test_logger_diabled
          result = nil

          assert_output '' do
            result = log(test: :ok)
          end

          assert_equal({ test: :ok }, result)
        end

        def test_logging_default
          assert_equal false, Compeon::RackTools::Pipes.logging
        end

        def test_logging_enabled
          Compeon::RackTools::Pipes.logging = true
          assert_equal true, Compeon::RackTools::Pipes.logging
        end
      end
    end
  end
end
