# frozen_string_literal: true

require 'compeon/rack_tools/pipes/log'

module Compeon
  module RackTools
    module Pipes
      RESPOND = lambda do |body:, status: 200, header: {}|
        LOG.call(
          status: status,
          header: header,
          body: body
        )

        [status, header, [body]]
      end
    end
  end
end
