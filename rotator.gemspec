# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rotator/version"

Gem::Specification.new do |s|
  s.name        = "rotator"
  s.version     = Rotator::VERSION
  s.authors     = ["Gerasimos Athanasopoulos"]
  s.email       = ["ath.ger@gmail.com"]
  s.homepage    = "http://github.com/rubymaniac/rotator"
  s.summary     = %q{Rotate logs (or any file) and transfer them to Amazon S3}
  s.description = %q{With rotator you can rotate your logs (or any file) and transfer them to Amazon S3}

  s.rubyforge_project = "rotator"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_runtime_dependency "aws-sdk"
end
