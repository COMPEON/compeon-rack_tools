# frozen_string_literal: true

require 'compeon/rack_tools/http_errors'
require 'compeon/rack_tools/pipes/log'

module Compeon
  module RackTools
    module Pipes
      EXTRACT_PARAMETERS_FROM_REQUEST = lambda do |parameter_names:, required: true|
        lambda do |request:, **rest|
          parameters = parameter_names.each_with_object({}) do |name, result|
            parameter = request.params[name.to_s]

            raise Compeon::RackTools::UnprocessableEntityError, "Parameter `#{name}` is missing" if required && parameter.nil?

            result[name.to_s.tr('-', '_').to_sym] = parameter
          end

          LOG.call("Extracted request parameters: #{parameters}")

          { **rest, **parameters, request: request }
        end
      end
    end
  end
end
