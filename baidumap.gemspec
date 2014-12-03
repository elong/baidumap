# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'baidumap/version'

Gem::Specification.new do |spec|
  spec.name          = "baidumap"
  spec.version       = Baidumap::VERSION
  spec.authors       = ["刘明, ChienliMa"]
  spec.email         = ["charles.liu@corp.elong.com, maqianlie@gmail.com"]
  spec.description   = %q{Baidu map services: place, geocoding, direction}
  spec.summary       = %q{Baidu map gem}
  spec.homepage      = "http://github.com/seoaqua/baidumap"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "httparty"

end
