# Changelog

[![SemVer 2.0.0][📌semver-img]][📌semver] [![Keep-A-Changelog 1.0.0][📗keep-changelog-img]][📗keep-changelog]

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][📗keep-changelog],
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html),
and [yes][📌major-versions-not-sacred], platform and engine support are part of the [public API][📌semver-breaking].
Please file a bug if you notice a violation of semantic versioning.

[📌semver]: https://semver.org/spec/v2.0.0.html
[📌semver-img]: https://img.shields.io/badge/semver-2.0.0-FFDD67.svg?style=flat
[📌semver-breaking]: https://github.com/semver/semver/issues/716#issuecomment-869336139
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html
[📗keep-changelog]: https://keepachangelog.com/en/1.0.0/
[📗keep-changelog-img]: https://img.shields.io/badge/keep--a--changelog-1.0.0-FFDD67.svg?style=flat

## [Unreleased]

### Added

### Changed

### Deprecated

### Removed

### Fixed

### Security

## [0.3.23] - 2018-11-30

* Avoid establishing a database connection unless necessary by Jonathan del Strother

## [0.3.22] - 2018-09-18

* When #selected_flags= passed with nil it clears flag bits, by xpol
    - This makes flag_shih_tzu behave like Rails: converts empty array to nil.

## [0.3.21] - 2018-09-09

* Make required minimum Ruby version explicit: 1.9.3 and up by Peter Boling
* Support Rails 5.2 by Peter Boling
* Add Ruby 2.5 to build, and update/fix build by Peter Boling

## [0.3.20] - 2018-09-08

* Fix generated instance methods. by xpol
* Support Rails 5.1 saved_change by shiro16

## [0.3.19] - 2017-05-15

* Fixed a bug in Rails 5 support.
* Added Rails 5.1 to travis.

## [0.3.18] - 2017-04-30

* Switched from Fixnum to Integer for Ruby 2.4 happiness
* Fixed build for all supported Ruby and Rails versions in supported matrix

## [0.3.17] - 2017-04-29

* Improved compatibility with Rails 5.0
* Fixed warnings about Fixnums
* Fixed compatibility with SQLlite
* Added Ruby 2.3, and 2.4 to the Travis Matrix
* Removed JRuby 1.7 from the Travis Matrix

## [0.3.16] - 2017-01-16

* Fix complex custom sql queries with multiple references to the column by vegetaras
* Improved documentation and compatibility matrix  by Peter Boling

## [0.3.15] - 2015-10-11

* Fixed testing for all supported environments by Peter Boling
* Testing on Travis: added Ruby jruby-9.0.1.0 by Peter Boling
* Documented compatibility matrix in table in README by Peter Boling

## [0.3.14] - 2015-10-08

* Allow use without ActiveRecord (experimental) by jfcaiceo
* Many net-zero code cleanups to follow Ruby Style Guide
* Improved local testing script rake test:all
* Testing on Travis: added Ruby 1.9.3, 2.1.5, 2.2.3, jruby-1.7.0
* Testing on Travis: removed Ruby 2.1.2

## [0.3.13] - 2015-03-13

* methods for use with form builders like simple_form by Peter Boling

    - chained_flags_with_signature
    - chained_#{colmn}_with_signature
    - as_flag_collection
    - as_#{colmn.singularize}_collection
    - selected_flags=
    - selected_#{colmn}= (already existed)
* Testing on Travis: added Ruby 2.2.1
* Testing on Travis: removed Ruby 1.9.2

## [0.3.12] - 2014-10-01

* Improve testing instructions in readme by Peter Boling
* fix check_flag_column to return false after warn by Peter Boling
* bash script for running complete test suite on Ruby 1.9.3 and Ruby 2.1.2 by Peter Boling
* Improve documentation in readme by trliner
* use aliases to make attribute reader methods more DRY by trliner
* add negative attribute reader and writer methods for improved interoperability with simple_form and formtastic by trliner
* Adds specs for ActiveRecord version 4.1 by Peter Boling
* Use Kernel#warn instead of puts by Peter Boling

## [0.3.11] - 2014-07-09

* Rename some ambigously-named methods mixed into AR::Base by jdelStrother
* Add dynamic ".*_values_for" helpers by atipugin

## [0.3.10] - 2014-11-26

* Can run tests without coverage by specifying NOCOVER=true by Peter Boling
* Improved test coverage by Peter Boling
* Improved documentation by Peter Boling
* Readme converted to Markdown by Peter Boling

## [0.3.9] - 2013-11-25

* Removed runtime dependency on active record and active support by Peter Boling
* Fixed Coveralls Configuration by Peter Boling
* Improved Readme by Peter Boling

## [0.3.8] - 2013-11-24

* Improved Readme / Documentation by Peter Boling
* Added Badges by Peter Boling
* Configured Coveralls by Peter Boling
* Added Code Climate, Coveralls, Gemnasium, and Version Badges by Peter Boling

## [0.3.7] - 2013-10-25

* Change `sql_in_for_flag` to consider values from the range [0, 2 * max - 1] by Blake Thomson

## [0.3.6] - 2013-08-29

* Allow use with any gem manager by Peter Boling
* No need to alter Ruby's load path by Peter Boling

## [0.3.5] - 2013-08-06

* Fix Travis Build & Add Rails 4 by Peter M. Goldstein
* Implemented update_flag! by Peter Boling (see https://github.com/pboling/flag_shih_tzu/issues/27)
    - sets a flag on a record without triggering callbacks or validations
    - optionally syncs the instance with new flag value, by default it does not.
* Update gemspec by Peter Boling

## [0.3.4] - 2013-06-20

* Allow non sequential flag numbers by Thomas Jachmann
* Report correct source location for class_evaled methods. by Sebastian Korfmann
* Implemented chained_flags_with, which allows optimizing the bit search by Tatsuhiko Miyagawa
* [bugfix] flag_options[colmn][:column] is symbol, it causes error undefined method `length' for nil:NilClass by Artem Pisarev
* Validator raises an error if the validated column is not a flags column. by David DIDIER
* Allow multiple include by Peter Goldstein
* fix a deprecation warning in rails4 by Mose
* Add flag_keys convenience method. by Keith Pitty
* [bugfix] Column names provided as symbols fully work now, as they are converted to strings by Peter Boling
* [bugfix issues/28] Since 0.3.0 flags no longer work in a class using an alternative database connection by Peter Boling
* [bugfix issues/7] Breaks db:create rake task by Peter Boling
* convenience methods now have default parameter so `all_flags` works with arity 0. by Peter Boling
* Many more tests, including arity tests by Peter Boling

## [0.3.3] - 2013-06-20

- Does not exist.

## [0.3.2] - 2012-11-06

* Adds skip column check option :check_for_column - from arturaz
* Adds a 'smart' set_flag_sql method which will auto determine the correct column for the given flag - from arturaz
* Changes the behavior of sql_set_for_flag to not use table names in the generated SQL
    - because it didn't actually work before
    - Now there is a test ensuring that the generated SQL can be executed by a real DB
    - This improved sql_set_for_flag underlies the public set_flag_sql method

## [0.3.1] - 2012-11-06

* Adds new methods (for a flag column named 'bar', with many individual flags within) - from ddidier
    - all_bar, selected_bar, select_all_bar, unselect_all_bar, selected_bar=(selected_flags), has_bar?

## [0.3.0] - 2012-11-05

* first version maintained by Peter Boling
* ClassWithHasFlags.set_#{flag_name}_sql # Returns the sql string for setting a flag for use in customized SQL
* ClassWithHasFlags.unset_#{flag_name}_sql # Returns the sql string for unsetting a flag for use in customized SQL
* ClassWithHasFlags.flag_columns # Returns the column_names used by FlagShihTzu as bit fields
* has_flags :strict => true # DuplicateFlagColumnException raised when a single DB column is declared as a flag column twice
* Less verbosity for expected conditions when the DB connection for the class is unavailable.
* Tests for additional features, but does not change any behavior of 0.2.3 / 0.2.4 by default.
* Easily migrate from 0.2.3 and 0.2.4. Goal is no code changes required. Minor version bump to encourage caution.

## [0.2.4] - 2012-11-05

* released last few changes from XING master
* Fix deprecation warning for set_table_name
* Optional bang methods
* Complete Ruby 1.9(\.[^1]) and Rails 3.2.X compatibility

## [0.2.3] - 2011-10-31

* first, last, and only version maintained by XING AG (excepting prereleases)
