$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dredd/rack/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |gem|
  gem.name          = "dredd-rack"
  gem.version       = Dredd::Rack::VERSION
  gem.authors       = ["Gonzalo Bulnes Guilpain"]
  gem.email         = ["gon.bulnes@gmail.com"]
  gem.summary       = %q{Convenient API blueprint testing with Apiary Dredd for Rack applications.}
  gem.homepage      = "https://github.com/gonzalo-bulnes/dredd-rack"
  gem.license         = "GPLv3"

  gem.files = Dir["{doc,lib}/**/*", "Gemfile", "LICENSE", "Rakefile", "README.md"]
end
