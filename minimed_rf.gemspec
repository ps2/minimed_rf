Gem::Specification.new do |spec|
  spec.name        = 'minimed_rf'
  spec.version     = '0.0.2'
  spec.date        = '2014-07-15'
  spec.summary     = "Minimed RF Library"
  spec.description = "A library for decoding minimed pump RF transmissions"
  spec.authors     = ["Pete Schwamb"]
  spec.email       = 'pete@schwamb.net'
  spec.files       = Dir.glob("{bin,lib}/**/*") + %w(README.md)
  spec.license     = 'MIT'
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.add_dependency "colorize"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
end
