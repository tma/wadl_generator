# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "wadl/generator"

Gem::Specification.new do |s|
  s.name        = "wadl_generator"
  s.version     = WADL::Generator::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Thomas Maurer"]
  s.email       = ["tma@freshbit.ch"]
  s.homepage    = ""
  s.summary     = %q{Simple WADL Generator targeted on REST APIs with optional Apigee Flavour}
  s.description = %q{Simple WADL Generator targeted on REST APIs with optional Apigee Flavour}

  s.rubyforge_project = "wadl_generator"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
