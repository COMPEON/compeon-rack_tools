# frozen_string_literal: true

require 'compeon/rack_tools/pipes/respond'

module Compeon
  module RackTools
    module Pipes
      RESPOND_JSON = lambda do |body:, status: 200, header: {}|
        header['Content-Type'] ||= 'application/json'

        RESPOND.call(
          body: JSON.pretty_generate(body),
          header: header,
          status: status
        )
      end
    end
  end
end
