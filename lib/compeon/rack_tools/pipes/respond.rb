module Compeon
  module RackTools
    module Pipes
      RESPOND = lambda do |body:, status: 200, headers: {}|
        Compeon::RackTools::Pipes::LOG.call(
          status: status,
          header: headers,
          body: body
        )

        [status, headers, [body]]
      end
    end
  end
end
