module Dredd
  module Rack

    # Hold the Dredd::Rack global configuration.
    module Configuration

      # Return the application to be tested locally
      def app
        @@app
      end

      # Set the application to be tested locally
      #
      # Any Dredd::Rack::Runner configured to run locally will serve
      # this application from a Capybara::Server instance.
      #
      # object - the application Constant
      def app=(object)
        @@app = object
      end

      # Default configuration
      @@app = nil

    end
  end
end
