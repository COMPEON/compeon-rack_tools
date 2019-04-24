module Compeon
  module RackTools
    module MiddleWeres
      class JSONAPIError
        def initialize(app)
          @app = app
        end

        def call(env)
          @app.call(env)
        rescue Rack::Tools::HTTPError => e
          puts e.full_message
          json_api_error(e)
        rescue StandardError => e
          puts e.full_message
          [500, {}, ['Unknown Error']]
        end

        private

        # TODO: implement `errors.details`
        def json_api_error(exception)
          status_code = exception.status_code
          status_message = exception.status_message

          body = JSON.pretty_generate(
            errors: [
              {
                status: status_code.to_s,
                code: status_message.tr(' ', '-').downcase,
                title: "#{status_code} (#{status_message})"
              }
            ]
          )

          [exception.status_code, {}, [body]]
        end
      end
    end
  end
end
