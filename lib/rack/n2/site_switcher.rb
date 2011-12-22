module Rack
  module N2
    class SiteSwitcher
      def initialize app
        @app = app
      end

      def call env
        @domain = env['HTTP_HOST'].split(':').first # Grab the domain, ignore the port
        Site.current_domain = @domain
        @app.call(env)
      end
    end
  end
end
