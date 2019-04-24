module Compeon
  module RackTools
    HTTPError = Class.new(StandardError)

    Rack::Utils::HTTP_STATUS_CODES.each do |status_code, status_message|
      next if status_code <= 400

      name = status_message.tr(' ', '').tr('-', '') + 'Error'

      klass = Class.new(HTTPError) do
        @status_code = status_code
        @status_message = status_message

        def status_code
          self.class.status_code
        end

        def status_message
          self.class.status_message
        end

        class << self
          attr_reader :status_code, :status_message
        end
      end

      const_set(name, klass)
    end
  end
end
