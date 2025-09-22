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

  spec.add_development_dependency("kettle-dev", "~> 1.1")                     # ruby >= 2.3.0
  spec.add_development_dependency("bundler-audit", "~> 0.9.2")                      # ruby >= 2.0.0

  spec.add_development_dependency("rake", "~> 13.0")                                # ruby >= 2.2.0

  spec.add_development_dependency("require_bench", "~> 1.0", ">= 1.0.4")            # ruby >= 2.2.0

  spec.add_development_dependency("appraisal2", "~> 3.0")                           # ruby >= 1.8.7, for testing against multiple versions of dependencies

  spec.add_development_dependency("kettle-test", "~> 1.0")                          # ruby >= 2.3

  spec.add_development_dependency("rspec-pending_for", "~> 0.0", ">= 0.0.17")       # ruby >= 2.3, used to skip specs on incompatible Rubies

  spec.add_development_dependency("ruby-progressbar", "~> 1.13")                    # ruby >= 0

  spec.add_development_dependency("stone_checksums", "~> 1.0", ">= 1.0.2")          # ruby >= 2.2.0

  # spec.add_development_dependency("erb", ">= 2.2")                                  # ruby >= 2.3.0, not SemVer, old rubies get dropped in a patch.

  spec.add_development_dependency("gitmoji-regex", "~> 1.0", ">= 1.0.3")            # ruby >= 2.3.0

  # spec.add_development_dependency("backports", "~> 3.25", ">= 3.25.1")  # ruby >= 0

  # spec.add_development_dependency("vcr", ">= 4")                        # 6.0 claims to support ruby >= 2.3, but fails on ruby 2.4

  # spec.add_development_dependency("webmock", ">= 3")                    # Last version to support ruby >= 2.3

end
