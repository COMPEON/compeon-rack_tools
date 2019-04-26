module Compeon
  module RackTools
    module Pipes
      RESPOND = lambda do |data:, status: 200, header: {}|
        body = JSON.pretty_generate(data)

        header['Content-Type'] ||= 'application/json'

        Compeon::RackTools::Pipes::LOG.call(
          status: status,
          header: header,
          body: body
        )

        [status, header, [body]]
      end
    end
  end
end
