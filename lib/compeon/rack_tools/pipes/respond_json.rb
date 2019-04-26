module Compeon
  module RackTools
    module Pipes
      RESPOND_JSON = lambda do |body:, status: 200, headers: {}|
        headers['Content-Type'] ||= 'application/json'

        RESPOND.call(
          body: JSON.pretty_generate(body),
          headers: headers,
          status: status
        )
      end
    end
  end
end
