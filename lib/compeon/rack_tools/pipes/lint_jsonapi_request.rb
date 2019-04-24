module Compeon
  module RackTools
    module Pipes
      LintJSONAPIRequest = lambda do |type:|
        lambda do |body:, **rest|
          raise Rack::Tools::UnprocessableEntityError unless body[:data][:type] == type
          raise Rack::Tools::UnprocessableEntityError unless body[:data][:attributes].is_a?(Hash)

          {
            body: body,
            **rest
          }
        end
      end
    end
  end
end
