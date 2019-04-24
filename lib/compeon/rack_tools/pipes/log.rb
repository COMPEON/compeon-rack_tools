module Compeon
  module RackTools
    module Pipes
      LOG = lambda do |data|
        puts data if Compeon::RackTools::Pipes.logging
        data
      end

      class << self
        def logging
          @logging ||= ENV['LOGGING'] || ENV['RACK_ENV'] == 'development'
        end

        def logging=(value)
          @logging = value
        end
      end
    end
  end
end
