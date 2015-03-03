module Dredd
  module Rack
    class Runner

      undef_method :method

      BOOLEAN_OPTIONS         = [:dry_run, :names, :sorted, :inline_errors,
                                 :details, :color, :timestamp, :silent,
                                 :help, :version]
      SINGLE_ARGUMENT_OPTIONS = [:hookfiles, :only, :reporter, :output, :header,
                                 :user, :method, :level, :path]
      OPTIONS = BOOLEAN_OPTIONS + SINGLE_ARGUMENT_OPTIONS
    end
  end
end
