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
  gem.license         = "GPL-3.0+"

  gem.files = Dir["{doc,lib}/**/*", "CHANGELOG.md", "Gemfile", "LICENSE", "Rakefile", "README.md"]
  gem.test_files = Dir["spec/**/*"]

  gem.add_dependency "capybara", ">= 2.4", "< 4"
  gem.add_dependency "rake", ">= 10.4", "< 13"
  gem.add_dependency "rainbow", "~> 2.0"

  gem.add_development_dependency "inch", "~> 0.7.1"
  gem.add_development_dependency "rspec", "~> 3.0"
end
