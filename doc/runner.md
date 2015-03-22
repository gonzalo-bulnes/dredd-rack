See also: [Dredd::Rack::RakeTask](rake_task.md)

Dredd::Rack::Runner
===================

**Table of Contents**

1. [Example](#example)
1. [Runner configuration](#runner-configuration)
1. [Configuration methods reference](#configuration-methods-reference)

----

Example
-------

```ruby

# Dredd command to run:
# `dredd *.apib *.md <local API endpoint> --level "warning" --no-color`

dredd = Dredd::Rack::Runner.new do |options|
  options.paths_to_blueprints '*.apib', '*.md'
  options.level(:warning).no_color!
end

# run Dredd (a server will be started and stopped automatically)
dredd.run
```

Runner configuration
--------------------

Runners can be configured immediately after being created (see example above), or at any moment using the `configure` method:

```ruby
dredd = Dredd::Rack::Runner.new

dredd.configure do |options|
  options.api_endpoint 'https://api.example.com'
  options.details!
end
```

Please note that configuration methods can be chained for convenience:

```ruby
dredd.configure { |options| options.level(:info).sorted!.no_color! }
```

Configuration methods reference
-------------------------------

```ruby
# See https://github.com/apiaryio/dredd#command-line-options for Dredd commands usage

dredd = Dredd::Rack::Runner.new do |options|

  options.api_endpoint 'https://api.example.com' # allows to validate remote API

  options.hookfiles 'doc/hooks/*_hooks.coffee'

  options.only 'Machines > Machines Collection > List all Machines',
               'Machines > Machine > Retrieve a Machine'

  options.reporter(:markdown)
  options.reporter(:html).output('doc/report.html')

  options.header 'X-User-Email: alice@example.com'
  options.header 'X-User-Token: 1G8_s7P-V-4MGojaKD7a'

  options.user 'username:password'

  options.level(:info)

  options.path('doc/*.md').path('doc/*.apib.md')

  options.method('POST').method('PUT')

  options.dry_run!            # no_dry_run!
  options.names!              # no_names!
  options.sorted!             # no_sorted!
  options.inline_errors!      # no_inline_errors!
  options.details!            # no_details!
  options.color!              # no_color!
  options.timestamp!          # no_timestamp!
  options.silent!             # no_silent!

  options.help
  options.version
end

# run Dredd (you don't have to worry about the server unless the API is remote)
dredd.run
```
