# frozen_string_literal: true

require 'rack/cors'

module Compeon
  module RackTools
    module Middlewares
      class Cors < Rack::Cors
        def initialize(app)
          super do
            allow do
              origins(/.*/)
              resource '*',
                       headers: %w[authorization content-type origin],
                       methods: :any,
                       credentials: true,
                       expose: %w[link per-page total]
            end
          end
        end
      end
    end
  end
end
