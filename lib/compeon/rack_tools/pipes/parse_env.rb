# frozen_string_literal: true

require 'compeon/rack_tools/http_errors'
require 'compeon/rack_tools/pipes/log'

module Compeon
  module RackTools
    module Pipes
      PARSE_ENV = lambda do |env|
        request = Rack::Request.new(env)

        body = request.body.read unless request.get? || request.head?

        request = {
          body: body,
          request: request
        }

        Compeon::RackTools::Pipes::LOG.call(request)
      end
    end
  end
end
