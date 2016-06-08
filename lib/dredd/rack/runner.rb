require 'capybara'

module Dredd
  module Rack

    # A Ruby wrapper around the Dredd API blueprint validation tool
    #
    # Usage:
    #
    #    # run `dredd doc/*.apib doc/*.apib.md http://localhost:XXXX --level warning --dry-run`
    #    # You don't need to start any server, Dredd::Rack does it for you.
    #    dredd = Dredd::Rack::Runner.new
    #    dredd.level(:warning).dry_run!.run
    #
    #    # You can specify an API endpoint to perform a remote validation.
    #    # Do not forget to serve the API at the given URL!
    #    #
    #    # runs `dredd blueprints/*.md doc/*.md https://api.example.com --no-color`
    #    anderson = Anderson::Rack::Runner.new 'https://api.example.com' do |options|
    #      options.paths_to_blueprints 'blueprints/*.md', 'doc/*.md'
    #      options.no_color!
    #    end
    #    anderson.run
    #
    class Runner

      undef_method :method

      NEGATABLE_BOOLEAN_OPTIONS = [:dry_run!, :sandbox!, :names!, :init!, :sorted!, :inline_errors!,
                                   :details!, :color!, :timestamp!, :silent!]
      META_OPTIONS              = [:help, :version]
      BOOLEAN_OPTIONS           = NEGATABLE_BOOLEAN_OPTIONS + META_OPTIONS

      SINGLE_ARGUMENT_OPTIONS   = [:hookfiles, :language, :server, :server_wait, :custom, :only,
                                   :reporter, :output, :header, :user, :method, :level, :path,
                                   :hooks_worker_timeout, :hooks_worker_connect_timeout,
                                   :hooks_worker_connect_retry, :hooks_worker_after_connect_wait,
                                   :hooks_worker_term_timeout, :hooks_worker_term_retry,
                                   :hooks_worker_handler_host, :hooks_worker_handler_port]
      OPTIONS                   = BOOLEAN_OPTIONS + SINGLE_ARGUMENT_OPTIONS

      # Store the Dredd command line options
      attr_accessor :command_parts

      # Initialize a runner instance
      #
      # The API endpoint can be local or remote.
      #
      # api_endpoint - the API URL as a String
      #
      def initialize(api_endpoint=nil)
        @dredd_command = 'dredd'
        @paths_to_blueprints = 'doc/*.apib doc/*.apib.md'
        @api_endpoint = api_endpoint || ''
        @command_parts = []

        yield self if block_given?
      end

      # Set or return the runner API endpoint
      #
      # Use with no arguments to read the runner API endpoint,
      # provide an API endpoint to set it.
      #
      # api_endpoint - String URL of the API endpoint to validate
      #
      # Returns the String URL of the runner API endpoint.
      def api_endpoint(api_endpoint=nil)
        @api_endpoint = api_endpoint unless api_endpoint.nil?
        @api_endpoint
      end

      # Return the Dredd command line
      def command
        ([@dredd_command, @paths_to_blueprints, @api_endpoint] + @command_parts).join(' ')
      end

      # Configure the runner instance
      def configure
        yield self if block_given?
      end

      # Define custom paths to blueprints
      #
      # paths_to_blueprints - as many Strings as paths where blueprints are located
      #
      # Returns self.
      def paths_to_blueprints(*paths_to_blueprints)
        raise ArgumentError, 'invalid path to blueprints' if paths_to_blueprints == [''] || paths_to_blueprints.empty?

        @paths_to_blueprints = paths_to_blueprints.join(' ')
        self
      end

      # Run Dredd
      #
      # Returns true if the Dredd exit status is zero, false instead.
      def run
        raise InvalidCommandError.new(command) unless command_valid?
        start_server! unless api_remote?
        Kernel.system(command)
      end

      # Ensure that the runner does respond_to? its option methods
      #
      # See http://ruby-doc.org/core-2.2.0/Object.html#method-i-respond_to_missing-3F
      def respond_to_missing?(method, include_private=false)
        OPTIONS.include?(method.to_sym ) ||
        NEGATABLE_BOOLEAN_OPTIONS.include?(method.to_s.gsub(/\Ano_/, '').to_sym) ||
        super
      end

      private

        def api_remote?
          !@api_endpoint.empty?
        end

        def command_valid?
          command.has_at_least_two_arguments?
        end

        def start_server!
          server = Capybara::Server.new(Dredd::Rack.app)
          server.boot
          @api_endpoint = "http://#{server.host}:#{server.port.to_s}"
        end

        # Private: Define as many setter methods as there are Dredd options
        #
        # The behaviour of Object#method_missing is not modified unless
        # the called method name matches one of the Dredd options.
        #
        # name - Symbol for the method called
        # args - arguments of the called method
        #
        # See also: http://ruby-doc.org/core-2.2.0/BasicObject.html#method-i-method_missing
        def method_missing(name, *args)
          super unless OPTIONS.include?(name.to_sym ) ||
                       NEGATABLE_BOOLEAN_OPTIONS.include?(name.to_s.gsub(/\Ano_/, '').to_sym)

          option_flag = name.to_s.gsub('_', '-').gsub('!', '').prepend('--')
          command_parts = self.command_parts.push option_flag
          command_parts = self.command_parts.push args.slice(0).to_s.quote! if SINGLE_ARGUMENT_OPTIONS.include? name
          self
        end

    end
  end
end

class String

  # Verify that a command has at least one argument (excluding options)
  #
  # Examples:
  #
  #    "dredd doc/*.apib".valid? # => true
  #    "dredd doc/*.apib doc/*apib.md".valid? # => true
  #    "dredd doc/*.apib --level verbose".valid? # => true
  #    "dredd".valid? # => false
  #    "dredd --dry-run".valid? # => false
  #    "dredd --dry-run --level verbose".valid? # => false
  #
  # Known limitations:
  #
  # Does not support short flags. (e.g. using `-l` instead of `--level`).
  # Requires options to be specified after the last argument.
  #
  # Note:
  #
  # The known limitations imply that there may be false negatives: this method
  # can return false for commands that do have two arguments or more. But there
  # should not be false positives: if the method returns true, then the command
  # does have at least two arguments.
  #
  # Returns true if the command String has at least one arguments, false otherwise.
  def has_at_least_one_argument?
    split('--').first.split(' ').length >= 2
  end

  # Verify that a command has at least two arguments (excluding options)
  #
  # Examples:
  #
  #    "dredd doc/*.apib http://api.example.com".valid? # => true
  #    "dredd doc/*.apib doc/*apib.md http://api.example.com".valid? # => true
  #    "dredd doc/*.apib http://api.example.com --level verbose".valid? # => true
  #    "dredd http://api.example.com".valid? # => false
  #    "dredd doc/*.apib --dry-run".valid? # => false
  #    "dredd --dry-run --level verbose".valid? # => false
  #
  # Known limitations:
  #
  # Does not support short flags. (e.g. using `-l` instead of `--level`).
  # Requires options to be specified after the last argument.
  #
  # Note:
  #
  # The known limitations imply that there may be false negatives: this method
  # can return false for commands that do have two arguments or more. But there
  # should not be false positives: if the method returns true, then the command
  # does have at least two arguments.
  #
  # Returns true if the command String has at least two arguments, false otherwise.
  def has_at_least_two_arguments?
    split('--').first.split(' ').length >= 3
  end

  # Include quotes as part of the string
  #
  # Examples:
  #
  #    "Hello, world!".quote! # => "\"Hello, world!\""
  #    "Hello, world!".size # => 13
  #    "Hello, world!".quote!.size # => 15
  #
  # Returns a String, whose first and last characters are quotes.
  def quote!
    '"' + self + '"'
  end
end

Anderson = Dredd # Anderson::Rack::Runner.new runs just as fast as Dredd
