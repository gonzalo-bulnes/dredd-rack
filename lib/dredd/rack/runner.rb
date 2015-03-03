module Dredd
  module Rack
    class Runner

      def self.run(*paths_to_blueprints, api_endpoint)
        command = ['dredd']

        paths_to_blueprints.push Dredd::Rack::Runner.configuration.default_path_to_blueprints if paths_to_blueprints.empty?

        command.push paths_to_blueprints.join(' ')
        command.push api_endpoint
        command.join(' ')
      end

      def self.configuration; end
    end
  end
end
