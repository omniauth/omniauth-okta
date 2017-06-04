$:.push File.expand_path("../lib", __FILE__)

require "omniauth-okta/version"

Gem::Specification.new do |s|
  s.name          = "omniauth-okta"
  s.version       = OmniAuth::Okta::VERSION
  s.authors       = ["Dan Andrews"]
  s.email         = ["daniel.andrews@techstars.com"]
  s.homepage      = ""
  s.summary       = %q{Unofficial OmniAuth strategy for Okta}
  s.description   = %q{Unofficial OmniAuth strategy for Okta}
  s.license       = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "omniauth", "~> 1.0"
  s.add_dependency "omniauth-oauth2", "~> 1.0"

  s.add_development_dependency "bundler", "~> 1.5"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 2.7"
  s.add_development_dependency "rack-test"
end
