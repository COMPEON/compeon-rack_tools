# frozen_string_literal: true

module Compeon
  module RackTools
    module Pipes
      LOG = lambda do |data|
        $stdout.puts data if Compeon::RackTools::Pipes.logging
        data
      end

      class << self
        def logging
          @logging ||= ENV['LOGGING'] || ENV['RACK_ENV'] == 'development'
        end

        attr_writer :logging
      end
    end
  end
end
