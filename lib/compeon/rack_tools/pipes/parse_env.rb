require 'compeon/rack_tools/http_errors'
require 'compeon/rack_tools/pipes/log'

module Compeon
  module RackTools
    module Pipes
      PARSE_ENV = lambda do |env|
        request = Rack::Request.new(env)

        body = begin
          JSON.parse(request.body.read, symbolize_names: true)
        rescue JSON::ParserError
          raise Compeon::RackTools::UnprocessableEntityError
        end

        request = {
          body: body,
          request: request
        }

        Compeon::RackTools::Pipes::LOG.call(request)
      end
    end
  end
end
