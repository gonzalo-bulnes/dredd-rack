module Dredd
  module Rack
    class Runner

      undef_method :method

      NEGATABLE_BOOLEAN_OPTIONS = [:dry_run!, :names!, :sorted!, :inline_errors!,
                                   :details!, :color!, :timestamp!, :silent!]
      META_OPTIONS              = [:help, :version]
      BOOLEAN_OPTIONS           = NEGATABLE_BOOLEAN_OPTIONS + META_OPTIONS

      SINGLE_ARGUMENT_OPTIONS   = [:hookfiles, :only, :reporter, :output, :header,
                                   :user, :method, :level, :path]
      OPTIONS                   = BOOLEAN_OPTIONS + SINGLE_ARGUMENT_OPTIONS

      attr_accessor :command_parts

      def initialize
        @dredd_command = 'dredd'
        @paths_to_blueprints = 'doc/*.apib doc/*.apib.md'
        @api_endpoint = 'http://localhost:3000'
        @command_parts = []
      end

      def command
        ([@dredd_command, @paths_to_blueprints, @api_endpoint] + @command_parts).join(' ')
      end

      def run
        Kernel.system(command) if command_valid?
      end

      def respond_to_missing?(method, include_private=false)
        OPTIONS.include? method.to_sym || super
      end

      private

        def command_valid?
          command.has_at_least_two_arguments?
        end

        def method_missing(name, *args)
          super unless OPTIONS.include? name.to_sym

          option_flag = name.to_s.gsub('_', '-').gsub('!', '').prepend('--')
          command_parts = self.command_parts.push option_flag
          command_parts = self.command_parts.push args.slice(0).to_s if SINGLE_ARGUMENT_OPTIONS.include? name
          self
        end

    end
  end
end

class String

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
end
