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

      # Return the command to be runned to invoke Dredd
      def dredd_command
        @@dredd_command
      end

      # Set a custom Dredd command
      #
      # command - the command String
      def dredd_command=(command)
        @@dredd_command = command
      end

      # Default configuration
      @@app = nil
      @@dredd_command = 'dredd'

    end
  end
end
