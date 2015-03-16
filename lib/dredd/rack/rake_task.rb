require 'rake'
require 'rainbow'

# Validate an API against its API blueprint
#
# The API blueprints are expected to be stored in `doc/` and
# have the `.apib` or `.apib.md` extension. (The last one ensures
# that the blueprints are rendered as HTML on Github.)
#
# The 'blueprint:verify' task depends on Dredd being installed but
# does detect automatically if it is not and provides instructions
# to install it.
#
# The task also depends on the API being served at the API_HOST URL,
# detects when the connection is impossible and suggests to set
# the API_HOST environment variable and start the API server.
#
# Usage:
#
#     API_HOST=http://localhost:4567 rake 'blueprint:verify'
#
# Returns nothing but does abort the rake tasks suite if validation fails.
namespace :blueprint do
  require 'capybara'
  desc 'Verify the API blueprint accuracy'
  task :verify do
    # check if the dredd blueprint testing tool is available
    `which dredd`
    if $?.exitstatus != 0
      abort Dredd::Rack::RakeTask.dredd_not_available_message
    end

    puts Dredd::Rack::RakeTask.starting_message

    dredd = Dredd::Rack::Runner.new(ENV['API_HOST'])

    puts Dredd::Rack::RakeTask.command_message(dredd)

    success = dredd.run
    exit_status = $?.exitstatus

    # display a hint when the server may be down
    unless success || exit_status != 8
      puts Dredd::Rack::RakeTask.connection_error_message
    end

    abort unless exit_status == 0
  end
end

module Dredd
  module Rack
    class RakeTask

      def self.command_message(runner)
        <<-eos.gsub /^( |\t)+/, ""
          #{runner.command}

        eos
      end

      def self.connection_error_message
        <<-eos.gsub /^( |\t)+/, ""

          #{Rainbow("Something went wrong.").red}
          Maybe your API is not being served at #{api_host}?

          Note that specifying a different host is easy:
          #{Rainbow('`rake blueprint:verify API_HOST=http://localhost:4567`').yellow}

        eos
      end

      def self.dredd_not_available_message
        <<-eos.gsub /^( |\t)+/, ""

          The #{Rainbow('dredd').red} blueprint testing tool is not available.
          You may want to install it in order to validate the API blueprints.

          Try #{Rainbow('`npm install dredd --global`').yellow} (use `sudo` if necessary)
          or see https://github.com/apiaryio/dredd for instructions.

        eos
      end

      def self.starting_message
        <<-eos.gsub /^( |\t)+/, ""

          #{Rainbow('Verify the API conformance against its blueprint.').blue}
        eos
      end
    end
  end
end
