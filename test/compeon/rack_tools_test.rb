# frozen_string_literal: true

require 'test_helper'

module Compeon
  class RackToolsTest < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::Compeon::RackTools::VERSION
    end
  end
end
