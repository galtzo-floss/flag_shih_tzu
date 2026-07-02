# frozen_string_literal: true

# kettle-jem:freeze
# To retain chunks of comments & code during kettle-jem templating:
# Wrap custom sections with freeze markers (e.g., as above and below this comment chunk).
# kettle-jem will then preserve content between those markers across template runs.
# kettle-jem:unfreeze

gem_version =
  if Gem.ruby_version >= Gem::Version.new("3.1")
    # Loading Version into an anonymous module allows version.rb to get code coverage from SimpleCov!
    # See: https://github.com/simplecov-ruby/simplecov/issues/557#issuecomment-2630782358
    # See: https://github.com/panorama-ed/memo_wise/pull/397
    Module.new.tap { |mod| Kernel.load("#{__dir__}/lib/flag_shih_tzu/version.rb", mod) }::FlagShihTzu::Version::VERSION
  else
    require_relative "lib/flag_shih_tzu/version"
    FlagShihTzu::Version::VERSION
  end

Gem::Specification.new do |spec|
  spec.name = "flag_shih_tzu"
  spec.version = gem_version
  spec.authors = ["Alto", "boosty", "ladislav.martincik", "pboling", "XING Engineering", "Joost Baaij", "Arturas Slajus", "Musy Bite", "Tim Liner", "David DIDIER", "Peter H. Boling", "Tatsuhiko Miyagawa", "Keith Pitty", "Peter M. Goldstein", "Alexander Tipugin", "Jonathan del Strother", "Ivan", "jfcaiceo", "Xinran Xiao", "shiro16", "Peter Boling", "xpol", "Yusuke Ebihara", "Amy Martin", "Annibelle Boling", "horiken"]
  spec.email = ["floss@galtzo.com"]

  spec.summary = "🏁 Single and Multi Bit Fields for ActiveRecord"
  spec.description = <<~EODOC
    🏁 Single and Multi-Bit Fields for ActiveRecord:
    This gem lets you use a single integer column in an ActiveRecord model
    to store a collection of boolean attributes (flags). Each flag can be used
    almost in the same way you would use any boolean attribute on an
    ActiveRecord object. Support for multi-bit fields, like tri-state or enums.
  EODOC
  spec.homepage = "https://github.com/galtzo-floss/flag_shih_tzu"
  spec.licenses = ["MIT"]
  spec.required_ruby_version = ">= 2.4"

  # Linux distros often package gems and securely certify them independent
  #   of the official RubyGem certification process. Allowed via ENV["SKIP_GEM_SIGNING"]
  # Ref: https://gitlab.com/ruby-oauth/version_gem/-/issues/3
  # Hence, only enable signing if `SKIP_GEM_SIGNING` is not set in ENV.
  # See CONTRIBUTING.md
  unless ENV.include?("SKIP_GEM_SIGNING")
    user_cert = "certs/#{ENV.fetch("GEM_CERT_USER", ENV["USER"])}.pem"
    cert_file_path = File.join(__dir__, user_cert)
    cert_chain = cert_file_path.split(",")
    cert_chain.select! { |fp| File.exist?(fp) }
    if cert_file_path && cert_chain.any?
      spec.cert_chain = cert_chain
      if $PROGRAM_NAME.end_with?("gem") && ARGV[0] == "build"
        spec.signing_key = File.join(Gem.user_home, ".ssh", "gem-private_key.pem")
      end
    end
  end

  spec.metadata["homepage_uri"] = "https://flag-shih-tzu.galtzo.com"
  spec.metadata["source_code_uri"] = "#{spec.homepage}/tree/v#{spec.version}"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/v#{spec.version}/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/#{spec.name}/#{spec.version}"
  spec.metadata["funding_uri"] = "https://github.com/sponsors/pboling"
  spec.metadata["wiki_uri"] = "#{spec.homepage}/wiki"
  spec.metadata["news_uri"] = "https://www.railsbling.com/tags/#{spec.name}"
  spec.metadata["discord_uri"] = "https://discord.gg/3qme4XHNKN"
  spec.metadata["rubygems_mfa_required"] = "true"

  enumerate_package_files = lambda do |root|
    Dir.glob(File.join(root, "**", "*"), File::FNM_DOTMATCH).select do |path|
      File.file?(path) && ![".", ".."].include?(File.basename(path))
    end
  end

  # Specify which files are part of the released package.
  spec.files = [
    # Root license files
    "LICENSE.md",
    "MIT.md",
    # Code / tasks / data (NOTE: exe/ is specified via spec.bindir and spec.executables below)
    *enumerate_package_files.call("lib"),
    # Executables and executable support scripts
    *enumerate_package_files.call("exe"),
    # Public certs for gem signing
    *enumerate_package_files.call("certs"),
    # Signatures
    *enumerate_package_files.call("sig")
  ]

  # Automatically included with gem package, no need to list again in files.
  spec.extra_rdoc_files = Dir[
    # Files (alphabetical)
    "CHANGELOG.md",
    "CITATION.cff",
    "CODE_OF_CONDUCT.md",
    "CONTRIBUTING.md",
    "FUNDING.md",
    "LICENSE.md",
    "README.md",
    "RUBOCOP.md",
    "SECURITY.md"
  ]
  spec.rdoc_options += [
    "--title",
    "#{spec.name} - #{spec.summary}",
    "--main",
    "README.md",
    "--exclude",
    "^sig/",
    "--line-numbers",
    "--inline-source",
    "--quiet"
  ]
  spec.bindir = "exe"
  # Listed files are the relative paths from bindir above.
  spec.executables = enumerate_package_files.call(spec.bindir).map { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Utilities
  spec.add_dependency("version_gem", "~> 1.1", ">= 1.1.13")              # ruby >= 2.2.0

  # NOTE: It is preferable to list development dependencies in the gemspec due to increased
  #       visibility and discoverability.
  #       However, development dependencies in gemspec will install on
  #       all versions of Ruby that will run in CI.
  #       This gem, and its gemspec runtime dependencies, will install on Ruby down to 2.4.
  #       This gem, and its gemspec development dependencies, will install on Ruby down to 2.4.
  #       Thus, dev dependencies in gemspec must have
  #
  #       required_ruby_version ">= 2.4" (or lower)
  #
  #       Development dependencies that require strictly newer Ruby versions should be in a "gemfile",
  #       and preferably a modular one (see gemfiles/modular/*.gemfile).

  # Dev, Test, & Release Tasks
  spec.add_development_dependency("kettle-dev", "~> 2.3", ">= 2.3.0")     # ruby >= 2.4

  # Security
  spec.add_development_dependency("bundler-audit", "~> 0.9.3")                      # ruby >= 2.0.0

  # Tasks
  spec.add_development_dependency("rake", "~> 13.0")                                # ruby >= 2.2.0

  # Debugging
  spec.add_development_dependency("require_bench", "~> 1.0", ">= 1.0.4")            # ruby >= 2.2.0

  # Testing
  spec.add_development_dependency("appraisal2", "~> 3.1", ">= 3.1.4")               # ruby >= 1.8.7, for testing against multiple versions of dependencies
  spec.add_development_dependency("kettle-test", "~> 2.0", ">= 2.0.9")             # ruby >= 2.4
  spec.add_development_dependency("turbo_tests2", "~> 3.1", ">= 3.1.5")            # ruby >= 2.4.0, default kettle-test runner

  # Releasing
  spec.add_development_dependency("ruby-progressbar", "~> 1.13")                    # ruby >= 0
  spec.add_development_dependency("stone_checksums", "~> 1.0", ">= 1.0.4")          # ruby >= 2.2.0

  # spec.add_development_dependency("erb", ">= 2.2")                                  # ruby >= 2.3.0, not SemVer, old rubies get dropped in a patch.
  spec.add_development_dependency("gitmoji-regex", "~> 2.0", ">= 2.0.3")            # ruby >= 2.4
end
