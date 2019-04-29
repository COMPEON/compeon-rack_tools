# frozen_string_literal: true

module Compeon
  module RackTools
    module Pipes
      PARSE_JSONAPI_BODY = lambda do |body:, **rest|
        begin
          body = JSON.parse(body)
        rescue StandardError => e
          LOG.call(e)
          raise Compeon::RackTools::UnprocessableEntityError
        end

        body = DeepHashTransformer.deep_transform_keys(body) do |key|
          key.tr('-', '_').to_sym
        end

        {
          body: body,
          **rest
        }
      end

      module DeepHashTransformer
        class << self
          def deep_transform_keys(object, &block)
            case object
            when Hash
              object.each_with_object({}) do |(key, value), result|
                result[yield(key)] = deep_transform_keys(value, &block)
              end
            when Array
              object.map { |e| deep_transform_keys(e, &block) }
            else
              object
            end
          end
        end
      end
    end
  end
end
