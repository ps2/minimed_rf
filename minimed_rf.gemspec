Gem::Specification.new do |s|
  s.name        = 'minimed_rf'
  s.version     = '0.0.1'
  s.date        = '2014-07-15'
  s.summary     = "Minimed RF Library"
  s.description = "A library for decoding minimed pump RF transmissions"
  s.authors     = ["Pete Schwamb"]
  s.email       = 'pete@schwamb.net'
  s.files       = ["lib/minimed_rf.rb"]
  s.license     = 'MIT'
  s.add_dependency "colorize"
end
