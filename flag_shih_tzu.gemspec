# -*- encoding: utf-8 -*-
require File.expand_path('../lib/flag_shih_tzu/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name        = "flag_shih_tzu"
  spec.version     = FlagShihTzu::VERSION
  spec.licenses    = ['MIT']
  spec.email       = 'peter.boling@gmail.com'
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ["Peter Boling", "Patryk Peszko", "Sebastian Roebke", "David Anderson", "Tim Payton"]
  spec.homepage    = "https://github.com/pboling/flag_shih_tzu"
  spec.summary     = %q{Bit fields for ActiveRecord}
  spec.description = <<-EODOC
Bit fields for ActiveRecord:
This gem lets you use a single integer column in an ActiveRecord model
to store a collection of boolean attributes (flags). Each flag can be used
almost in the same way you would use any boolean attribute on an
ActiveRecord object.
  EODOC

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency('activerecord', '>= 2.3.0')

  spec.add_development_dependency('kettle-dev', '~> 1.1')       # ruby >= 2.3
end
