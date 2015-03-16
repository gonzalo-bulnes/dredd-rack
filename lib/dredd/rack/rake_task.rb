require 'capybara'
require 'rainbow'
require 'rake'
require 'rake/tasklib'

module Dredd
  module Rack

    # A clonable Rake task powered by a Dredd::Rack::Runner
    #
    # Examples:
    #
    #    require 'dredd/rack'
    #    Dredd::Rack::RakeTask.new # run it with `rake dredd`
    #
    #    # Customize the name or description of the Rake task:
    #    namespace :blueprint do
    #      desc 'Verify an API complies with its blueprint'
    #      Dredd::Rack::RakeTask.new(:verify)
    #    end
    #    # run it with `rake blueprint:verify`
    #
    class RakeTask < ::Rake::TaskLib

      # Return the task's name
      attr_reader :name

      # Return the task's description
      attr_reader :description

      # Return the Dredd::Rack::Runner instance
      attr_reader :runner

      # Define a task with a custom name, arguments and description
      def initialize(*args)
        @name = args.shift || :dredd
        @description = 'Run Dredd::Rack API blueprint verification'
        @runner = Dredd::Rack::Runner.new(ENV['API_HOST'])

        desc description unless ::Rake.application.last_comment
        task name, args do
          run_task(runner)
        end
      end

      def run_task(runner)
  abort Dredd::Rack::RakeTask.dredd_not_available_message unless Dredd::Rack::RakeTask.dredd_available?

  puts Dredd::Rack::RakeTask.starting_message

  puts Dredd::Rack::RakeTask.command_message(runner)

  success = runner.run
  exit_status = $?.exitstatus

  puts Dredd::Rack::RakeTask.connection_error_message(runner) unless success if Dredd::Rack::RakeTask.dredd_connection_error?(exit_status)

  abort unless exit_status == 0
      end

      def self.dredd_available?
        `which dredd`
        $?.exitstatus == 0
      end

      def self.dredd_connection_error?(exit_status)
        exit_status == 8
      end

      def self.command_message(runner)
        <<-eos.gsub /^( |\t)+/, ""
          #{runner.command}

        eos
      end

      def self.connection_error_message(runner)
        <<-eos.gsub /^( |\t)+/, ""

          #{Rainbow("Something went wrong.").red}
          Maybe your API is not being served at #{runner.api_endpoint}?

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
