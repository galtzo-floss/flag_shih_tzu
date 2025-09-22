[![Galtzo FLOSS Logo by Aboling0, CC BY-SA 4.0][🖼️galtzo-i]][🖼️galtzo-discord] [![ruby-lang Logo, Yukihiro Matsumoto, Ruby Visual Identity Team, CC BY-SA 2.5][🖼️ruby-lang-i]][🖼️ruby-lang] [![flag_shih_tzu Logo by Aboling0, CC BY-SA 4.0][🖼️flag_shih_tzu-i]][🖼️flag_shih_tzu]

[🖼️galtzo-i]: https://logos.galtzo.com/assets/images/galtzo-floss/avatar-192px.svg
[🖼️galtzo-discord]: https://discord.gg/3qme4XHNKN
[🖼️ruby-lang-i]: https://logos.galtzo.com/assets/images/ruby-lang/avatar-192px.svg
[🖼️ruby-lang]: https://www.ruby-lang.org/
[🖼️flag_shih_tzu-i]: https://logos.galtzo.com/assets/images/pboling/flag_shih_tzu/avatar-192px.svg
[🖼️flag_shih_tzu]: https://github.com/pboling/flag_shih_tzu

# 🏁 FlagShihTzu

[![Version][👽versioni]][👽version] [![GitHub tag (latest SemVer)][⛳️tag-img]][⛳️tag] [![License: MIT][📄license-img]][📄license-ref] [![Downloads Rank][👽dl-ranki]][👽dl-rank] [![Open Source Helpers][👽oss-helpi]][👽oss-help] [![CodeCov Test Coverage][🏀codecovi]][🏀codecov] [![Coveralls Test Coverage][🏀coveralls-img]][🏀coveralls] [![QLTY Test Coverage][🏀qlty-covi]][🏀qlty-cov] [![QLTY Maintainability][🏀qlty-mnti]][🏀qlty-mnt] [![CI Heads][🚎3-hd-wfi]][🚎3-hd-wf] [![CI Runtime Dependencies @ HEAD][🚎12-crh-wfi]][🚎12-crh-wf] [![CI Current][🚎11-c-wfi]][🚎11-c-wf] [![CI Truffle Ruby][🚎9-t-wfi]][🚎9-t-wf] [![CI JRuby][🚎10-j-wfi]][🚎10-j-wf] [![Deps Locked][🚎13-🔒️-wfi]][🚎13-🔒️-wf] [![Deps Unlocked][🚎14-🔓️-wfi]][🚎14-🔓️-wf] [![CI Supported][🚎6-s-wfi]][🚎6-s-wf] [![CI Legacy][🚎4-lg-wfi]][🚎4-lg-wf] [![CI Unsupported][🚎7-us-wfi]][🚎7-us-wf] [![CI Ancient][🚎1-an-wfi]][🚎1-an-wf] [![CI Test Coverage][🚎2-cov-wfi]][🚎2-cov-wf] [![CI Style][🚎5-st-wfi]][🚎5-st-wf] [![CodeQL][🖐codeQL-img]][🖐codeQL] [![Apache SkyWalking Eyes License Compatibility Check][🚎15-🪪-wfi]][🚎15-🪪-wf]

`if ci_badges.map(&:color).detect { it != "green"}` ☝️ [let me know][🖼️galtzo-discord], as I may have missed the [discord notification][🖼️galtzo-discord].

---

`if ci_badges.map(&:color).all? { it == "green"}` 👇️ send money so I can do more of this. FLOSS maintenance is now my full-time job.

[![OpenCollective Backers][🖇osc-backers-i]][🖇osc-backers] [![OpenCollective Sponsors][🖇osc-sponsors-i]][🖇osc-sponsors] [![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor] [![Liberapay Goal Progress][⛳liberapay-img]][⛳liberapay] [![Donate on PayPal][🖇paypal-img]][🖇paypal] [![Buy me a coffee][🖇buyme-small-img]][🖇buyme] [![Donate on Polar][🖇polar-img]][🖇polar] [![Donate at ko-fi.com][🖇kofi-img]][🖇kofi]

## 🌻 Synopsis

* [FlagShihTzu](#flagshihtzu)
    * [Summary](#summary)
    * [Prerequisites](#prerequisites)
        * [Compatibility Matrix](#compatibility-matrix)
    * [Installation](#installation)
        * [Rails 2.x](#rails-2x)
        * [Rails 3](#rails-3)
    * [Usage](#usage)
        * [Defaults (Important)](#defaults-important)
        * [Database Migration](#database-migration)
        * [Adding to the Model](#adding-to-the-model)
        * [Bit Fields: How it stores the values](#bit-fields-how-it-stores-the-values)
        * [Using a custom column name](#using-a-custom-column-name)
        * [Generated boolean patterned instance methods](#generated-boolean-patterned-instance-methods)
        * [Callbacks and Validations](#callbacks-and-validations)
        * [Generated class methods](#generated-class-methods)
        * [Generated named scopes](#generated-named-scopes)
        * [Examples for using the generated methods](#examples-for-using-the-generated-methods)
        * [Support for manually building conditions](#support-for-manually-building-conditions)
        * [Choosing a query mode](#choosing-a-query-mode)
        * [Updating flag column by raw sql](#updating-flag-column-by-raw-sql)
        * [Skipping flag column check](#skipping-flag-column-check)
    * [Running the gem tests](#running-the-gem-tests)
    * [Authors](#authors)
    * [How you can help!](#how-you-can-help)
    * [Contributing](#contributing)
    * [Versioning](#versioning)
    * [2012 Change of Ownership and 0.3.X Release Notes](#2012-change-of-ownership-and-03x-release-notes)
    * [Alternatives](#alternatives)
    * [License](#license)

An extension for [ActiveRecord](https://rubygems.org/gems/activerecord)
to store a collection of boolean attributes in a single integer column
as a [bit field][bit_field].

This gem lets you use a single integer column in an ActiveRecord model
to store a collection of boolean attributes (flags). Each flag can be used
almost in the same way you would use any boolean attribute on an
ActiveRecord object.

The benefits:

* No migrations needed for new boolean attributes. This helps a lot
  if you have very large db-tables, on which you want to avoid `ALTER TABLE`
  whenever possible.
* Only the one integer column needs to be indexed.
* [Bitwise Operations][bitwise_operation] are fast!

Using FlagShihTzu, you can add new boolean attributes whenever you want,
without needing any migration. Just add a new flag to the `has_flags` call.

What is a ["Shih Tzu"](http://en.wikipedia.org/wiki/Shih_Tzu)?


## Prerequisites

The gem is actively being tested against:

* MySQL, PostgreSQL and SQLite3 databases (Both Ruby and JRuby adapters)
* ActiveRecord versions 2.3.x, 3.0.x, 3.1.x, 3.2.x, 4.0.x, 4.1.x, 4.2.x, 5.0.x, 5.1.x, 5.2.x
* Ruby 1.9.3, 2.0.0, 2.1.10, 2.2.10, 2.3.7, 2.4.4, 2.5.1, jruby-1.7.x, jruby-9.1.x
* Travis tests the supported builds. See [.travis.yml](https://github.com/pboling/flag_shih_tzu/blob/master/.travis.yml) for the matrix.
* All of the supported builds can also be run locally using the `wwtd` gem.
* Forthcoming flag_shih_tzu v1.0 will only support Ruby 2.2+, JRuby-9.1+ and Rails 4.2+

## 💡 Info you can shake a stick at

| Tokens to Remember      | [![Gem name][⛳️name-img]][⛳️gem-name] [![Gem namespace][⛳️namespace-img]][⛳️gem-namespace]                                                                                                                                                                                                                                                                          |
|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Works with JRuby        | ![JRuby 9.1 Compat][💎jruby-9.1i] ![JRuby 9.2 Compat][💎jruby-9.2i] ![JRuby 9.3 Compat][💎jruby-9.3i] <br/> [![JRuby 9.4 Compat][💎jruby-9.4i]][🚎10-j-wf] [![JRuby 10.0 Compat][💎jruby-c-i]][🚎11-c-wf] [![JRuby HEAD Compat][💎jruby-headi]][🚎3-hd-wf]                                                                                                          |
| Works with Truffle Ruby | ![Truffle Ruby 22.3 Compat][💎truby-22.3i] ![Truffle Ruby 23.0 Compat][💎truby-23.0i] <br/> [![Truffle Ruby 23.1 Compat][💎truby-23.1i]][🚎9-t-wf] [![Truffle Ruby 24.1 Compat][💎truby-c-i]][🚎11-c-wf]                                                                                                                                                            |
| Works with MRI Ruby 3   | [![Ruby 3.0 Compat][💎ruby-3.0i]][🚎4-lg-wf] [![Ruby 3.1 Compat][💎ruby-3.1i]][🚎6-s-wf] [![Ruby 3.2 Compat][💎ruby-3.2i]][🚎6-s-wf] [![Ruby 3.3 Compat][💎ruby-3.3i]][🚎6-s-wf] [![Ruby 3.4 Compat][💎ruby-c-i]][🚎11-c-wf] [![Ruby HEAD Compat][💎ruby-headi]][🚎3-hd-wf]                                                                                         |
| Works with MRI Ruby 2   | ![Ruby 2.0 Compat][💎ruby-2.0i] ![Ruby 2.1 Compat][💎ruby-2.1i] ![Ruby 2.2 Compat][💎ruby-2.2i] <br/> [![Ruby 2.3 Compat][💎ruby-2.3i]][🚎1-an-wf] [![Ruby 2.4 Compat][💎ruby-2.4i]][🚎1-an-wf] [![Ruby 2.5 Compat][💎ruby-2.5i]][🚎1-an-wf] [![Ruby 2.6 Compat][💎ruby-2.6i]][🚎7-us-wf] [![Ruby 2.7 Compat][💎ruby-2.7i]][🚎7-us-wf]                              |
| Support & Community     | [![Join Me on Daily.dev's RubyFriends][✉️ruby-friends-img]][✉️ruby-friends] [![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite] [![Get help from me on Upwork][👨🏼‍🏫expsup-upwork-img]][👨🏼‍🏫expsup-upwork] [![Get help from me on Codementor][👨🏼‍🏫expsup-codementor-img]][👨🏼‍🏫expsup-codementor]                                       |
| Source                  | [![Source on GitLab.com][📜src-gl-img]][📜src-gl] [![Source on CodeBerg.org][📜src-cb-img]][📜src-cb] [![Source on Github.com][📜src-gh-img]][📜src-gh] [![The best SHA: dQw4w9WgXcQ!][🧮kloc-img]][🧮kloc]                                                                                                                                                         |
| Documentation           | [![Current release on RubyDoc.info][📜docs-cr-rd-img]][🚎yard-current] [![YARD on Galtzo.com][📜docs-head-rd-img]][🚎yard-head] [![Maintainer Blog][🚂maint-blog-img]][🚂maint-blog] [![GitLab Wiki][📜gl-wiki-img]][📜gl-wiki] [![GitHub Wiki][📜gh-wiki-img]][📜gh-wiki]                                                                                          |
| Compliance              | [![License: MIT][📄license-img]][📄license-ref] [![Compatible with Apache Software Projects: Verified by SkyWalking Eyes][📄license-compat-img]][📄license-compat] [![📄ilo-declaration-img]][📄ilo-declaration] [![Security Policy][🔐security-img]][🔐security] [![Contributor Covenant 2.1][🪇conduct-img]][🪇conduct] [![SemVer 2.0.0][📌semver-img]][📌semver] |
| Style                   | [![Enforced Code Style Linter][💎rlts-img]][💎rlts] [![Keep-A-Changelog 1.0.0][📗keep-changelog-img]][📗keep-changelog] [![Gitmoji Commits][📌gitmoji-img]][📌gitmoji] [![Compatibility appraised by: appraisal2][💎appraisal2-img]][💎appraisal2]                                                                                                                  |
| Maintainer 🎖️          | [![Follow Me on LinkedIn][💖🖇linkedin-img]][💖🖇linkedin] [![Follow Me on Ruby.Social][💖🐘ruby-mast-img]][💖🐘ruby-mast] [![Follow Me on Bluesky][💖🦋bluesky-img]][💖🦋bluesky] [![Contact Maintainer][🚂maint-contact-img]][🚂maint-contact] [![My technical writing][💖💁🏼‍♂️devto-img]][💖💁🏼‍♂️devto]                                                      |
| `...` 💖                | [![Find Me on WellFound:][💖✌️wellfound-img]][💖✌️wellfound] [![Find Me on CrunchBase][💖💲crunchbase-img]][💖💲crunchbase] [![My LinkTree][💖🌳linktree-img]][💖🌳linktree] [![More About Me][💖💁🏼‍♂️aboutme-img]][💖💁🏼‍♂️aboutme] [🧊][💖🧊berg] [🐙][💖🐙hub]  [🛖][💖🛖hut] [🧪][💖🧪lab]                                                                   |

### Compatibility

Compatible with MRI Ruby 1.9.3+, and concordant releases of JRuby, and TruffleRuby.

| Ruby / Active Record  | 2.3.x | 3.0.x | 3.1.x | 3.2.x | 4.0.x | 4.1.x | 4.2.x | 5.0.x | 5.1.x | 5.2.x |
|:---------------------:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|
| 1.9.3                 | ✓     | ✓     | ✓     | ✓     |       |       |       |       |       |       |
| 2.0.0                 |       | ✓     | ✓     | ✓     | ✓     | ✓     | ✓     |       |       |       |
| 2.1.x                 |       |       |       | ✓     | ✓     | ✓     | ✓     |       |       |       |
| 2.2.0-2.2.1           |       |       |       | ✓     | ✓     | ✓     | ✓     |       |       |       |
| 2.2.2+                |       |       |       | ✓     | ✓     | ✓     | ✓     | ✓     | ✓     | ✓     |
| 2.3.x                 |       |       |       | ✓     | ✓     | ✓     | ✓     | ✓     | ✓     | ✓     |
| 2.4.x                 |       |       |       |       |       |       | ✓     | ✓     | ✓     | ✓     |
| 2.5.x                 |       |       |       |       |       |       | ✓     | ✓     | ✓     | ✓     |
| jruby-1.7.x           | ?     | ?     | ✓     | ✓     | ✓     | ✓     | ✓     |       |       |       |
| jruby-9.1             |       | ✓     | ✓     | ✓     | ✓     | ✓     | ✓     | ✓     | ✓     | ✓     |
| jruby-9.2             |       |       |       |       |       |       | ✓     | ✓     | ✓     | ✓     |

* Notes
    - JRuby 1.7.x aims for MRI 1.9.3 compatibility
        - `?` indicates incompatible due to 2 failures in the test suite.
    - JRuby 9.1 aims for MRI 2.2 compatibility
    - JRuby 9.2 aims for MRI 2.5 compatibility
    - Forthcoming flag_shih_tzu v1.0 will only support Ruby 2.2+, JRuby-9.1+ and Rails 4.2+

**Legacy**

* Ruby 1.8.7 compatibility is in the [0.2.X branch](https://github.com/pboling/flag_shih_tzu/tree/0.2.X) and no further releases are expected.  If you need a patch submit a pull request.

* Ruby 1.9.3, 2.0.0, 2.1.x, and 2.2.x compatibility is still current on master, and the 0.3.x series releases, but those EOL'd Rubies, and any others that become EOL'd in the meantime, will not be supported in the next major release, version 1.0.

| 🚚 _Amazing_ test matrix was brought to you by | 🔎 appraisal2 🔎 and the color 💚 green 💚             |
|------------------------------------------------|--------------------------------------------------------|
| 👟 Check it out!                               | ✨ [github.com/appraisal-rb/appraisal2][💎appraisal2] ✨ |

### Federated DVCS

<details>
  <summary>Find this repo on federated forges (Coming soon!)</summary>

| Federated [DVCS][💎d-in-dvcs] Repository        | Status                                                                | Issues                    | PRs                      | Wiki                      | CI                       | Discussions                  |
|-------------------------------------------------|-----------------------------------------------------------------------|---------------------------|--------------------------|---------------------------|--------------------------|------------------------------|
| 🧪 [pboling/flag_shih_tzu on GitLab][📜src-gl]   | The Truth                                                             | [💚][🤝gl-issues]         | [💚][🤝gl-pulls]         | [💚][📜gl-wiki]           | 🐭 Tiny Matrix           | ➖                            |
| 🧊 [pboling/flag_shih_tzu on CodeBerg][📜src-cb] | An Ethical Mirror ([Donate][🤝cb-donate])                             | [💚][🤝cb-issues]         | [💚][🤝cb-pulls]         | ➖                         | ⭕️ No Matrix             | ➖                            |
| 🐙 [pboling/flag_shih_tzu on GitHub][📜src-gh]   | Another Mirror                                                        | [💚][🤝gh-issues]         | [💚][🤝gh-pulls]         | [💚][📜gh-wiki]           | 💯 Full Matrix           | [💚][gh-discussions]         |
| 🎮️ [Discord Server][✉️discord-invite]          | [![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite] | [Let's][✉️discord-invite] | [talk][✉️discord-invite] | [about][✉️discord-invite] | [this][✉️discord-invite] | [library!][✉️discord-invite] |

</details>

[gh-discussions]: https://github.com/pboling/flag_shih_tzu/discussions

### Enterprise Support [![Tidelift](https://tidelift.com/badges/package/rubygems/flag_shih_tzu)](https://tidelift.com/subscription/pkg/rubygems-flag_shih_tzu?utm_source=rubygems-flag_shih_tzu&utm_medium=referral&utm_campaign=readme)

Available as part of the Tidelift Subscription.

<details>
  <summary>Need enterprise-level guarantees?</summary>

The maintainers of this and thousands of other packages are working with Tidelift to deliver commercial support and maintenance for the open source packages you use to build your applications. Save time, reduce risk, and improve code health, while paying the maintainers of the exact packages you use.

[![Get help from me on Tidelift][🏙️entsup-tidelift-img]][🏙️entsup-tidelift]

- 💡Subscribe for support guarantees covering _all_ your FLOSS dependencies
- 💡Tidelift is part of [Sonar][🏙️entsup-tidelift-sonar]
- 💡Tidelift pays maintainers to maintain the software you depend on!<br/>📊`@`Pointy Haired Boss: An [enterprise support][🏙️entsup-tidelift] subscription is "[never gonna let you down][🧮kloc]", and *supports* open source maintainers

Alternatively:

- [![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite]
- [![Get help from me on Upwork][👨🏼‍🏫expsup-upwork-img]][👨🏼‍🏫expsup-upwork]
- [![Get help from me on Codementor][👨🏼‍🏫expsup-codementor-img]][👨🏼‍🏫expsup-codementor]

</details>

## ✨ Installation

Install the gem and add to the application's Gemfile by executing:

```console
bundle add flag_shih_tzu
```

If bundler is not being used to manage dependencies, install the gem by executing:

```console
gem install flag_shih_tzu
```

### 🔒 Secure Installation

<details>
  <summary>For Medium or High Security Installations</summary>

This gem is cryptographically signed, and has verifiable [SHA-256 and SHA-512][💎SHA_checksums] checksums by
[stone_checksums][💎stone_checksums]. Be sure the gem you install hasn’t been tampered with
by following the instructions below.

Add my public key (if you haven’t already, expires 2045-04-29) as a trusted certificate:

```console
gem cert --add <(curl -Ls https://raw.github.com/galtzo-floss/certs/main/pboling.pem)
```

You only need to do that once.  Then proceed to install with:

```console
gem install flag_shih_tzu -P HighSecurity
```

The `HighSecurity` trust profile will verify signed gems, and not allow the installation of unsigned dependencies.

If you want to up your security game full-time:

```console
bundle config set --global trust-policy MediumSecurity
```

`MediumSecurity` instead of `HighSecurity` is necessary if not all the gems you use are signed.

NOTE: Be prepared to track down certs for signed gems and add them the same way you added mine.

</details>

## ⚙️ Configuration

FlagShihTzu assumes that your ActiveRecord model already has an [integer field][bit_field]
to store the flags, which should be defined to not allow `NULL` values and
should have a default value of `0`.

### Defaults (Important)

* Due to the default of `0`, *all flags* are initially set to "false").
* For a default of true it will probably be easier in the long run to negate the flag's meaning / name.
  ** Such as `switched_on` => `switched_off`
* If you **really** want a different, non-zero, default value for a flag column, proceed *adroitly* with a different sql default for the flag column.

## 🔧 Basic Usage

### Database Migration

I like to document the intent of the `flags` column in the migration when I can...

```ruby
change_table :spaceships do |t|
  t.integer     :flags, :null => false, :default => 0 # flag_shih_tzu-managed bit field
  # Effective booleans which will be stored on the flags column:
  # t.boolean      :warpdrive
  # t.boolean      :shields
  # t.boolean      :electrolytes
end
```

### Adding to the Model

```ruby
class Spaceship < ActiveRecord::Base
  include FlagShihTzu

  has_flags 1 => :warpdrive,
            2 => :shields,
            3 => :electrolytes
end
```

`has_flags` takes a hash. The keys must be positive integers and represent
the position of the bit being used to enable or disable the flag.
**The keys must not be changed once in use, or you will get incorrect results.**
That is why the plugin forces you to set them explicitly.
The values are symbols for the flags being created.


### Bit Fields: How it stores the values

As said, FlagShihTzu uses a single integer column to store the values for all
the defined flags as a [bit field][bitfield].

The bit position of a flag corresponds to the given key.

This way, we can use [bitwise operators][bit_operation] on the stored integer value to set, unset
and check individual flags.

                  `---+---+---+                +---+---+---`
                  |   |   |   |                |   |   |   |
    Bit position  | 3 | 2 | 1 |                | 3 | 2 | 1 |
    (flag key)    |   |   |   |                |   |   |   |
                  `---+---+---+                +---+---+---`
                  |   |   |   |                |   |   |   |
    Bit value     | 4 | 2 | 1 |                | 4 | 2 | 1 |
                  |   |   |   |                |   |   |   |
                  `---+---+---+                +---+---+---`
                  | e | s | w |                | e | s | w |
                  | l | h | a |                | l | h | a |
                  | e | i | r |                | e | i | r |
                  | c | e | p |                | c | e | p |
                  | t | l | d |                | t | l | d |
                  | r | d | r |                | r | d | r |
                  | o | s | i |                | o | s | i |
                  | l |   | v |                | l |   | v |
                  | y |   | e |                | y |   | e |
                  | t |   |   |                | t |   |   |
                  | e |   |   |                | e |   |   |
                  | s |   |   |                | s |   |   |
                  `---+---+---+                +---+---+---`
                  | 1 | 1 | 0 | = 4 ` 2 = 6    | 1 | 0 | 1 | = 4 ` 1 = 5
                  `---+---+---+                +---+---+---`

Read more about [bit fields][bit_field] here: http://en.wikipedia.org/wiki/Bit_field


### Using a custom column name

The default column name to store the flags is `flags`, but you can provide a
custom column name using the `:column` option. This allows you to use
different columns for separate flags:

```ruby
has_flags 1 => :warpdrive,
          2 => :shields,
          3 => :electrolytes,
          :column => 'features'

has_flags 1 => :spock,
          2 => :scott,
          3 => :kirk,
          :column => 'crew'
```

### Generated boolean patterned instance methods

Calling `has_flags`, as shown above on the 'features' column, creates the following instance methods
on Spaceship:

    Spaceship#all_features # [:warpdrive, :shields, :electrolytes]
    Spaceship#selected_features
    Spaceship#select_all_features
    Spaceship#unselect_all_features
    Spaceship#selected_features=

    Spaceship#warpdrive
    Spaceship#warpdrive?
    Spaceship#warpdrive=
    Spaceship#not_warpdrive
    Spaceship#not_warpdrive?
    Spaceship#not_warpdrive=
    Spaceship#warpdrive_changed?
    Spaceship#has_warpdrive?

    Spaceship#shields
    Spaceship#shields?
    Spaceship#shields=
    Spaceship#not_shields
    Spaceship#not_shields?
    Spaceship#not_shields=
    Spaceship#shields_changed?
    Spaceship#has_shield?

    Spaceship#electrolytes
    Spaceship#electrolytes?
    Spaceship#electrolytes=
    Spaceship#not_electrolytes
    Spaceship#not_electrolytes?
    Spaceship#not_electrolytes=
    Spaceship#electrolytes_changed?
    Spaceship#has_electrolyte?


### Callbacks and Validations

Optionally, you can set the `:bang_methods` option to true to also define the bang methods:

    Spaceship#electrolytes!     # will save the bitwise equivalent of electrolytes = true on the record
    Spaceship#not_electrolytes! # will save the bitwise equivalent of electrolytes = false on the record

which respectively enables or disables the electrolytes flag.

The `:bang_methods` does not save the records to the database, meaning it *cannot* engage validations and callbacks.

Alternatively, if you do want to *save a flag* to the database, while still avoiding validations and callbacks, use `update_flag!` which:

* sets a flag on a database record without triggering callbacks or validations
* optionally syncs the ruby instance with new flag value, by default it does not.


Example:

```ruby
update_flag!(flag_name, flag_value, update_instance = false)
```


### Generated class methods

Calling `has_flags` as shown above creates the following class methods
on Spaceship:

```ruby
Spaceship.flag_columns      # [:features, :crew]
```


### Generated named scopes

The following named scopes become available:

```ruby
Spaceship.warpdrive         # :conditions => "(spaceships.flags in (1,3,5,7))"
Spaceship.not_warpdrive     # :conditions => "(spaceships.flags not in (1,3,5,7))"
Spaceship.shields           # :conditions => "(spaceships.flags in (2,3,6,7))"
Spaceship.not_shields       # :conditions => "(spaceships.flags not in (2,3,6,7))"
Spaceship.electrolytes      # :conditions => "(spaceships.flags in (4,5,6,7))"
Spaceship.not_electrolytes  # :conditions => "(spaceships.flags not in (4,5,6,7))"
```

If you do not want the named scopes to be defined, set the
`:named_scopes` option to false when calling `has_flags`:

```ruby
has_flags 1 => :warpdrive, 2 => :shields, 3 => :electrolytes, :named_scopes => false
```

In a Rails 3+ application, FlagShihTzu will use `scope` internally to generate
the scopes. The option on `has_flags` is still named `:named_scopes` however.


### Examples for using the generated methods

```ruby
enterprise = Spaceship.new
enterprise.warpdrive = true
enterprise.shields = true
enterprise.electrolytes = false
enterprise.save

if enterprise.shields?
  # ...
end

Spaceship.warpdrive.find(:all)
Spaceship.not_electrolytes.count
```


### Support for manually building conditions

The following class methods may support you when manually building
ActiveRecord conditions:

```ruby
Spaceship.warpdrive_condition         # "(spaceships.flags in (1,3,5,7))"
Spaceship.not_warpdrive_condition     # "(spaceships.flags not in (1,3,5,7))"
Spaceship.shields_condition           # "(spaceships.flags in (2,3,6,7))"
Spaceship.not_shields_condition       # "(spaceships.flags not in (2,3,6,7))"
Spaceship.electrolytes_condition      # "(spaceships.flags in (4,5,6,7))"
Spaceship.not_electrolytes_condition  # "(spaceships.flags not in (4,5,6,7))"
```

These methods also accept a `:table_alias` option that can be used when
generating SQL that references the same table more than once:
```ruby
Spaceship.shields_condition(:table_alias => 'evil_spaceships') # "(evil_spaceships.flags in (2,3,6,7))"
```


### Choosing a query mode

While the default way of building the SQL conditions uses an `IN()` list
(as shown above), this approach will not work well for a high number of flags,
as the value list for `IN()` grows.

For MySQL, depending on your MySQL settings, this can even hit the
`max_allowed_packet` limit with the generated query, or the similar query length maximum for PostgreSQL.

In this case, consider changing the flag query mode to `:bit_operator`
instead of `:in_list`, like so:

```ruby
has_flags 1 => :warpdrive,
          2 => :shields,
          :flag_query_mode => :bit_operator
```

This will modify the generated condition and named_scope methods to use bit
operators in the SQL instead of an `IN()` list:

```ruby
Spaceship.warpdrive_condition     # "(spaceships.flags & 1 = 1)",
Spaceship.not_warpdrive_condition # "(spaceships.flags & 1 = 0)",
Spaceship.shields_condition       # "(spaceships.flags & 2 = 2)",
Spaceship.not_shields_condition   # "(spaceships.flags & 2 = 0)",

Spaceship.warpdrive     # :conditions => "(spaceships.flags & 1 = 1)"
Spaceship.not_warpdrive # :conditions => "(spaceships.flags & 1 = 0)"
Spaceship.shields       # :conditions => "(spaceships.flags & 2 = 2)"
Spaceship.not_shields   # :conditions => "(spaceships.flags & 2 = 0)"
```

The drawback is that due to the [bitwise operation][bitwise_operation] being done on the SQL side,
this query can not use an index on the flags column.

### Updating flag column by raw sql

If you need to do mass updates without initializing object for each row, you can
use `#set_flag_sql` method on your class. Example:

```ruby
Spaceship.set_flag_sql(:warpdrive, true) # "flags = flags | 1"
Spaceship.set_flag_sql(:shields, false)  # "flags = flags & ~2"
```

And then use it in:

```ruby
Spaceship.update_all Spaceship.set_flag_sql(:shields, false)
```

Beware that using multiple flag manipulation sql statements in the same query
probably will not have the desired effect (at least on sqlite3, not tested
on other databases), so you *should not* do this:

```ruby
Spaceship.update_all "#{Spaceship.set_flag_sql(:shields, false)},#{
  Spaceship.set_flag_sql(:warpdrive, true)}"
```

General rule of thumb: issue only one flag update per update statement.

### Skipping flag column check

By default when you call has_flags in your code it will automatically check
your database to see if you have correct column defined.

Sometimes this may not be a wanted behaviour (e.g. when loading model without
database connection established) so you can set `:check_for_column` option to
false to avoid it.

```ruby
has_flags 1 => :warpdrive,
          2 => :shields,
          :check_for_column => false
```

### 2012 Change of Ownership and 0.3.X Release Notes

FlagShihTzu was originally a [XING AG](http://www.xing.com/) project.  [Peter Boling](http://peterboling.com) was a long time contributor and watcher of the project.
In September 2012 XING transferred ownership of the project to Peter Boling.  Peter Boling had been maintaining a
fork with extended capabilities.  These additional features become a part of the 0.3 line.  The 0.2 line of the gem will
remain true to XING's original.  The 0.3 line aims to maintain complete parity and compatibility with XING's original as
well.  I will continue to monitor other forks for original ideas and improvements. Pull requests are welcome, but please
rebase your work onto the current master to make integration easier.

More information on the changes for 0.3.X: [pboling/flag_shih_tzu/wiki/Changes-for-0.3.x](https://github.com/pboling/flag_shih_tzu/wiki/Changes-for-0.3.x)

### Alternatives

I discovered in October 2015 that Michael Grosser had created a competing tool, `bitfields`, way back in 2010, exactly a year after this tool was created.  It was a very surreal moment, as I had thought this was the only game in town and it was when I began using and hacking on it.  Once I got over that moment I became excited, because competition makes things better, right?  So, now I am looking forward to a shootout some lazy Saturday.  Until then there's this: http://www.railsbling.com/posts/why-use-flag_shih_tzu/

There is little that `bitfields` does better.  The code is [less efficient](https://github.com/grosser/bitfields/blob/master/lib/bitfields.rb#L186 "recalculating and throwing away much of the result in many places"), albeit more readable, not as well tested, has almost zero inline documentation, and simply can't do many of the things I've built into `flag_shih_tzu`.  If you are still on legacy Ruby or legacy Rails, or using jRuby, then use `flag_shih_tzu`. If you need multiple flag columns on a single model, use `flag_shih_tzu`.

Will there ever be a merb/rails-like love fest between the projects?  It would be interesting.  I like his name better.  I like my features better.  I like some of his code better, and some of my code better.  I've been wanting to do a full re-write of `flag_shih_tzu` ever since I inherited the project from [XING](https://github.com/xing), but I haven't had time.  So I don't know.

## 🦷 FLOSS Funding

While pboling tools are free software and will always be, the project would benefit immensely from some funding.
Raising a monthly budget of... "dollars" would make the project more sustainable.

We welcome both individual and corporate sponsors! We also offer a
wide array of funding channels to account for your preferences
(although currently [Open Collective][🖇osc] is our preferred funding platform).

**If you're working in a company that's making significant use of pboling tools we'd
appreciate it if you suggest to your company to become a pboling sponsor.**

You can support the development of pboling tools via
[GitHub Sponsors][🖇sponsor],
[Liberapay][⛳liberapay],
[PayPal][🖇paypal],
[Open Collective][🖇osc]
and [Tidelift][🏙️entsup-tidelift].

| 📍 NOTE                                                                                                                                                                                                              |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| If doing a sponsorship in the form of donation is problematic for your company <br/> from an accounting standpoint, we'd recommend the use of Tidelift, <br/> where you can get a support-like subscription instead. |

### Open Collective for Individuals

Support us with a monthly donation and help us continue our activities. [[Become a backer](https://opencollective.com/pboling#backer)]

NOTE: [kettle-readme-backers][kettle-readme-backers] updates this list every day, automatically.

<!-- OPENCOLLECTIVE-INDIVIDUALS:START -->
No backers yet. Be the first!
<!-- OPENCOLLECTIVE-INDIVIDUALS:END -->

### Open Collective for Organizations

Become a sponsor and get your logo on our README on GitHub with a link to your site. [[Become a sponsor](https://opencollective.com/pboling#sponsor)]

NOTE: [kettle-readme-backers][kettle-readme-backers] updates this list every day, automatically.

<!-- OPENCOLLECTIVE-ORGANIZATIONS:START -->
No sponsors yet. Be the first!
<!-- OPENCOLLECTIVE-ORGANIZATIONS:END -->

[kettle-readme-backers]: https://github.com/pboling/flag_shih_tzu/blob/main/exe/kettle-readme-backers

### Another way to support open-source

> How wonderful it is that nobody need wait a single moment before starting to improve the world.<br/>
>—Anne Frank

I’m driven by a passion to foster a thriving open-source community – a space where people can tackle complex problems, no matter how small.  Revitalizing libraries that have fallen into disrepair, and building new libraries focused on solving real-world challenges, are my passions — totaling 79 hours of FLOSS coding over just the past seven days, a pretty regular week for me.  I was recently affected by layoffs, and the tech jobs market is unwelcoming. I’m reaching out here because your support would significantly aid my efforts to provide for my family, and my farm (11 🐔 chickens, 2 🐶 dogs, 3 🐰 rabbits, 8 🐈‍ cats).

If you work at a company that uses my work, please encourage them to support me as a corporate sponsor. My work on gems you use might show up in `bundle fund`.

I’m developing a new library, [floss_funding][🖇floss-funding-gem], designed to empower open-source developers like myself to get paid for the work we do, in a sustainable way. Please give it a look.

**[Floss-Funding.dev][🖇floss-funding.dev]: 👉️ No network calls. 👉️ No tracking. 👉️ No oversight. 👉️ Minimal crypto hashing. 💡 Easily disabled nags**

[![OpenCollective Backers][🖇osc-backers-i]][🖇osc-backers] [![OpenCollective Sponsors][🖇osc-sponsors-i]][🖇osc-sponsors] [![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor] [![Liberapay Goal Progress][⛳liberapay-img]][⛳liberapay] [![Donate on PayPal][🖇paypal-img]][🖇paypal] [![Buy me a coffee][🖇buyme-small-img]][🖇buyme] [![Donate on Polar][🖇polar-img]][🖇polar] [![Donate to my FLOSS or refugee efforts at ko-fi.com][🖇kofi-img]][🖇kofi] [![Donate to my FLOSS or refugee efforts using Patreon][🖇patreon-img]][🖇patreon]

## 🔐 Security

See [SECURITY.md][🔐security].

## 🤝 Contributing

If you need some ideas of where to help, you could work on adding more code coverage,
or if it is already 💯 (see [below](#code-coverage)) check [reek](REEK), [issues][🤝gh-issues], or [PRs][🤝gh-pulls],
or use the gem and think about how it could be better.

We [![Keep A Changelog][📗keep-changelog-img]][📗keep-changelog] so if you make changes, remember to update it.

See [CONTRIBUTING.md][🤝contributing] for more detailed instructions.

### Running the gem tests

WARNING: You may want to read [bin/test.bash](https://github.com/pboling/flag_shih_tzu/blob/master/bin/test.bash) first.
Running the test script will switch rubies, create gemsets, install gems, and get a lil' crazy with the hips.

Just:

    $ rake test:all

This will internally use rvm and bundler to load specific Rubies and ActiveRecord versions
before executing the tests (see `gemfiles/`), e.g.:

    $ NOCOVER=true BUNDLE_GEMFILE='gemfiles/Gemfile.activerecord-4.1.x' bundle exec rake test

All tests will use an in-memory sqlite database by default.
If you want to use a different database, see `test/database.yml`,
install the required adapter gem and use the DB environment variable to
specify which config from `test/database.yml` to use, e.g.:

    $ NOCOVER=true DB=mysql bundle exec rake

You will also need to create, and configure access to, the test databases for any adapters you want to test, e.g. mysql:

    mysql> CREATE USER 'foss'@'localhost';
    Query OK, 0 rows affected (0.00 sec)
    
    mysql> GRANT ALL PRIVILEGES ON *.* TO 'foss'@'localhost';
    Query OK, 0 rows affected (0.00 sec)
    
    mysql> CREATE DATABASE flag_shih_tzu_test;
    Query OK, 1 row affected (0.00 sec)

### 🚀 Release Instructions

See [CONTRIBUTING.md][🤝contributing].

### Code Coverage

[![Coverage Graph][🏀codecov-g]][🏀codecov]

[![Coveralls Test Coverage][🏀coveralls-img]][🏀coveralls]

[![QLTY Test Coverage][🏀qlty-covi]][🏀qlty-cov]

### 🪇 Code of Conduct

Everyone interacting with this project's codebases, issue trackers,
chat rooms and mailing lists agrees to follow the [![Contributor Covenant 2.1][🪇conduct-img]][🪇conduct].

## 🌈 Contributors

[Peter Boling](http://github.com/pboling),
[Patryk Peszko](http://github.com/ppeszko),
[Sebastian Roebke](http://github.com/boosty),
[David Anderson](http://github.com/alpinegizmo),
[Tim Payton](http://github.com/dizzy42)
and a helpful group of
[contributors](https://github.com/pboling/flag_shih_tzu/contributors).
Thanks!

Find out more about Peter Boling's work
[RailsBling.com](http://railsbling.com/).

Find out more about XING
[Devblog](https://tech.new-work.se/).

[![Contributors][🖐contributors-img]][🖐contributors]

Made with [contributors-img][🖐contrib-rocks].

Also see GitLab Contributors: [https://gitlab.com/pboling/flag_shih_tzu/-/graphs/main][🚎contributors-gl]

<details>
    <summary>⭐️ Star History</summary>

<a href="https://star-history.com/#pboling/flag_shih_tzu&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=pboling/flag_shih_tzu&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=pboling/flag_shih_tzu&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=pboling/flag_shih_tzu&type=Date" />
 </picture>
</a>

</details>

## 📌 Versioning

This Library adheres to [![Semantic Versioning 2.0.0][📌semver-img]][📌semver].
Violations of this scheme should be reported as bugs.
Specifically, if a minor or patch version is released that breaks backward compatibility,
a new version should be immediately released that restores compatibility.
Breaking changes to the public API will only be introduced with new major versions.

> dropping support for a platform is both obviously and objectively a breaking change <br/>
>—Jordan Harband ([@ljharb](https://github.com/ljharb), maintainer of SemVer) [in SemVer issue 716][📌semver-breaking]

I understand that policy doesn't work universally ("exceptions to every rule!"),
but it is the policy here.
As such, in many cases it is good to specify a dependency on this library using
the [Pessimistic Version Constraint][📌pvc] with two digits of precision.

For example:

```ruby
spec.add_dependency("flag_shih_tzu", "~> 0.0")
```

<details>
<summary>📌 Is "Platform Support" part of the public API? More details inside.</summary>

SemVer should, IMO, but doesn't explicitly, say that dropping support for specific Platforms
is a *breaking change* to an API.
It is obvious to many, but not all, and since the spec is silent, the bike shedding is endless.

To get a better understanding of how SemVer is intended to work over a project's lifetime,
read this article from the creator of SemVer:

- ["Major Version Numbers are Not Sacred"][📌major-versions-not-sacred]

</details>

See [CHANGELOG.md][📌changelog] for a list of releases.

## 📄 License

The gem is available as open source under the terms of
the [MIT License][📄license] [![License: MIT][📄license-img]][📄license-ref].
See [LICENSE.txt][📄license] for the official [Copyright Notice][📄copyright-notice-explainer].

### © Copyright

<ul>
    <li>
        Copyright (c) 2012-2020, 2022-2023, 2025 Peter H. Boling, of
        <a href="https://discord.gg/3qme4XHNKN">
            Galtzo.com
            <picture>
              <img src="https://logos.galtzo.com/assets/images/galtzo-floss/avatar-128px-blank.svg" alt="Galtzo.com Logo (Wordless) by Aboling0, CC BY-SA 4.0" width="24">
            </picture>
        </a>, and flag_shih_tzu contributors.
    </li>
    <li>
        Copyright (c) 2011 [XING AG](http://www.xing.com/)
    </li>
</ul>

## 🤑 A request for help

Maintainers have teeth and need to pay their dentists.
After getting laid off in an RIF in March and filled with many dozens of rejections,
I'm now spending ~60+ hours a week building open source tools.
I'm hoping to be able to pay for my kids' health insurance this month,
so if you value the work I am doing, I need your support.
Please consider sponsoring me or the project.

To join the community or get help 👇️ Join the Discord.

[![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite]

To say "thanks!" ☝️ Join the Discord or 👇️ send money.

[![Sponsor pboling/flag_shih_tzu on Open Source Collective][🖇osc-all-bottom-img]][🖇osc] 💌 [![Sponsor me on GitHub Sponsors][🖇sponsor-bottom-img]][🖇sponsor] 💌 [![Sponsor me on Liberapay][⛳liberapay-bottom-img]][⛳liberapay-img] 💌 [![Donate on PayPal][🖇paypal-bottom-img]][🖇paypal-img]

### Please give the project a star ⭐ ♥.

Thanks for RTFM. ☺️

[⛳liberapay-img]: https://img.shields.io/liberapay/goal/pboling.svg?logo=liberapay&color=a51611&style=flat
[⛳liberapay-bottom-img]: https://img.shields.io/liberapay/goal/pboling.svg?style=for-the-badge&logo=liberapay&color=a51611
[⛳liberapay]: https://liberapay.com/pboling/donate
[🖇osc-all-img]: https://img.shields.io/opencollective/all/pboling
[🖇osc-sponsors-img]: https://img.shields.io/opencollective/sponsors/pboling
[🖇osc-backers-img]: https://img.shields.io/opencollective/backers/pboling
[🖇osc-backers]: https://opencollective.com/pboling#backer
[🖇osc-backers-i]: https://opencollective.com/pboling/backers/badge.svg?style=flat
[🖇osc-sponsors]: https://opencollective.com/pboling#sponsor
[🖇osc-sponsors-i]: https://opencollective.com/pboling/sponsors/badge.svg?style=flat
[🖇osc-all-bottom-img]: https://img.shields.io/opencollective/all/pboling?style=for-the-badge
[🖇osc-sponsors-bottom-img]: https://img.shields.io/opencollective/sponsors/pboling?style=for-the-badge
[🖇osc-backers-bottom-img]: https://img.shields.io/opencollective/backers/pboling?style=for-the-badge
[🖇osc]: https://opencollective.com/pboling
[🖇sponsor-img]: https://img.shields.io/badge/Sponsor_Me!-pboling.svg?style=social&logo=github
[🖇sponsor-bottom-img]: https://img.shields.io/badge/Sponsor_Me!-pboling-blue?style=for-the-badge&logo=github
[🖇sponsor]: https://github.com/sponsors/pboling
[🖇polar-img]: https://img.shields.io/badge/polar-donate-a51611.svg?style=flat
[🖇polar]: https://polar.sh/pboling
[🖇kofi-img]: https://img.shields.io/badge/ko--fi-%E2%9C%93-a51611.svg?style=flat
[🖇kofi]: https://ko-fi.com/O5O86SNP4
[🖇patreon-img]: https://img.shields.io/badge/patreon-donate-a51611.svg?style=flat
[🖇patreon]: https://patreon.com/galtzo
[🖇buyme-small-img]: https://img.shields.io/badge/buy_me_a_coffee-%E2%9C%93-a51611.svg?style=flat
[🖇buyme-img]: https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20latte&emoji=&slug=pboling&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff
[🖇buyme]: https://www.buymeacoffee.com/pboling
[🖇paypal-img]: https://img.shields.io/badge/donate-paypal-a51611.svg?style=flat&logo=paypal
[🖇paypal-bottom-img]: https://img.shields.io/badge/donate-paypal-a51611.svg?style=for-the-badge&logo=paypal&color=0A0A0A
[🖇paypal]: https://www.paypal.com/paypalme/peterboling
[🖇floss-funding.dev]: https://floss-funding.dev
[🖇floss-funding-gem]: https://github.com/galtzo-floss/floss_funding
[✉️discord-invite]: https://discord.gg/3qme4XHNKN
[✉️discord-invite-img-ftb]: https://img.shields.io/discord/1373797679469170758?style=for-the-badge&logo=discord
[✉️ruby-friends-img]: https://img.shields.io/badge/daily.dev-%F0%9F%92%8E_Ruby_Friends-0A0A0A?style=for-the-badge&logo=dailydotdev&logoColor=white
[✉️ruby-friends]: https://app.daily.dev/squads/rubyfriends

[✇bundle-group-pattern]: https://gist.github.com/pboling/4564780
[⛳️gem-namespace]: https://github.com/pboling/flag_shih_tzu
[⛳️namespace-img]: https://img.shields.io/badge/namespace-FlagShihTzu-3C2D2D.svg?style=square&logo=ruby&logoColor=white
[⛳️gem-name]: https://rubygems.org/gems/flag_shih_tzu
[⛳️name-img]: https://img.shields.io/badge/name-flag__shih__tzu-3C2D2D.svg?style=square&logo=rubygems&logoColor=red
[⛳️tag-img]: https://img.shields.io/github/tag/pboling/flag_shih_tzu.svg
[⛳️tag]: http://github.com/pboling/flag_shih_tzu/releases
[🚂maint-blog]: http://www.railsbling.com/tags/flag_shih_tzu
[🚂maint-blog-img]: https://img.shields.io/badge/blog-railsbling-0093D0.svg?style=for-the-badge&logo=rubyonrails&logoColor=orange
[🚂maint-contact]: http://www.railsbling.com/contact
[🚂maint-contact-img]: https://img.shields.io/badge/Contact-Maintainer-0093D0.svg?style=flat&logo=rubyonrails&logoColor=red
[💖🖇linkedin]: http://www.linkedin.com/in/peterboling
[💖🖇linkedin-img]: https://img.shields.io/badge/PeterBoling-LinkedIn-0B66C2?style=flat&logo=newjapanprowrestling
[💖✌️wellfound]: https://wellfound.com/u/peter-boling
[💖✌️wellfound-img]: https://img.shields.io/badge/peter--boling-orange?style=flat&logo=wellfound
[💖💲crunchbase]: https://www.crunchbase.com/person/peter-boling
[💖💲crunchbase-img]: https://img.shields.io/badge/peter--boling-purple?style=flat&logo=crunchbase
[💖🐘ruby-mast]: https://ruby.social/@galtzo
[💖🐘ruby-mast-img]: https://img.shields.io/mastodon/follow/109447111526622197?domain=https://ruby.social&style=flat&logo=mastodon&label=Ruby%20@galtzo
[💖🦋bluesky]: https://bsky.app/profile/galtzo.com
[💖🦋bluesky-img]: https://img.shields.io/badge/@galtzo.com-0285FF?style=flat&logo=bluesky&logoColor=white
[💖🌳linktree]: https://linktr.ee/galtzo
[💖🌳linktree-img]: https://img.shields.io/badge/galtzo-purple?style=flat&logo=linktree
[💖💁🏼‍♂️devto]: https://dev.to/galtzo
[💖💁🏼‍♂️devto-img]: https://img.shields.io/badge/dev.to-0A0A0A?style=flat&logo=devdotto&logoColor=white
[💖💁🏼‍♂️aboutme]: https://about.me/peter.boling
[💖💁🏼‍♂️aboutme-img]: https://img.shields.io/badge/about.me-0A0A0A?style=flat&logo=aboutme&logoColor=white
[💖🧊berg]: https://codeberg.org/pboling
[💖🐙hub]: https://github.org/pboling
[💖🛖hut]: https://sr.ht/~galtzo/
[💖🧪lab]: https://gitlab.com/pboling
[👨🏼‍🏫expsup-upwork]: https://www.upwork.com/freelancers/~014942e9b056abdf86?mp_source=share
[👨🏼‍🏫expsup-upwork-img]: https://img.shields.io/badge/UpWork-13544E?style=for-the-badge&logo=Upwork&logoColor=white
[👨🏼‍🏫expsup-codementor]: https://www.codementor.io/peterboling?utm_source=github&utm_medium=button&utm_term=peterboling&utm_campaign=github
[👨🏼‍🏫expsup-codementor-img]: https://img.shields.io/badge/CodeMentor-Get_Help-1abc9c?style=for-the-badge&logo=CodeMentor&logoColor=white
[🏙️entsup-tidelift]: https://tidelift.com/subscription/pkg/rubygems-flag_shih_tzu?utm_source=rubygems-flag_shih_tzu&utm_medium=referral&utm_campaign=readme
[🏙️entsup-tidelift-img]: https://img.shields.io/badge/Tidelift_and_Sonar-Enterprise_Support-FD3456?style=for-the-badge&logo=sonar&logoColor=white
[🏙️entsup-tidelift-sonar]: https://blog.tidelift.com/tidelift-joins-sonar
[💁🏼‍♂️peterboling]: http://www.peterboling.com
[🚂railsbling]: http://www.railsbling.com
[📜src-gl-img]: https://img.shields.io/badge/GitLab-FBA326?style=for-the-badge&logo=Gitlab&logoColor=orange
[📜src-gl]: https://gitlab.com/pboling/flag_shih_tzu/
[📜src-cb-img]: https://img.shields.io/badge/CodeBerg-4893CC?style=for-the-badge&logo=CodeBerg&logoColor=blue
[📜src-cb]: https://codeberg.org/pboling/flag_shih_tzu
[📜src-gh-img]: https://img.shields.io/badge/GitHub-238636?style=for-the-badge&logo=Github&logoColor=green
[📜src-gh]: https://github.com/pboling/flag_shih_tzu
[📜docs-cr-rd-img]: https://img.shields.io/badge/RubyDoc-Current_Release-943CD2?style=for-the-badge&logo=readthedocs&logoColor=white
[📜docs-head-rd-img]: https://img.shields.io/badge/YARD_on_Galtzo.com-HEAD-943CD2?style=for-the-badge&logo=readthedocs&logoColor=white
[📜gl-wiki]: https://gitlab.com/pboling/flag_shih_tzu/-/wikis/home
[📜gh-wiki]: https://github.com/pboling/flag_shih_tzu/wiki
[📜gl-wiki-img]: https://img.shields.io/badge/wiki-examples-943CD2.svg?style=for-the-badge&logo=gitlab&logoColor=white
[📜gh-wiki-img]: https://img.shields.io/badge/wiki-examples-943CD2.svg?style=for-the-badge&logo=github&logoColor=white
[👽dl-rank]: https://rubygems.org/gems/flag_shih_tzu
[👽dl-ranki]: https://img.shields.io/gem/rd/flag_shih_tzu.svg
[👽oss-help]: https://www.codetriage.com/pboling/flag_shih_tzu
[👽oss-helpi]: https://www.codetriage.com/pboling/flag_shih_tzu/badges/users.svg
[👽version]: https://rubygems.org/gems/flag_shih_tzu
[👽versioni]: https://img.shields.io/gem/v/flag_shih_tzu.svg
[🏀qlty-mnt]: https://qlty.sh/gh/pboling/projects/flag_shih_tzu
[🏀qlty-mnti]: https://qlty.sh/gh/pboling/projects/flag_shih_tzu/maintainability.svg
[🏀qlty-cov]: https://qlty.sh/gh/pboling/projects/flag_shih_tzu/metrics/code?sort=coverageRating
[🏀qlty-covi]: https://qlty.sh/gh/pboling/projects/flag_shih_tzu/coverage.svg
[🏀codecov]: https://codecov.io/gh/pboling/flag_shih_tzu
[🏀codecovi]: https://codecov.io/gh/pboling/flag_shih_tzu/graph/badge.svg
[🏀coveralls]: https://coveralls.io/github/pboling/flag_shih_tzu?branch=main
[🏀coveralls-img]: https://coveralls.io/repos/github/pboling/flag_shih_tzu/badge.svg?branch=main
[🖐codeQL]: https://github.com/pboling/flag_shih_tzu/security/code-scanning
[🖐codeQL-img]: https://github.com/pboling/flag_shih_tzu/actions/workflows/codeql-analysis.yml/badge.svg
[🚎1-an-wf]: https://github.com/pboling/flag_shih_tzu/actions/workflows/ancient.yml
[🚎1-an-wfi]: https://github.com/pboling/flag_shih_tzu/actions/workflows/ancient.yml/badge.svg
[🚎2-cov-wf]: https://github.com/pboling/flag_shih_tzu/actions/workflows/coverage.yml
[🚎2-cov-wfi]: https://github.com/pboling/flag_shih_tzu/actions/workflows/coverage.yml/badge.svg
[🚎3-hd-wf]: https://github.com/pboling/flag_shih_tzu/actions/workflows/heads.yml
[🚎3-hd-wfi]: https://github.com/pboling/flag_shih_tzu/actions/workflows/heads.yml/badge.svg
[🚎4-lg-wf]: https://github.com/pboling/flag_shih_tzu/actions/workflows/legacy.yml
[🚎4-lg-wfi]: https://github.com/pboling/flag_shih_tzu/actions/workflows/legacy.yml/badge.svg
[🚎5-st-wf]: https://github.com/pboling/flag_shih_tzu/actions/workflows/style.yml
[🚎5-st-wfi]: https://github.com/pboling/flag_shih_tzu/actions/workflows/style.yml/badge.svg
[🚎6-s-wf]: https://github.com/pboling/flag_shih_tzu/actions/workflows/supported.yml
[🚎6-s-wfi]: https://github.com/pboling/flag_shih_tzu/actions/workflows/supported.yml/badge.svg
[🚎7-us-wf]: https://github.com/pboling/flag_shih_tzu/actions/workflows/unsupported.yml
[🚎7-us-wfi]: https://github.com/pboling/flag_shih_tzu/actions/workflows/unsupported.yml/badge.svg
[🚎8-ho-wf]: https://github.com/pboling/flag_shih_tzu/actions/workflows/hoary.yml
[🚎8-ho-wfi]: https://github.com/pboling/flag_shih_tzu/actions/workflows/hoary.yml/badge.svg
[🚎9-t-wf]: https://github.com/pboling/flag_shih_tzu/actions/workflows/truffle.yml
[🚎9-t-wfi]: https://github.com/pboling/flag_shih_tzu/actions/workflows/truffle.yml/badge.svg
[🚎10-j-wf]: https://github.com/pboling/flag_shih_tzu/actions/workflows/jruby.yml
[🚎10-j-wfi]: https://github.com/pboling/flag_shih_tzu/actions/workflows/jruby.yml/badge.svg
[🚎11-c-wf]: https://github.com/pboling/flag_shih_tzu/actions/workflows/current.yml
[🚎11-c-wfi]: https://github.com/pboling/flag_shih_tzu/actions/workflows/current.yml/badge.svg
[🚎12-crh-wf]: https://github.com/pboling/flag_shih_tzu/actions/workflows/dep-heads.yml
[🚎12-crh-wfi]: https://github.com/pboling/flag_shih_tzu/actions/workflows/dep-heads.yml/badge.svg
[🚎13-🔒️-wf]: https://github.com/pboling/flag_shih_tzu/actions/workflows/locked_deps.yml
[🚎13-🔒️-wfi]: https://github.com/pboling/flag_shih_tzu/actions/workflows/locked_deps.yml/badge.svg
[🚎14-🔓️-wf]: https://github.com/pboling/flag_shih_tzu/actions/workflows/unlocked_deps.yml
[🚎14-🔓️-wfi]: https://github.com/pboling/flag_shih_tzu/actions/workflows/unlocked_deps.yml/badge.svg
[🚎15-🪪-wf]: https://github.com/pboling/flag_shih_tzu/actions/workflows/license-eye.yml
[🚎15-🪪-wfi]: https://github.com/pboling/flag_shih_tzu/actions/workflows/license-eye.yml/badge.svg
[💎ruby-2.0i]: https://img.shields.io/badge/Ruby-2.0_(%F0%9F%9A%ABCI)-AABBCC?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.1i]: https://img.shields.io/badge/Ruby-2.1_(%F0%9F%9A%ABCI)-AABBCC?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.2i]: https://img.shields.io/badge/Ruby-2.2_(%F0%9F%9A%ABCI)-AABBCC?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.3i]: https://img.shields.io/badge/Ruby-2.3-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.4i]: https://img.shields.io/badge/Ruby-2.4-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.5i]: https://img.shields.io/badge/Ruby-2.5-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.6i]: https://img.shields.io/badge/Ruby-2.6-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.7i]: https://img.shields.io/badge/Ruby-2.7-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.0i]: https://img.shields.io/badge/Ruby-3.0-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.1i]: https://img.shields.io/badge/Ruby-3.1-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.2i]: https://img.shields.io/badge/Ruby-3.2-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.3i]: https://img.shields.io/badge/Ruby-3.3-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-c-i]: https://img.shields.io/badge/Ruby-current-CC342D?style=for-the-badge&logo=ruby&logoColor=green
[💎ruby-headi]: https://img.shields.io/badge/Ruby-HEAD-CC342D?style=for-the-badge&logo=ruby&logoColor=blue
[💎truby-22.3i]: https://img.shields.io/badge/Truffle_Ruby-22.3_(%F0%9F%9A%ABCI)-AABBCC?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-23.0i]: https://img.shields.io/badge/Truffle_Ruby-23.0_(%F0%9F%9A%ABCI)-AABBCC?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-23.1i]: https://img.shields.io/badge/Truffle_Ruby-23.1-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-c-i]: https://img.shields.io/badge/Truffle_Ruby-current-34BCB1?style=for-the-badge&logo=ruby&logoColor=green
[💎truby-headi]: https://img.shields.io/badge/Truffle_Ruby-HEAD-34BCB1?style=for-the-badge&logo=ruby&logoColor=blue
[💎jruby-9.1i]: https://img.shields.io/badge/JRuby-9.1_(%F0%9F%9A%ABCI)-AABBCC?style=for-the-badge&logo=ruby&logoColor=red
[💎jruby-9.2i]: https://img.shields.io/badge/JRuby-9.2_(%F0%9F%9A%ABCI)-AABBCC?style=for-the-badge&logo=ruby&logoColor=red
[💎jruby-9.3i]: https://img.shields.io/badge/JRuby-9.3_(%F0%9F%9A%ABCI)-AABBCC?style=for-the-badge&logo=ruby&logoColor=red
[💎jruby-9.4i]: https://img.shields.io/badge/JRuby-9.4-FBE742?style=for-the-badge&logo=ruby&logoColor=red
[💎jruby-c-i]: https://img.shields.io/badge/JRuby-current-FBE742?style=for-the-badge&logo=ruby&logoColor=green
[💎jruby-headi]: https://img.shields.io/badge/JRuby-HEAD-FBE742?style=for-the-badge&logo=ruby&logoColor=blue
[🤝gh-issues]: https://github.com/pboling/flag_shih_tzu/issues
[🤝gh-pulls]: https://github.com/pboling/flag_shih_tzu/pulls
[🤝gl-issues]: https://gitlab.com/pboling/flag_shih_tzu/-/issues
[🤝gl-pulls]: https://gitlab.com/pboling/flag_shih_tzu/-/merge_requests
[🤝cb-issues]: https://codeberg.org/pboling/flag_shih_tzu/issues
[🤝cb-pulls]: https://codeberg.org/pboling/flag_shih_tzu/pulls
[🤝cb-donate]: https://donate.codeberg.org/
[🤝contributing]: CONTRIBUTING.md
[🏀codecov-g]: https://codecov.io/gh/pboling/flag_shih_tzu/graphs/tree.svg
[🖐contrib-rocks]: https://contrib.rocks
[🖐contributors]: https://github.com/pboling/flag_shih_tzu/graphs/contributors
[🖐contributors-img]: https://contrib.rocks/image?repo=pboling/flag_shih_tzu
[🚎contributors-gl]: https://gitlab.com/pboling/flag_shih_tzu/-/graphs/main
[🪇conduct]: CODE_OF_CONDUCT.md
[🪇conduct-img]: https://img.shields.io/badge/Contributor_Covenant-2.1-259D6C.svg
[📌pvc]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint
[📌semver]: https://semver.org/spec/v2.0.0.html
[📌semver-img]: https://img.shields.io/badge/semver-2.0.0-259D6C.svg?style=flat
[📌semver-breaking]: https://github.com/semver/semver/issues/716#issuecomment-869336139
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html
[📌changelog]: CHANGELOG.md
[📗keep-changelog]: https://keepachangelog.com/en/1.0.0/
[📗keep-changelog-img]: https://img.shields.io/badge/keep--a--changelog-1.0.0-34495e.svg?style=flat
[📌gitmoji]:https://gitmoji.dev
[📌gitmoji-img]:https://img.shields.io/badge/gitmoji_commits-%20%F0%9F%98%9C%20%F0%9F%98%8D-34495e.svg?style=flat-square
[🧮kloc]: https://www.youtube.com/watch?v=dQw4w9WgXcQ
[🧮kloc-img]: https://img.shields.io/badge/KLOC-4.076-FFDD67.svg?style=for-the-badge&logo=YouTube&logoColor=blue
[🔐security]: SECURITY.md
[🔐security-img]: https://img.shields.io/badge/security-policy-259D6C.svg?style=flat
[📄copyright-notice-explainer]: https://opensource.stackexchange.com/questions/5778/why-do-licenses-such-as-the-mit-license-specify-a-single-year
[📄license]: LICENSE.txt
[📄license-ref]: https://opensource.org/licenses/MIT
[📄license-img]: https://img.shields.io/badge/License-MIT-259D6C.svg
[📄license-compat]: https://dev.to/galtzo/how-to-check-license-compatibility-41h0
[📄license-compat-img]: https://img.shields.io/badge/Apache_Compatible:_Category_A-%E2%9C%93-259D6C.svg?style=flat&logo=Apache
[📄ilo-declaration]: https://www.ilo.org/declaration/lang--en/index.htm
[📄ilo-declaration-img]: https://img.shields.io/badge/ILO_Fundamental_Principles-✓-259D6C.svg?style=flat
[🚎yard-current]: http://rubydoc.info/gems/flag_shih_tzu
[🚎yard-head]: https://flag-shih-tzu.galtzo.com
[💎stone_checksums]: https://github.com/galtzo-floss/stone_checksums
[💎SHA_checksums]: https://gitlab.com/pboling/flag_shih_tzu/-/tree/main/checksums
[💎rlts]: https://github.com/rubocop-lts/rubocop-lts
[💎rlts-img]: https://img.shields.io/badge/code_style_&_linting-rubocop--lts-34495e.svg?plastic&logo=ruby&logoColor=white
[💎appraisal2]: https://github.com/appraisal-rb/appraisal2
[💎appraisal2-img]: https://img.shields.io/badge/appraised_by-appraisal2-34495e.svg?plastic&logo=ruby&logoColor=white
[💎d-in-dvcs]: https://railsbling.com/posts/dvcs/put_the_d_in_dvcs/
