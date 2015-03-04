module Dredd
  module Rack
    class Runner

      def self.run(*paths_to_blueprints, api_endpoint)
        paths_to_blueprints.push Dredd::Rack::Runner.configuration.default_path_to_blueprints if paths_to_blueprints.empty?

        command = Command.new paths_to_blueprints, api_endpoint
        command = yield command if block_given?
        command.parts.join(' ')
      end

      def self.configuration; end

      class Command

        attr_reader :parts

        def initialize(paths_to_blueprints, api_endpoint)
          @parts = ['dredd'] + paths_to_blueprints + [api_endpoint]
        end

        def dry_run
          @parts.push '--dry-run'
          self
        end

        def hookfiles(pattern)
          @parts.push '--hookfiles'
          @parts.push 'pattern'
          self
        end

        def names
          @parts.push '--names'
          self
        end

        def only(transaction_name)
          @parts.push '--only'
          @parts.push transaction_name
          self
        end

        def reporter(report_format)
          @parts.push '--reporter'
          @parts.push report_format
          self
        end
      end
    end
  end
end
