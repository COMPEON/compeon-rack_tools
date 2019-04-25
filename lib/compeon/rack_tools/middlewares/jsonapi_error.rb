require 'compeon/rack_tools/http_errors'

module Compeon
  module RackTools
    module Middlewares
      class JSONAPIError
        def initialize(app)
          @app = app
        end

        def call(env)
          @app.call(env)
        rescue Compeon::RackTools::HTTPError => e
          puts e.full_message
          json_api_error_from_exception(e)
        rescue StandardError => e
          puts e.full_message
          json_api_error(500, 'Unknown Error')
        end

        private

        # TODO: implement `errors.details`
        def json_api_error_from_exception(exception)
          json_api_error(exception.status_code, exception.status_message)
        end

        def json_api_error(status_code, status_message)
          body = JSON.pretty_generate(
            errors: [
              {
                status: status_code.to_s,
                code: status_message.tr(' ', '-').downcase,
                title: "#{status_code} (#{status_message})"
              }
            ]
          )

          [status_code, { 'Content-Type' => 'application/json' }, [body]]
        end
      end
    end
  end
end
