module Compeon
  module RackTools
    module Pipes
      RESPONSE = lambda do |data, status: 200, header: {}|
        body = JSON.pretty_generate(data)
        [status, header, [body]]
      end
    end
  end
end
