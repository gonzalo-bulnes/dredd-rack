Dredd::Rack
===========

[![Gem Version](https://badge.fury.io/rb/simple_token_authentication.svg)](http://badge.fury.io/rb/simple_token_authentication)
[![Build Status](https://travis-ci.org/gonzalo-bulnes/simple_token_authentication.svg?branch=master)](https://travis-ci.org/gonzalo-bulnes/simple_token_authentication)
[![Code Climate](https://codeclimate.com/github/gonzalo-bulnes/simple_token_authentication.svg)](https://codeclimate.com/github/gonzalo-bulnes/simple_token_authentication)
[![Dredd Reference Version](https://img.shields.io/badge/dredd_reference_version-0.4.1-green.svg)](https://github.com/apiaryio/dredd)
[![Inline docs](http://inch-ci.org/github/gonzalo-bulnes/simple_token_authentication.svg?branch=master)](http://inch-ci.org/github/gonzalo-bulnes/simple_token_authentication)

Convenient API blueprint testing with [Dredd][dredd] for Rack applications.

  [dredd]: https://github.com/apiaryio/dredd

Installation
------------

Add the gem to your `Gemfile`:

```ruby
# Gemfile

gem 'dredd-rack', '~> 1.0' # see semver.org
```

Then add the rake task to your `Rakefile`:

```ruby
# Rakefile

require 'dredd/rack'
Dredd::Rack::RakeTask.new # run with `rake dredd`

# Optionally add Dredd to your default test suite:
# task default: [:spec, :dredd]
```

Usage
-----

The `Dredd::Rack::RakeTask` can be used to define custom tasks:

```ruby
# Rakefile

require 'dredd/rack'

# run with `rake anderson`
Dredd::Rack::RakeTask.new(:anderson)

# run with `rake blueprint:verify:machines`
namespace :blueprint do
  namespace :verify do
    Dredd::Rack::RakeTask.new(:machines, 'Verify the machines API blueprint', 'http://machines.apiary.io') do |options|
      options.paths_to_blueprints 'single_get.md'
      options.only 'Machines > Machines collection > Get Machines'
      options.color!
    end
    # runs `dredd single_get.md http://machines.apiary.io --only "Machines > Machines collection > Get Machines" --color`
  end
end
```

Credits
-------

The `Dredd::Rack::RakeTask` is heavily inspired in the [`RSpec::Core::RakeTask`][rspec-core-raketask] to provide a custom Rake tasks factory. All credits for the `RSpec::Core::RakeTask` go to the RSpec Development Team.

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
