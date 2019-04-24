module Compeon
  module RackTools
    module Pipes
      PARSE_BODY = lambda do |request|
        JSON.parse(request.body.read, symbolize_names: true)
      rescue JSON::ParserError
        raise Rack::Tools::UnprocessableEntityError
      end
    end
  end
end
