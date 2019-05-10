# frozen_string_literal: true

require 'compeon/rack_tools/http_errors'
require 'compeon/rack_tools/pipes/log'

module Compeon
  module RackTools
    module Pipes
      EXTRACT_PARAMETERS_FROM_REQUEST = lambda do |parameter_names:, required: true|
        lambda do |request|
          parameters = parameter_names.each_with_object({}) do |name, result|
            parameter = request.params[name]

            raise Compeon::RackTools::UnprocessableEntityError, "Parameter `#{name}` is missing" if required && parameter.nil?

            result[name.to_sym] = parameter
          end

          { **parameters, request: request }
        end
      end
    end
  end
end
