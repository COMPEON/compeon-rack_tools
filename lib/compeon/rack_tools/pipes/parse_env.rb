module Compeon
  module RackTools
    module Pipes
      PARSE_ENV = lambda do |env|
        request = Rack::Request.new(env)
        request = {
          body: parse_body(request),
          request: request
        }

        log request
      end
    end
  end
end
