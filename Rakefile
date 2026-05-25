# frozen_string_literal: true

# kettle-jem:freeze
# To retain chunks of comments & code during flag_shih_tzu templating:
# Wrap custom sections with freeze markers (e.g., as above and below this comment chunk).
# flag_shih_tzu will then preserve content between those markers across template runs.
# kettle-jem:unfreeze

# flag_shih_tzu Rakefile v7.0.0 - 2026-05-25
# Ruby 2.3 (Safe Navigation) or higher required
#
# See LICENSE.md for license information.
#
# Copyright (c) 2026 Peter H. Boling (galtzo.com)
#
# Expected to work in any project that uses Bundler.
#
# Sets up tasks for appraisal2, floss_funding, kettle-jem, kettle-dev, rspec, minitest, rubocop_gradual, reek, yard, and stone_checksums.
#
# rake appraisal:install                      # Install Appraisal gemfiles (initial setup...
# rake appraisal:reset                        # Delete Appraisal lockfiles (gemfiles/*.gemfile.lock)
# rake appraisal:update                       # Update Appraisal gemfiles and run RuboCop...
# rake bench                                  # Run all benchmarks (alias for bench:run)
# rake bench:list                             # List available benchmark scripts
# rake bench:run                              # Run all benchmark scripts (skips on CI)
# rake build:generate_checksums               # Generate both SHA256 & SHA512 checksums i...
# rake bundle:audit:check                     # Checks the Gemfile.lock for insecure depe...
# rake bundle:audit:update                    # Updates the bundler-audit vulnerability d...
# rake ci:act[opt]                            # Run 'act' with a selected workflow
# rake coverage                               # Run specs w/ coverage and open results in...
# rake default                                # Default tasks aggregator
# rake install                                # Build and install flag_shih_tzu-1.0.0.gem in...
# rake install:local                          # Build and install flag_shih_tzu-1.0.0.gem in...
# rake kettle:jem:install                     # Internal target used by `kettle-jem install`
# rake kettle:jem:selftest                    # Self-test: template flag_shih_tzu against itse...
# rake kettle:jem:template                    # Internal target used by `kettle-jem template`
# rake reek                                   # Check for code smells
# rake reek:update                            # Run reek and store the output into the RE...
# rake release[remote]                        # Create tag v1.0.0 and build and push kett...
# rake rubocop_gradual                        # Run RuboCop Gradual
# rake rubocop_gradual:autocorrect            # Run RuboCop Gradual with autocorrect (onl...
# rake rubocop_gradual:autocorrect_all        # Run RuboCop Gradual with autocorrect (saf...
# rake rubocop_gradual:check                  # Run RuboCop Gradual to check the lock file
# rake rubocop_gradual:force_update           # Run RuboCop Gradual to force update the l...
# rake rubocop_gradual_debug                  # Run RuboCop Gradual
# rake rubocop_gradual_debug:autocorrect      # Run RuboCop Gradual with autocorrect (onl...
# rake rubocop_gradual_debug:autocorrect_all  # Run RuboCop Gradual with autocorrect (saf...
# rake rubocop_gradual_debug:check            # Run RuboCop Gradual to check the lock file
# rake rubocop_gradual_debug:force_update     # Run RuboCop Gradual to force update the l...
# rake spec                                   # Run RSpec code examples
# rake test                                   # Run tests
# rake yard                                   # Generate YARD Documentation
#

# :nocov:
require "bundler/gem_tasks" if !Dir[File.join(__dir__, "*.gemspec")].empty?
# :nocov:

require "rake/testtask"

# Define a base default task early so other files can enhance it.
desc "Default tasks aggregator"

task :default do
  puts "Default task complete."
end

# External gems that define tasks - add here!
begin
  require "kettle/dev"
  Kettle::Dev.install_tasks unless Kettle::Dev::RUNNING_AS == "rake"
rescue LoadError
  warn("NOTE: kettle-dev isn't installed, or is disabled for #{RUBY_VERSION} in the current environment")
end

Rake::TestTask.new(:minitest) do |task|
  task.libs << "lib"
  task.pattern = "test/**/*_test.rb"
  task.verbose = true
end

### TEMPLATING TASKS
# These tasks are installed for the `kettle-jem` executable. Run templating
# through `kettle-jem template` or `kettle-jem install`; the executable prepares
# the environment and then delegates here when rake orchestration is needed.
begin
  require "kettle/jem"
  Kettle::Jem.install_tasks
rescue LoadError
  desc("(stub) kettle:jem:selftest is unavailable")
  task("kettle:jem:selftest") do
    warn("NOTE: kettle-jem isn't installed, or is disabled for #{RUBY_VERSION} in the current environment")
  end
end

### RELEASE TASKS
# Setup stone_checksums
begin
  require "stone_checksums"
rescue LoadError
  desc("(stub) build:generate_checksums is unavailable")
  task("build:generate_checksums") do
    warn("NOTE: stone_checksums isn't installed, or is disabled for #{RUBY_VERSION} in the current environment")
  end
end
