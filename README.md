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

Add the rake task to your Rakefile:

```ruby
# Rakefile

# ...

require 'dredd/rack'

# Optionally add the API blueprint verification to the default test suite
# task :default => [:spec, 'blueprint:verify']
```

Run the API blueprint verification (the API server must be up):

```bash
# start any Rack application (including Rails, Sinatra) locally
rackup -p 3000
# or make sure the remote server is up

rake blueprint:verify # run against http://localhost:3000 by default
# or specify a different server (including any remote server):
#API_HOST=http://localhost:4567 rake blueprint:verify
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
