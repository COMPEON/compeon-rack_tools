# frozen_string_literal: true

module Compeon
  module RackTools
    module Pipes
      EXTRACT_JSON_API_ATTRIBUTES = lambda do |required_attributes:|
        lambda do |body:, **rest|
          request_attributes = body.dig(:data, :attributes)

          raise Compeon::RackTools::UnprocessableEntityError unless request_attributes

          attributes = required_attributes.each_with_object({}) do |key, attrs|
            attrs[key] = request_attributes.fetch(key) { raise Compeon::RackTools::UnprocessableEntityError }
          end

          {
            body: body,
            **attributes,
            **rest
          }
        end
      end
    end
  end
end
