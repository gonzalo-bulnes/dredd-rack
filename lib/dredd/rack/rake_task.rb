require 'rainbow'
require 'rake'
require 'rake/tasklib'

# This class is heavily inspired in RSpec::Core::RakeTask,
# which is part of the RSpec::Core and is licenced as follows:
#
# Copyright (c) 2012 Chad Humphries, David Chelimsky, Myron Marston
# Copyright (c) 2009 Chad Humphries, David Chelimsky
# Copyright (c) 2006 David Chelimsky, The RSpec Development Team
# Copyright (c) 2005 Steven Baker
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# See https://github.com/rspec/rspec-core/blob/v3.2.1/lib/rspec/core/rake_task.rb
#
# The modified code is part of Dredd::Rack, please see
# https://github.com/gonzalo-bulnes/dredd-rack for copyright and license details.

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
    #      Dredd::Rack::RakeTask.new(:verify, 'Verify an API complies with its blueprint')
    #    end
    #    # run it with `rake blueprint:verify`
    #
    #    # Customize the API endpoint or runner options,
    #    # use `nil` to keep the default Rake task name or description:
    #    Dredd::Rack::RakeTask.new(:anderson, nil, 'http://localhost:4567') do |options|
    #      options.paths_to_blueprints 'blueprints/*.apib blueprints/*.apib.md'
    #      options.level silly
    #      options.silent!
    #    end
    #    # run with `rake anderson` to get your Sinatra API judged
    #
    class RakeTask  < ::Rake::TaskLib

      # Return the task's name
      attr_reader :name

      # Return the task's description
      attr_reader :description

      # Return the Dredd::Rack::Runner instance
      attr_reader :dredd_runner

      # Define a task with a custom name and arguments
      #
      # The first argument is the name of the task.
      #
      # Creates a Dredd::Rack::Runner instance with the other
      # arguments and eventually the block that were provided.
      # Running the task does run Dredd and return its exit status.
      #
      # args - the Symbol for the task and the runner arguments
      # task_block - an optional block to configure the runner
      #
      def initialize(*args, &task_block)
        @name = args.shift || :dredd
        @description = args.shift || 'Run Dredd::Rack API blueprint verification'

        @dredd_runner = Dredd::Rack::Runner.new(args.slice(0), &task_block)

        desc description
        task name, args do
          dredd_runner.run
        end
      end
    end
  end
end
