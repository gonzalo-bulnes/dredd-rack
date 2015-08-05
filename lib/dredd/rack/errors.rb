module Dredd
  module Rack
    class InvalidCommandError < Class.new(RuntimeError)
      # InvalidCommandError = Class.new(RuntimeError)

      def initialize(command)
        super("Invalid command - #{command}")
      end
    end
  end
end
