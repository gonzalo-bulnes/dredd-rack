See also: [Dredd::Rack::Runner](runner.md)

Dredd::Rack::RakeTask
=====================

**Table of Contents**

1. [Example](#example)
1. [Custom name, description](#custom-rake-task-name-description)
1. [Custom runner](#custom-rake-task-runner)
1. [Fully custom rake tasks](#fully-custom-rake-tasks)

----

Example
-------

Use the `dredd` rake task from your `Rakefile`:

```ruby
# Rakefile

require 'dredd/rack'
Dredd::Rack.app = Example::Application

Dredd::Rack::RakeTask.new
# That's all! Dredd::Rack will serve the app automatically,
# and the :dredd task is defined.

# Optionally add the API blueprint verification to the default test suite
# task :default => [:spec, :dredd]
```

Run the API blueprint verification:

```bash
# locally
rake dredd

# or specify a remote server:
#API_HOST=http://api.example.com rake dredd
```

Custom rake task name, description
----------------------------------

You can define a custom task name or description:

```ruby
# Rakefile

# ...

require 'dredd/rack'
Dredd::Rack.app = Example::Application

namespace :blueprint do
  desc 'Verify the API blueprint accuracy'
  Dredd::Rack::RakeTask.new(:verify)
end

# run with: `rake blueprint:verify`
```

Custom rake task runner
-----------------------

You can also configure the Dredd::Rack runner:

```ruby
# Rakefile

# ...

require 'dredd/rack'
Dredd::Rack.app Example::Application

Dredd::Rack::RakeTask.new(:dredd) do |task|
  task.runner.configure do |dredd|
    dredd.paths_to_blueprints 'blueprints/*.md', 'blueprints/*.apib'
    dredd.level(:silly).no_color!
  end
end

# run with: `rake dredd`
```

Fully custom rake tasks
-----------------------

In fact, you can define as many tasks as you need, with custom names, descriptions or runners:

```ruby
# Rakefile

require 'dredd/rack'
Dredd::Rack.app RobotsFactory::API

namespace :blueprint do
  namespace :verify do

    desc 'Verify the whole API compliance with its blueprint'
    Dredd::Rack::RakeTask.new(:all)

    desc 'Verify the Machines API compliance with its blueprint'
    Dredd::Rack::RakeTask.new(:machines) do |task|
      task.runner.configure do |dredd|
        dredd.only 'Machines > Machines Collection > List all Machines',
                   'Machines > Machine > Retrieve a Machine' # etc.
        dredd.sorted!.details!
      end
    end

    # ...
  end
end

# run with `rake blueprint:verify:all` and `rake blueprint:verify:machines`
```
