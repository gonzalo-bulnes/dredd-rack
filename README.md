Dredd::Rack
===========

[![Gem Version](https://badge.fury.io/rb/dredd-rack.svg)](http://badge.fury.io/rb/dredd-rack)
[![Build Status](https://travis-ci.org/gonzalo-bulnes/dredd-rack.svg?branch=master)](https://travis-ci.org/gonzalo-bulnes/dredd-rack)
[![Code Climate](https://codeclimate.com/github/gonzalo-bulnes/dredd-rack.svg)](https://codeclimate.com/github/gonzalo-bulnes/dredd-rack)
[![Dredd Reference Version](https://img.shields.io/badge/dredd_reference_version-1.5.0-brightgreen.svg)](https://github.com/apiaryio/dredd)
[![Inline docs](http://inch-ci.org/github/gonzalo-bulnes/dredd-rack.svg?branch=master)](http://inch-ci.org/github/gonzalo-bulnes/dredd-rack)

> **DISCLAIMER**: This is an early version of Dredd::Rack, please be aware that it will not be stable until `v1.0.0`. At any moment, [feedback][issues] is more than welcome! : ) -- [GB][gonzalo-bulnes]

This gem provides a [Dredd][dredd] runner and a `dredd` rake task to make [API blueprint][blueprint] testing convenient for Rack applications. When verifying blueprints locally, an application server is automatically set up, without need of any manual intervention.

Besides being convenient, that allows to use the API blueprints as acceptance test suites to practice [BDD][rspec-book] with Dredd and RSpec, for example, while clients developers use [Apiary][apiary] as a mock server.

  [dredd]: https://github.com/apiaryio/dredd
  [blueprint]: https://apiblueprint.org/
  [rspec-book]: https://pragprog.com/book/achbd/the-rspec-book
  [apiary]: http://apiary.io
  [issues]: https://github.com/gonzalo-bulnes/dredd-rack/issues
  [gonzalo-bulnes]: https://github.com/gonzalo-bulnes

Installation
------------

Add the gem to your `Gemfile`:

```ruby
# Gemfile

gem 'dredd-rack', '0.9.0' # see semver.org
```

Define which application Dredd::Rack must serve automatically:

```ruby
# config/initializers/dredd-rack.rb or app.rb or Rakefile

require 'dredd/rack'

Dredd::Rack.configure do |config|
  # Allow the automatic setup of a local application server when necessary
  #
  # Find the name of your application in its `config.ru` file.
  config.app = Example::Application # or Rails.application, Sinatra::Application...

  # Optionally, you can define a custom Dredd command:
  config.dredd_command = 'dredd'
end

```

Usage
-----

### Getting started

Define the `dredd` rake task in your `Rakefile`:

```ruby
# Rakefile

require 'dredd/rack'

# ...

# Define the :dredd task
Dredd::Rack::RakeTask.new # run: `dredd doc/*.apib doc/*.apib.md <local or remote URL>`

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

The `:dredd` rake task requires no further configuration. However, it relies on the following convention: API blueprints must be stored in the `doc` directory with either the `.apib` or the `.apib.md` extension.

### Further usage

Of course you can define your own rake tasks with custom runners!

Each Dredd::Rack runner stores a specific Dredd configuration. In order to manage different runners, you can define multiple rake tasks with custom names or descriptions:

```ruby
# Rakefile

# ...

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

Both the [rake task documentation][rake-task-doc] and the [runner documentation][runner-doc] contain more examples, and the runner documentation does also contain a comprehensive list of the [configuration methods][conf] that can be used to customize runners. Take a look at them!

  [rake-task-doc]: doc/rake_task.md
  [runner-doc]: doc/runner.md
  [conf]: doc/runner.md#configuration-methods-reference


#### Remote API testing

Configuring a runner for remote API blueprint compliance testing is as easy as setting its **api_endpoint** option (see the [runner documentation][conf]). Please remember that you must ensure that the API is being served at the specified URI when performing remote API blueprint validation.

Credits
-------

The `Dredd::Rack::RakeTask` is heavily inspired in the [`RSpec::Core::RakeTask`][rspec-core-raketask]. Let the corresponding credits go to the RSpec team.

  [rspec-core-raketask]: https://github.com/rspec/rspec-core/blob/v3.2.1/lib/rspec/core/rake_task.rb

License
-------

    Dredd::Rack provides convenient API blueprint testing to Rack applications.
    Copyright (C) 2015  Gonzalo Bulnes Guilpain

    Copyright (C) 2012 Chad Humphries, David Chelimsky, Myron Marston
    Copyright (C) 2009 Chad Humphries, David Chelimsky
    Copyright (C) 2006 David Chelimsky, The RSpec Development Team
    Copyright (C) 2005 Steven Baker

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
