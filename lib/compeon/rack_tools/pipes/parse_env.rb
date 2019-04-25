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

        log request
      end
    end
  end
end
