module Dredd
  module Rack
    class Runner

      undef_method :method

      BOOLEAN_OPTIONS         = [:dry_run!, :names!, :sorted!, :inline_errors!,
                                 :details!, :color!, :timestamp!, :silent!,
                                 :help, :version]
      SINGLE_ARGUMENT_OPTIONS = [:hookfiles, :only, :reporter, :output, :header,
                                 :user, :method, :level, :path]
      OPTIONS = BOOLEAN_OPTIONS + SINGLE_ARGUMENT_OPTIONS

      attr_accessor :command_parts

      def initialize
        @command_parts = ['dredd']
      end

      def command
        @command_parts.join(' ')
      end

      def method_missing(name, *args)
        super unless OPTIONS.include? name.to_sym

        option_flag = name.to_s.gsub('_', '-').prepend('--')
        command_parts = self.command_parts.push option_flag
        command_parts = self.command_parts.push args.slice(0).to_s if SINGLE_ARGUMENT_OPTIONS.include? name
        self
      end

      def respond_to_missing?(method, include_private=false)
        OPTIONS.include? method.to_sym || super
      end
    end
  end
end
