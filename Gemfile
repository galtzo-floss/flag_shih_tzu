source "http://rubygems.org"

# SO the gem can run the simple test suite against the raw bundled gems without the complex BUNDLE_GEMFILE setup
gem "sqlite3", :platforms => [:ruby]

# Specify your gem's dependencies in flag_shih_tzu.gemspec
gemspec
source "https://rubygems.org"
git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }
git_source(:gitlab) { |repo_name| "https://gitlab.com/#{repo_name}" }
eval_gemfile "gemfiles/modular/debug.gemfile"
eval_gemfile "gemfiles/modular/coverage.gemfile"
eval_gemfile "gemfiles/modular/style.gemfile"
eval_gemfile "gemfiles/modular/documentation.gemfile"
eval_gemfile "gemfiles/modular/optional.gemfile"
eval_gemfile "gemfiles/modular/x_std_libs.gemfile"
