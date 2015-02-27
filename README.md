Dredd::Rack
===========

Convenient API blueprint testing with [Dredd][dredd] for Rack applications.

  [dredd]: https://github.com/apiaryio/dredd

Usage
-----

Add the gem to your Gemfile:

```ruby
gem 'dredd-rack', '~> 1.0'
```

Require your app and add the Dredd::Rack rake task to your Rakefile:

```ruby
# Rakefile

# ...

# Specify the application to test:
#
# Example:
#
#     require 'dredd-rack-example'
#     def app() Dredd::Rack::Example end
#
# Returns the application to test
require 'your_app'
def app() YourApp end

# require the Dredd::Rack rake task
require 'dredd/rack'

# Optionally add the API blueprint verification to the default test suite
# task :default => [:spec, 'blueprint:verify']
```

Run the API blueprint verification:

```bash
rake blueprint:verify

# or specify a remote server:
#API_HOST=http://api.example.com rake blueprint:verify
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
