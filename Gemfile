# frozen_string_literal: true

source "https://gem.coop"

git_source(:github) { |repo_name| "git@github.com:#{repo_name}.git" }
git_source(:codeberg) { |repo_name| "https://codeberg.org/#{repo_name}" }
git_source(:gitlab) { |repo_name| "https://gitlab.com/#{repo_name}" }

#### IMPORTANT #######################################################
# Gemfile is for local development ONLY; Gemfile is NOT loaded in CI #
####################################################### IMPORTANT ####

# Include dependencies from flag_shih_tzu.gemspec
gemspec

# Default local test bundle
eval_gemfile "gemfiles/modular/activerecord_runtime.gemfile"
eval_gemfile "gemfiles/modular/activerecord_support_modern.gemfile"

gem "kettle-family", "~> 1.2", ">= 1.2.64"

# Local workspace dependency wiring for *_local.gemfile overrides
gem "nomono", "~> 1.1", ">= 1.1.5", require: false # ruby >= 3.2.0

# Templating (env-switched: STRUCTUREDMERGE_DEV=/path/to/structuredmerge/ruby/gems for local paths)
eval_gemfile "gemfiles/modular/templating.gemfile" if ENV.fetch("K_JEM_TEMPLATING", "false").casecmp("true").zero?

# Debugging
eval_gemfile "gemfiles/modular/debug.gemfile"

# Code Coverage (env-switched: KETTLE_DEV_DEV=true for local paths)
eval_gemfile "gemfiles/modular/coverage.gemfile"

# Linting
eval_gemfile "gemfiles/modular/style.gemfile"

# Documentation
eval_gemfile "gemfiles/modular/documentation.gemfile"

# Changelog release tooling (available on Ruby versions supported by kettle-changelog)
eval_gemfile "gemfiles/modular/changelog.gemfile"

# Optional
eval_gemfile "gemfiles/modular/optional.gemfile"

### Std Lib Extracted Gems
eval_gemfile "gemfiles/modular/x_std_libs.gemfile"

# See unlocked_deps appraisal for more details on irb inclusion
gem "irb", "~> 1.17" # ruby >= 2.7
