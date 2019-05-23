# frozen_string_literal: true

require 'compeon/rack_tools/pipes/respond'

module Compeon
  module RackTools
    module Pipes
      RESPOND_HTML = lambda do |body:, status: 200, header: {}|
        header['Content-Type'] ||= 'text/html'

        RESPOND.call(
          body: body,
          header: header,
          status: status
        )
      end
    end
  end
end
