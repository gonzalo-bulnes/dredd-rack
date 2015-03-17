Dredd::Rack
===========

[![Build Status](https://travis-ci.org/gonzalo-bulnes/dredd-rack.svg?branch=master)](https://travis-ci.org/gonzalo-bulnes/dredd-rack)
[![Code Climate](https://codeclimate.com/github/gonzalo-bulnes/dredd-rack.svg)](https://codeclimate.com/github/gonzalo-bulnes/dredd-rack)
[![Dredd Reference Version](https://img.shields.io/badge/dredd_reference_version-0.4.1-green.svg)](https://github.com/apiaryio/dredd)
[![Inline docs](http://inch-ci.org/github/gonzalo-bulnes/dredd-rack.svg?branch=master)](http://inch-ci.org/github/gonzalo-bulnes/dredd-rack)

This gem provides a [Dredd][dredd] runner and a `dredd` rake task to make [API blueprint][blueprint] testing convenient for Rack applications. When verifying blueprints locally, an application server is automatically set up, without need of any manual intervention.

Besides being convenient, that allows to use the API blueprints as acceptance test suites to practice [BDD][rspec-book] with Dredd and RSpec, for example, while clients developers use [Apiary][apiary] as a mock server.

  [dredd]: https://github.com/apiaryio/dredd
  [blueprint]: https://apiblueprint.org/
  [rspec-book]: https://pragprog.com/book/achbd/the-rspec-book
  [apiary]: http://apiary.io

Installation
------------

Add the gem to your `Gemfile`:

```ruby
# Gemfile

gem 'dredd-rack', '~> 0.3.0' # see semver.org
```

Getting Started
---------------

### Dredd::Rack::Runner

_To do._


### Rake task

Use the `dredd` rake task from your `Rakefile`:

```ruby
# Rakefile

require 'dredd/rack'

# Configure Dredd::Rack to automatically set a server up for your application
Dredd::Rack.app Sinatra::Application # or the name of your modular-style app, or Rails app

# That's all!

# Optionally add the API blueprint verification to the default test suite
# task :default => [:spec, :dredd]
```

Run the API blueprint verification locally:

```bash
rake dredd

# or specify a remote server:
#API_HOST=http://api.example.com rake blueprint:verify
```

Usage
-----

### Custom rake task name or description

You can also define a custom rake task name or description:

```ruby
# Rakefile

require 'dredd/rack'

# Configure Dredd::Rack to automatically set a server up for your application
Dredd::Rack.app Sinatra::Application # or the name of your modular-style app, or Rails app

namespace :blueprint do
  desc 'Verify an API complies with its blueprint'
  Dredd::Rack::RakeTask.new(:verify)
end
```

License
-------

    Dredd::Rack provides convenient API blueprint testing to Rack applications.
    Copyright (C) 2015  Gonzalo Bulnes Guilpain

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
