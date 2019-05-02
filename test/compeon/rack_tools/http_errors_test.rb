# frozen_string_literal: true

require 'test_helper'

require 'compeon/rack_tools/http_errors'

module Compeon
  module RackTools
    class HTTPErrorsTest < Minitest::Test
      def error_classes
        namespace = ::Compeon::RackTools
        namespace
          .constants
          .map(&namespace.method(:const_get))
          .select { |error_class| error_class.to_s.end_with?('Error') }
          .select { |error_class| error_class < Compeon::RackTools::HTTPError }
      end

      def test_http_error
        assert Compeon::RackTools::HTTPError < StandardError
      end

      def test_that_all_errors_are_defined
        assert_equal 37, error_classes.count
      end

      def test_errors_are_subclass_of_http_error
        error_classes.each do |error_class|
          assert_equal Compeon::RackTools::HTTPError, error_class.superclass
        end
      end

      def test_only_error_codes_eq_gt_400
        error_classes.each do |error_class|
          assert_operator 400, :<=, error_class.status_code
        end
      end
    end
  end
end
