<a href="https://github.com/galtzo-floss/flag_shih_tzu"><img alt="flag_shih_tzu Logo by Aboling0, CC BY-SA 4.0" src="https://logos.galtzo.com/assets/images/galtzo-floss/flag_shih_tzu/avatar-128px.svg" width="14%" align="right"/></a>

# 🏁 FlagShihTzu

## ⚠️ v1.0.0 => breaking change in default config ⚠️

Want old behavior?

```ruby
FlagShihTzu.default_flag_query_mode = :in_list
```

✨️ The *old behavior* is *not deprecated*, is still *more performant*, and will always *be supported*.

🦺 The new default allows *safe-by-default* rolling deployments with *flag migrations*.

📗 Read more here: https://dev.to/galtzo/why-flagshihtzu-is-changing-its-default-sql-for-bit-flags-41l9

[![Version][👽versioni]][👽version] [![GitHub tag (latest SemVer)][⛳️tag-img]][⛳️tag] [![License: MIT][📄license-img]][📄license] [![Downloads Rank][👽dl-ranki]][👽dl-rank] [![CodeCov Test Coverage][🏀codecovi]][🏀codecov] [![Coveralls Test Coverage][🏀coveralls-img]][🏀coveralls] [![QLTY Test Coverage][🏀qlty-covi]][🏀qlty-cov] [![QLTY Maintainability][🏀qlty-mnti]][🏀qlty-mnt] [![CI Heads][🚎3-hd-wfi]][🚎3-hd-wf] [![CI Runtime Dependencies @ HEAD][🚎12-crh-wfi]][🚎12-crh-wf] [![CI Current][🚎11-c-wfi]][🚎11-c-wf] [![CI Truffle Ruby][🚎9-t-wfi]][🚎9-t-wf] [![CI JRuby][🚎10-j-wfi]][🚎10-j-wf] [![Deps Locked][🚎13-🔒️-wfi]][🚎13-🔒️-wf] [![Deps Unlocked][🚎14-🔓️-wfi]][🚎14-🔓️-wf] [![CI Test Coverage][🚎2-cov-wfi]][🚎2-cov-wf] [![CI Style][🚎5-st-wfi]][🚎5-st-wf] [![Apache SkyWalking Eyes License Compatibility Check][🚎15-🪪-wfi]][🚎15-🪪-wf] [![FOSSA Status][🧪fossa-img]][🧪fossa]

`if ci_badges.map(&:color).detect { it != "green"}` ☝️ [let me know][🖼️galtzo-floss], as I may have missed the [discord notification][🖼️galtzo-floss].

---

`if ci_badges.map(&:color).all? { it == "green"}` 👇️ send money so I can do more of this. FLOSS maintenance is now my full-time job.

[![OpenCollective Backers][🖇osc-backers-i]][🖇osc-backers] [![OpenCollective Sponsors][🖇osc-sponsors-i]][🖇osc-sponsors] [![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor] [![Liberapay Goal Progress][⛳liberapay-img]][⛳liberapay] [![Donate on PayPal][🖇paypal-img]][🖇paypal] [![Buy me a coffee][🖇buyme-small-img]][🖇buyme] [![Donate on Polar][🖇polar-img]][🖇polar] [![Donate at ko-fi.com][🖇kofi-img]][🖇kofi]

<details>
 <summary>👣 How will this project approach the September 2025 hostile takeover of RubyGems? 🚑️</summary>

I've summarized my thoughts in [this blog post](https://dev.to/galtzo/hostile-takeover-of-rubygems-my-thoughts-5hlo).

</details>

## 🌻 Synopsis <a href="https://discord.gg/3qme4XHNKN"><img alt="Galtzo FLOSS Logo by Aboling0, CC BY-SA 4.0" src="https://logos.galtzo.com/assets/images/galtzo-floss/avatar-128px.svg" width="8%" align="right"/></a> <a href="https://ruby-toolbox.com"><img alt="ruby-lang Logo, Yukihiro Matsumoto, Ruby Visual Identity Team, CC BY-SA 2.5" src="https://logos.galtzo.com/assets/images/ruby-lang/avatar-128px.svg" width="8%" align="right"/></a>

An extension for [ActiveRecord](https://rubygems.org/gems/activerecord)
to store a collection of boolean attributes in a single integer column
as a [bit field][bit_field].

This gem lets you use a single integer column in an ActiveRecord model
to store a collection of boolean attributes (flags). Each flag can be used
almost in the same way you would use any boolean attribute on an
ActiveRecord object.

New for v1.0: FlagShihTzu also supports multi-bit fields with
`value_mode: :tri_state`, `bit_width:`, and custom `encoder:` implementations.
That lets one flag slot represent `true`, `false`, and `nil`, or other
enum-like states you encode, while still sharing the same integer column.

The benefits:

* No schema migrations needed for new boolean attributes. This helps a lot
  if you have very large db-tables, on which you want to avoid `ALTER TABLE`
  whenever possible. Data migrations that set newly added flags still need
  deploy-safe query behavior, described below.
* Only the one integer column needs to be indexed.
* [Bitwise Operations][bitwise_operation] are fast!

Using FlagShihTzu, you can add new boolean attributes whenever you want,
without needing any migration. Just add a new flag to the `has_flags` call.

What is a ["Shih Tzu"](http://en.wikipedia.org/wiki/Shih_Tzu)?

## 💡 Info you can shake a stick at

| Tokens to Remember | [![Gem name][⛳️name-img]][⛳️gem-name] [![Gem namespace][⛳️namespace-img]][⛳️gem-namespace] |
|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Works with JRuby | [![JRuby 9.2 Compat][💎jruby-9.2i]][🚎jruby-9.2-wf] [![JRuby 9.3 Compat][💎jruby-9.3i]][🚎jruby-9.3-wf] <br/> [![JRuby 9.4 Compat][💎jruby-9.4i]][🚎jruby-9.4-wf] [![JRuby current Compat][💎jruby-c-i]][🚎10-j-wf] [![JRuby HEAD Compat][💎jruby-headi]][🚎3-hd-wf]|
| Works with Truffle Ruby | [![Truffle Ruby 22.3 Compat][💎truby-22.3i]][🚎truby-22.3-wf] [![Truffle Ruby 23.0 Compat][💎truby-23.0i]][🚎truby-23.0-wf] [![Truffle Ruby 23.1 Compat][💎truby-23.1i]][🚎truby-23.1-wf] <br/> [![Truffle Ruby 24.2 Compat][💎truby-24.2i]][🚎truby-24.2-wf] [![Truffle Ruby 25.0 Compat][💎truby-25.0i]][🚎truby-25.0-wf] [![Truffle Ruby current Compat][💎truby-c-i]][🚎9-t-wf]|
| Works with MRI Ruby 4 | [![Ruby 4.0 Compat][💎ruby-4.0i]][🚎11-c-wf] [![Ruby current Compat][💎ruby-c-i]][🚎11-c-wf] [![Ruby HEAD Compat][💎ruby-headi]][🚎3-hd-wf]|
| Works with MRI Ruby 3 | [![Ruby 3.0 Compat][💎ruby-3.0i]][🚎ruby-3.0-wf] [![Ruby 3.1 Compat][💎ruby-3.1i]][🚎ruby-3.1-wf] [![Ruby 3.2 Compat][💎ruby-3.2i]][🚎ruby-3.2-wf] [![Ruby 3.3 Compat][💎ruby-3.3i]][🚎ruby-3.3-wf] [![Ruby 3.4 Compat][💎ruby-3.4i]][🚎ruby-3.4-wf]|
| Works with MRI Ruby 2 | [![Ruby 2.4 Compat][💎ruby-2.4i]][🚎ruby-2.4-wf] [![Ruby 2.5 Compat][💎ruby-2.5i]][🚎ruby-2.5-wf] [![Ruby 2.6 Compat][💎ruby-2.6i]][🚎ruby-2.6-wf] [![Ruby 2.7 Compat][💎ruby-2.7i]][🚎ruby-2.7-wf]|
| Support & Community | [![Join Me on Daily.dev's RubyFriends][✉️ruby-friends-img]][✉️ruby-friends] [![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite] [![Get help from me on Upwork][👨🏼‍🏫expsup-upwork-img]][👨🏼‍🏫expsup-upwork] [![Get help from me on Codementor][👨🏼‍🏫expsup-codementor-img]][👨🏼‍🏫expsup-codementor] |
| Source | [![Source on GitLab.com][📜src-gl-img]][📜src-gl] [![Source on CodeBerg.org][📜src-cb-img]][📜src-cb] [![Source on Github.com][📜src-gh-img]][📜src-gh] [![The best SHA: dQw4w9WgXcQ!][🧮kloc-img]][🧮kloc] |
| Documentation | [![Current release on RubyDoc.info][📜docs-cr-rd-img]][🚎yard-current] [![YARD on Galtzo.com][📜docs-head-rd-img]][🚎yard-head] [![Maintainer Blog][🚂maint-blog-img]][🚂maint-blog] [![GitLab Wiki][📜gl-wiki-img]][📜gl-wiki] [![GitHub Wiki][📜gh-wiki-img]][📜gh-wiki] |
| Compliance | [![License: MIT][📄license-img]][📄license] [![Apache license compatibility: Category A][📄license-compat-img]][📄license-compat] [![📄ilo-declaration-img]][📄ilo-declaration] [![Security Policy][🔐security-img]][🔐security] [![Contributor Covenant 2.1][🪇conduct-img]][🪇conduct] [![SemVer 2.0.0][📌semver-img]][📌semver] |
| Style | [![Enforced Code Style Linter][💎rlts-img]][💎rlts] [![Keep-A-Changelog 1.0.0][📗keep-changelog-img]][📗keep-changelog] [![Gitmoji Commits][📌gitmoji-img]][📌gitmoji] [![Compatibility appraised by: appraisal2][💎appraisal2-img]][💎appraisal2] |
| Maintainer 🎖️ | [![Follow Me on LinkedIn][💖🖇linkedin-img]][💖🖇linkedin] [![Follow Me on Ruby.Social][💖🐘ruby-mast-img]][💖🐘ruby-mast] [![Follow Me on Bluesky][💖🦋bluesky-img]][💖🦋bluesky] [![Contact Maintainer][🚂maint-contact-img]][🚂maint-contact] [![My technical writing][💖💁🏼‍♂️devto-img]][💖💁🏼‍♂️devto] |
| `...` 💖 | [![Find Me on WellFound:][💖✌️wellfound-img]][💖✌️wellfound] [![Find Me on CrunchBase][💖💲crunchbase-img]][💖💲crunchbase] [![My LinkTree][💖🌳linktree-img]][💖🌳linktree] [![More About Me][💖💁🏼‍♂️aboutme-img]][💖💁🏼‍♂️aboutme] [🧊][💖🧊berg] [🐙][💖🐙hub] [🛖][💖🛖hut] [🧪][💖🧪lab] |

### Compatibility

Compatible with MRI Ruby 2.4+, and concordant releases of JRuby, and TruffleRuby.
CI workflows and Appraisals are generated for MRI Ruby 2.4+.
This test floor is configured by `ruby.test_minimum` in `.kettle-jem.yml` and
may be higher than the gem's runtime compatibility floor when legacy Rubies are
not practical for the current toolchain.

| 🚚 _Amazing_ test matrix was brought to you by | 🔎 appraisal2 🔎 and the color 💚 green 💚 |
|------------------------------------------------|--------------------------------------------------------|
| 👟 Check it out! | ✨ [github.com/appraisal-rb/appraisal2][💎appraisal2] ✨ |

### Federated DVCS

<details markdown="1">
 <summary>Find this repo on federated forges (Coming soon!)</summary>

| Federated [DVCS][💎d-in-dvcs] Repository | Status | Issues | PRs | Wiki | CI | Discussions |
|-------------------------------------------------|-----------------------------------------------------------------------|---------------------------|--------------------------|---------------------------|--------------------------|------------------------------|
| 🧪 [galtzo-floss/flag_shih_tzu on GitLab][📜src-gl] | The Truth | [💚][🤝gl-issues] | [💚][🤝gl-pulls] | [💚][📜gl-wiki] | 🐭 Tiny Matrix | ➖ |
| 🧊 [galtzo-floss/flag_shih_tzu on CodeBerg][📜src-cb] | An Ethical Mirror ([Donate][🤝cb-donate]) | [💚][🤝cb-issues] | [💚][🤝cb-pulls] | ➖ | ⭕️ No Matrix | ➖ |
| 🐙 [galtzo-floss/flag_shih_tzu on GitHub][📜src-gh] | Another Mirror | [💚][🤝gh-issues] | [💚][🤝gh-pulls] | [💚][📜gh-wiki] | 💯 Full Matrix | [💚][gh-discussions] |
| 🎮️ [Discord Server][✉️discord-invite] | [![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite] | [Let's][✉️discord-invite] | [talk][✉️discord-invite] | [about][✉️discord-invite] | [this][✉️discord-invite] | [library!][✉️discord-invite] |

</details>

[gh-discussions]: https://github.com/galtzo-floss/flag_shih_tzu/discussions

### Enterprise Support [![Tidelift](https://tidelift.com/badges/package/rubygems/flag_shih_tzu)](https://tidelift.com/subscription/pkg/rubygems-flag_shih_tzu?utm_source=rubygems-flag_shih_tzu&utm_medium=referral&utm_campaign=readme)

Available as part of the Tidelift Subscription.

<details markdown="1">
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

## ⚙️ Configuration

## 🔧 Basic Usage

FlagShihTzu assumes that your ActiveRecord model already has an [integer field][bit_field]
to store the flags, which should be defined to not allow `NULL` values and
should have a default value of `0`.

### Defaults (Important)

* Due to the default of `0`, *all flags* are initially set to "false").
* For a default of true it will probably be easier in the long run to negate the flag's meaning / name.
** Such as `switched_on` => `switched_off`
* If you **really** want a different, non-zero, default value for a flag column, proceed *adroitly* with a different sql default for the flag column.

### Database Migration

I like to document the intent of the `flags` column in the migration when I can...

```ruby
change_table :spaceships do |t|
  t.integer(:flags, null: false, default: 0) # flag_shih_tzu-managed bit field
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

If a flag name conflicts with an existing instance method, `has_flags` raises
an error by default. To intentionally replace the existing method with
FlagShihTzu's generated flag methods, pass `:allow_overwrite => true`:

```ruby
has_flags 1 => :warpdrive,
  :allow_overwrite => true
```

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

### Flag value modes and custom encoders

By default, each flag uses boolean mode. This keeps the historical one-bit
storage format unchanged:

```ruby
has_flags 1 => :warpdrive,
  2 => :shields
```

This is equivalent to:

```ruby
has_flags(
  {1 => :warpdrive, 2 => :shields},
  value_mode: :boolean,
)
```

For flags that need `true`, `false`, and `nil`, use tri-state mode:

```ruby
has_flags(
  {1 => :warpdrive, 2 => :shields},
  value_mode: :tri_state,
)
```

With `value_mode: :tri_state`, each flag is encoded in its own two-bit slot. A
flag can be enabled, disabled, or cleared to `nil`:

```ruby
enterprise.warpdrive = true
enterprise.shields = nil

enterprise.warpdrive      # true
enterprise.shields        # nil
enterprise.shields_nil?   # true
```

Generated SQL helpers also understand the nil state:

```ruby
Spaceship.warpdrive_condition      # flags & 3 = 1
Spaceship.not_warpdrive_condition  # flags & 3 = 0
Spaceship.warpdrive_nil_condition  # flags & 3 = 3
Spaceship.clear_warpdrive_sql      # clears the two-bit slot to nil
```

Changing an existing flag column from one-bit boolean storage to two-bit
tri-state storage changes the meaning of stored integers. Treat that as a data
migration, not a model-only change.

Applications with specialized storage needs can provide a custom encoder:

```ruby
has_flags(
  {1 => :warpdrive},
  bit_width: 2,
  encoder: MyFlagEncoder,
)
```

The built-in value modes cover boolean one-bit storage and tri-state two-bit
storage. You can still pass `bit_width: 1` or `bit_width: 2` directly, but
`value_mode: :boolean` and `value_mode: :tri_state` are the preferred public
API. If you set `bit_width: 3` or higher, you must provide an encoder so
FlagShihTzu does not guess what the extra states mean.

### Using a custom column name

The default column name to store the flags is `flags`, but you can provide a
custom column name using the `:column` option. This allows you to use
different columns for separate flags:

```ruby
has_flags 1 => :warpdrive,
  2 => :shields,
  3 => :electrolytes,
  :column => "features"

has_flags 1 => :spock,
  2 => :scott,
  3 => :kirk,
  :column => "crew"
```

### Generated boolean patterned instance methods

Calling `has_flags`, as shown above on the 'features' column, creates the following instance methods
on Spaceship:

    Spaceship#all_features # [:warpdrive, :shields, :electrolytes]
    Spaceship#selected_features
    Spaceship#select_all_features
    Spaceship#unselect_all_features
    Spaceship#selected_features=
    Spaceship#features_as_attributes

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
Spaceship.warpdrive         # :conditions => "(spaceships.flags & 1 = 1)"
Spaceship.not_warpdrive     # :conditions => "(spaceships.flags & 1 = 0)"
Spaceship.shields           # :conditions => "(spaceships.flags & 2 = 2)"
Spaceship.not_shields       # :conditions => "(spaceships.flags & 2 = 0)"
Spaceship.electrolytes      # :conditions => "(spaceships.flags & 4 = 4)"
Spaceship.not_electrolytes  # :conditions => "(spaceships.flags & 4 = 0)"
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

### Setting multiple flags through the column

The flag column writer accepts raw integer values, arrays, and hashes. Raw
integers are still written directly:

```ruby
enterprise.flags = 5
```

Assigning an array sets the column to exactly that selected set of flags:

```ruby
enterprise.update!(flags: [:warpdrive, :electrolytes])
```

Unmentioned flags are disabled. You can also include `:not_<flag>` tokens:

```ruby
enterprise.flags = [:warpdrive, :not_shields]
```

Assigning a hash updates only the mentioned flags and preserves the rest:

```ruby
enterprise.flags = {
  warpdrive: true,
  shields: false,
}
```

Custom flag columns support the same forms through their column writer:

```ruby
enterprise.features = [:warpdrive]
enterprise.crew = {spock: true, kirk: false}
```

### Reading flags as attributes

Flag values can be read as a hash of boolean attributes:

```ruby
enterprise.warpdrive = true
enterprise.shields = false

enterprise.flags_as_attributes
# {:warpdrive => true, :shields => false, :electrolytes => false}
```

For a custom flag column, either pass the column name or use the generated
column-specific helper:

```ruby
enterprise.flags_as_attributes("features")
enterprise.features_as_attributes
```

If you want Active Record's normal attributes plus the virtual flag attributes,
use `attributes_with_flags`:

```ruby
enterprise.attributes_with_flags
# {"id" => 1, "features" => 1, "warpdrive" => true, "shields" => false, ...}
```

### Support for manually building conditions

The following class methods may support you when manually building
ActiveRecord conditions:

```ruby
Spaceship.warpdrive_condition         # "(spaceships.flags & 1 = 1)"
Spaceship.not_warpdrive_condition     # "(spaceships.flags & 1 = 0)"
Spaceship.shields_condition           # "(spaceships.flags & 2 = 2)"
Spaceship.not_shields_condition       # "(spaceships.flags & 2 = 0)"
Spaceship.electrolytes_condition      # "(spaceships.flags & 4 = 4)"
Spaceship.not_electrolytes_condition  # "(spaceships.flags & 4 = 0)"
```

These methods also accept a `:table_alias` option that can be used when
generating SQL that references the same table more than once:
```ruby
Spaceship.shields_condition(table_alias: "evil_spaceships") # "(evil_spaceships.flags & 2 = 2)"
```

### Choosing a query mode

By default, FlagShihTzu builds SQL conditions with bit operators:

```ruby
Spaceship.warpdrive_condition # "(spaceships.flags & 1 = 1)"
```

This is the safest default when flags are added over time. An `IN()` list can
only match the flag combinations known to the currently running process. During
a rolling deploy, old application processes may still know about only these
flags:

```ruby
has_flags 1 => :warpdrive,
  2 => :shields
```

Those old processes would build a `:warpdrive` condition like `flags in (1,3)`.
If the new deploy adds `3 => :premium` and a migration sets that new bit on
existing rows, a row with `warpdrive` and `premium` becomes `flags = 5`. The old
`IN()` condition no longer matches it even though the `warpdrive` bit is still
set. A bit-operator condition such as `flags & 1 = 1` continues to match the
row correctly.

The drawback is that due to the [bitwise operation][bitwise_operation] being done on the SQL side,
this query may not use an index on the flags column as effectively as a small
`IN()` list.

If your application values that query shape and you can guarantee that new
flags are not set while old app code may still be running, you can opt back
into the legacy mode globally:

```ruby
FlagShihTzu.default_flag_query_mode = :in_list
```

Or per `has_flags` declaration:

```ruby
has_flags 1 => :warpdrive,
  2 => :shields,
  :flag_query_mode => :in_list
```

The legacy `:in_list` mode may perform well for a small fixed set of flags,
but it does not work well for a high number of flags, as the value list for
`IN()` grows.

For MySQL, depending on your MySQL settings, this can even hit the
`max_allowed_packet` limit with the generated query, or the similar query length maximum for PostgreSQL.

The `:bit_operator` mode remains available explicitly:

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

### Deprecating or removing flags

Flag values are stored as bits in one integer. Removing a flag from the
`has_flags` declaration does not clear that bit from existing rows.

For example, an old version of the model may have this declaration:

```ruby
has_flags 1 => :warpdrive,
  2 => :shields
```

If a row has both flags enabled, its integer value is `3`. If a later version of
the model removes `:shields`:

```ruby
has_flags 1 => :warpdrive
```

the row still has `flags = 3`. With the default `:bit_operator` query mode,
`Spaceship.warpdrive` still matches that row because it asks whether bit 1 is
set. With legacy `:in_list` mode, the same scope would only know about the
remaining `:warpdrive` flag and would generate a value-list query equivalent to
`flags in (1)`, which would not match the row.

Recommended removal path:

1. Stop using the flag in application behavior, but leave it declared while old
   rows may still contain the bit.
2. If you want to reserve the bit position, rename the flag to a tombstone name
   such as `:_deprecated_shields` and do not reuse that bit.
3. If you want to remove the bit entirely, deploy a data cleanup while the flag
   is still declared:

```ruby
Spaceship.where(Spaceship.shields_condition).update_all(
  Spaceship.set_flag_sql(:shields, false),
)
```

4. After the cleanup has run everywhere and no old app processes still refer to
   the flag, remove it from `has_flags`.

Do not reuse a removed flag's bit position for a different meaning unless you
have first cleared that bit from every persisted row. Reusing uncleared bits
turns old data into false positives for the new flag.

### Updating flag column by raw sql

If you need to do mass updates without initializing object for each row, you can
use `#set_flag_sql` method on your class. Example:

```ruby
Spaceship.set_flag_sql(:warpdrive, true) # "flags = flags | 1"
Spaceship.set_flag_sql(:shields, false)  # "flags = flags & ~2"
```

And then use it in:

```ruby
Spaceship.update_all(Spaceship.set_flag_sql(:shields, false))
```

Beware that using multiple flag manipulation sql statements in the same query
probably will not have the desired effect (at least on sqlite3, not tested
on other databases), so you *should not* do this:

```ruby
Spaceship.update_all("#{Spaceship.set_flag_sql(:shields, false)},#{
  Spaceship.set_flag_sql(:warpdrive, true)}")
```

General rule of thumb: issue only one flag update per update statement.

### Checking flag columns

By default, `has_flags` does not check the database while the model class is
being loaded. This keeps model loading safe during tasks such as `db:create`,
`db:migrate`, `db:setup`, `db:seed`, asset precompilation, and test bootstraps
where the database or table may not exist yet.

If you want `has_flags` to verify that the flag column exists and is an integer
when the model is loaded, opt in per declaration:

```ruby
has_flags 1 => :warpdrive,
  2 => :shields,
  :check_for_column => true
```

Or opt in globally before models are loaded:

```ruby
FlagShihTzu.default_check_for_column = true
```

## 🧪 Running the gem tests

The current test harness is RSpec/Combustion based:

```console
bin/rake spec
```

For appraisal-specific checks, run through Appraisal with
`Appraisal.root.gemfile` so Bundler does not load the root development Gemfile:

```console
BUNDLE_GEMFILE=Appraisal.root.gemfile bundle exec appraisal kja-ar-8-0-r3 bundle exec kettle-test
```

Older development workflows used `bin/test.bash`, RVM, and hand-managed
database setup. That script is still present for historical reference, but the
templated CI path is now the Appraisal/RSpec flow.

## 👥 Authors

[Peter Boling](https://github.com/pboling),
[Patryk Peszko](https://github.com/ppeszko),
[Sebastian Roebke](https://github.com/boosty),
[David Anderson](https://github.com/alpinegizmo),
[Tim Payton](https://github.com/dizzy42)
and a helpful group of
[contributors](https://github.com/galtzo-floss/flag_shih_tzu/contributors).
Thanks!

Find out more about Peter Boling's work at
[RailsBling.com](https://railsbling.com/).

Find out more about XING at their
[Devblog](https://devblog.xing.com/).

## 🛠 How you can help!

Take a look at the `REEK` backlog and start fixing things. Once you complete a
change, run the tests. See "Running the gem tests".

If the tests pass, refresh the `REEK` backlog through the rake task:

```console
bin/rake reek:update
```

Follow the instructions in "Contributing" below.

## 🕰 2012 Change of Ownership and 0.3.X Release Notes

FlagShihTzu was originally a [XING AG](https://www.xing.com/) project.
[Peter Boling](https://peterboling.com) was a long time contributor and watcher
of the project.

In September 2012 XING transferred ownership of the project to Peter Boling.
Peter Boling had been maintaining a fork with extended capabilities. These
additional features became a part of the 0.3 line. The 0.2 line of the gem will
remain true to XING's original. The 0.3 line aims to maintain complete parity
and compatibility with XING's original as well. I will continue to monitor other
forks for original ideas and improvements. Pull requests are welcome, but please
rebase your work onto the current main branch to make integration easier.

More information on the changes for 0.3.X:
[galtzo-floss/flag_shih_tzu/wiki/Changes-for-0.3.x](https://github.com/galtzo-floss/flag_shih_tzu/wiki/Changes-for-0.3.x)

## Alternatives

I discovered in October 2015 that Michael Grosser had created a competing tool,
`bitfields`, way back in 2010, exactly a year after this tool was created. It
was a very surreal moment, as I had thought this was the only game in town and
it was when I began using and hacking on it. Once I got over that moment I
became excited, because competition makes things better, right? So, now I am
looking forward to a shootout some lazy Saturday. Until then there's this:
https://railsbling.com/flag_shih_tzu/why-use-flag_shih_tzu/

There is little that `bitfields` does better. The code is [less efficient](https://github.com/grosser/bitfields/blob/master/lib/bitfields.rb#L186 "recalculating and throwing away much of the result in many places"),
albeit more readable, not as well tested, has almost zero inline documentation,
and simply can't do many of the things I've built into `flag_shih_tzu`. If you
are still on legacy Ruby or legacy Rails, or using JRuby, then use
`flag_shih_tzu`. If you need multiple flag columns on a single model, use
`flag_shih_tzu`.

Will there ever be a merb/rails-like love fest between the projects? It would
be interesting. I like his name better. I like my features better. I like some
of his code better, and some of my code better. I've been wanting to do a full
rewrite of `flag_shih_tzu` ever since I inherited the project from
[XING](https://github.com/xing), but I haven't had time. So I don't know.

## 🦷 FLOSS Funding

While galtzo-floss tools are free software and will always be, the project would benefit immensely from some funding.
Raising a monthly budget of... "dollars" would make the project more sustainable.

We welcome both individual and corporate sponsors! We also offer a
wide array of funding channels to account for your preferences.
Currently, [Open Collective][🖇osc] is our preferred funding platform.

**If you're working in a company that's making significant use of galtzo-floss tools we'd
appreciate it if you suggest to your company to become a galtzo-floss sponsor.**

You can support the development of galtzo-floss tools via
[GitHub Sponsors][🖇sponsor],
[Liberapay][⛳liberapay],
[PayPal][🖇paypal],
[Open Collective][🖇osc]
and [Tidelift][🏙️entsup-tidelift].

| 📍 NOTE |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| If doing a sponsorship in the form of donation is problematic for your company <br/> from an accounting standpoint, we'd recommend the use of Tidelift, <br/> where you can get a support-like subscription instead. |

### Open Collective for Individuals

Support us with a monthly donation and help us continue our activities. [[Become a backer](https://opencollective.com/galtzo-floss#backer)]

NOTE: [kettle-readme-backers][kettle-readme-backers] updates this list every day, automatically.

<!-- OPENCOLLECTIVE-INDIVIDUALS:START -->
No backers yet. Be the first!
<!-- OPENCOLLECTIVE-INDIVIDUALS:END -->

### Open Collective for Organizations

Become a sponsor and get your logo on our README on GitHub with a link to your site. [[Become a sponsor](https://opencollective.com/galtzo-floss#sponsor)]

NOTE: [kettle-readme-backers][kettle-readme-backers] updates this list every day, automatically.

<!-- OPENCOLLECTIVE-ORGANIZATIONS:START -->
No sponsors yet. Be the first!
<!-- OPENCOLLECTIVE-ORGANIZATIONS:END -->

[kettle-readme-backers]: https://github.com/galtzo-floss/flag_shih_tzu/blob/main/exe/kettle-readme-backers

### Another way to support open-source

I’m driven by a passion to foster a thriving open-source community – a space where people can tackle complex problems, no matter how small. Revitalizing libraries that have fallen into disrepair, and building new libraries focused on solving real-world challenges, are my passions. I was recently affected by layoffs, and the tech jobs market is unwelcoming. I’m reaching out here because your support would significantly aid my efforts to provide for my family, and my farm (11 🐔 chickens, 2 🐶 dogs, 3 🐰 rabbits, 8 🐈‍ cats).

If you work at a company that uses my work, please encourage them to support me as a corporate sponsor. My work on gems you use might show up in `bundle fund`.

I’m developing a new library, [floss_funding][🖇floss-funding-gem], designed to empower open-source developers like myself to get paid for the work we do, in a sustainable way. Please give it a look.

**[Floss-Funding.dev][🖇floss-funding.dev]: 👉️ No network calls. 👉️ No tracking. 👉️ No oversight. 👉️ Minimal crypto hashing. 💡 Easily disabled nags**

[![OpenCollective Backers][🖇osc-backers-i]][🖇osc-backers] [![OpenCollective Sponsors][🖇osc-sponsors-i]][🖇osc-sponsors] [![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor] [![Liberapay Goal Progress][⛳liberapay-img]][⛳liberapay] [![Donate on PayPal][🖇paypal-img]][🖇paypal] [![Buy me a coffee][🖇buyme-small-img]][🖇buyme] [![Donate on Polar][🖇polar-img]][🖇polar] [![Donate to my FLOSS efforts at ko-fi.com][🖇kofi-img]][🖇kofi] [![Donate to my FLOSS efforts using Patreon][🖇patreon-img]][🖇patreon]

## 🔐 Security

See [SECURITY.md][🔐security].

## 🤝 Contributing

If you need some ideas of where to help, you could work on adding more code coverage,
or if it is already 💯 (see [below](#code-coverage)) check [issues][🤝gh-issues] or [PRs][🤝gh-pulls],
or use the gem and think about how it could be better.

We [![Keep A Changelog][📗keep-changelog-img]][📗keep-changelog] so if you make changes, remember to update it.

See [CONTRIBUTING.md][🤝contributing] for more detailed instructions.

### 🚀 Release Instructions

See [CONTRIBUTING.md][🤝contributing].

### Code Coverage

<details markdown="1">
<summary>Coverage service badges</summary>

[![Coverage Graph][🏀codecov-g]][🏀codecov]

[![Coveralls Test Coverage][🏀coveralls-img]][🏀coveralls]

[![QLTY Test Coverage][🏀qlty-covi]][🏀qlty-cov]

</details>

### 🪇 Code of Conduct

Everyone interacting with this project's codebases, issue trackers,
chat rooms and mailing lists agrees to follow the [![Contributor Covenant 2.1][🪇conduct-img]][🪇conduct].

## 🌈 Contributors

[![Contributors][🖐contributors-img]][🖐contributors]

Made with [contributors-img][🖐contrib-rocks].

Also see GitLab Contributors: [https://gitlab.com/galtzo-floss/flag_shih_tzu/-/graphs/main][🚎contributors-gl]

<details>
 <summary>⭐️ Star History</summary>

<a href="https://star-history.com/galtzo-floss/flag_shih_tzu&Date">
 <picture>
 <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=galtzo-floss/flag_shih_tzu&type=Date&theme=dark" />
 <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=galtzo-floss/flag_shih_tzu&type=Date" />
 <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=galtzo-floss/flag_shih_tzu&type=Date" />
 </picture>
</a>

</details>

## 📌 Versioning

This library follows [![Semantic Versioning 2.0.0][📌semver-img]][📌semver] for its public API where practical.
For most applications, prefer the [Pessimistic Version Constraint][📌pvc] with two digits of precision.

For example:

```ruby
spec.add_dependency("flag_shih_tzu", "~> 1.0")
```

<details markdown="1">
<summary>📌 Is "Platform Support" part of the public API? More details inside.</summary>

Dropping support for a platform can be a breaking change for affected users.
If a release changes supported platforms, it should be called out clearly in the changelog and versioned with that impact in mind.

To get a better understanding of how SemVer is intended to work over a project's lifetime,
read this article from the creator of SemVer:

- ["Major Version Numbers are Not Sacred"][📌major-versions-not-sacred]

</details>

See [CHANGELOG.md][📌changelog] for a list of releases.

## 📄 License

The gem is available as open source under the terms of
the [MIT](MIT.md) [![License: MIT][📄license-img]][📄license-ref].

### © Copyright

See [LICENSE.md][📄license] for the official copyright notice.

<details markdown="1">
<summary>Copyright holders</summary>

- Copyright (c) 2009 Alto
- Copyright (c) 2009-2012 boosty
- Copyright (c) 2009-2010 Daniel Jagszent
- Copyright (c) 2009-2010 ladislav.martincik
- Copyright (c) 2009 Martin Stannard
- Copyright (c) 2009-2011 pboling
- Copyright (c) 2009 Sebastian Roebke
- Copyright (c) 2009 Tobias Bielohlawek
- Copyright (c) 2009 XING Engineering
- Copyright (c) 2010 Joost Baaij
- Copyright (c) 2010 Joost Baaij
- Copyright (c) 2010 Ryan Wallace
- Copyright (c) 2011 Arturas Slajus
- Copyright (c) 2011 Musy Bite
- Copyright (c) 2011, 2014 Tim Liner
- Copyright (c) 2012-2013 David DIDIER
- Copyright (c) 2012-2015, 2017-2018, 2026 Peter H. Boling
- Copyright (c) 2012 Tatsuhiko Miyagawa
- Copyright (c) 2013 Blake Thomson
- Copyright (c) 2013 Keith Pitty
- Copyright (c) 2013 Peter M. Goldstein
- Copyright (c) 2013 Thomas Jachmann
- Copyright (c) 2014 Alexander Tipugin
- Copyright (c) 2014, 2017-2018, 2025 Jonathan del Strother
- Copyright (c) 2015 Ivan
- Copyright (c) 2015 jfcaiceo
- Copyright (c) 2016 Xinran Xiao
- Copyright (c) 2017 shiro16
- Copyright (c) 2018 Peter Boling
- Copyright (c) 2018 xpol
- Copyright (c) 2018 Yusuke Ebihara
- Copyright (c) 2019 Amy Martin
- Copyright (c) 2025 Annibelle Boling
- Copyright (c) 2025 horiken

</details>

## 🤑 A request for help

Maintainers have teeth and need to pay their dentists.
After getting laid off in an RIF in March, and encountering difficulty finding a new one,
I began spending most of my time building open source tools.
I'm hoping to be able to pay for my kids' health insurance this month,
so if you value the work I am doing, I need your support.
Please consider sponsoring me or the project.

To join the community or get help 👇️ Join the Discord.

[![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite]

To say "thanks!" ☝️ Join the Discord or 👇️ send money.

[![Sponsor galtzo-floss/flag_shih_tzu on Open Source Collective][🖇osc-all-bottom-img]][🖇osc] 💌 [![Sponsor me on GitHub Sponsors][🖇sponsor-bottom-img]][🖇sponsor] 💌 [![Sponsor me on Liberapay][⛳liberapay-bottom-img]][⛳liberapay] 💌 [![Donate on PayPal][🖇paypal-bottom-img]][🖇paypal]

### Please give the project a star ⭐ ♥.

Many parts of this project are actively managed by a [kettle-jem](https://github.com/structuredmerge/structuredmerge-ruby/tree/main/gems/kettle-jem) smart template utilizing [StructuredMerge.org](https://structuredmerge.org) merge contracts.

Thanks for RTFM. ☺️

[⛳liberapay-img]: https://img.shields.io/liberapay/goal/pboling.svg?logo=liberapay&color=a51611&style=flat
[⛳liberapay-bottom-img]: https://img.shields.io/liberapay/goal/pboling.svg?style=for-the-badge&logo=liberapay&color=a51611
[⛳liberapay]: https://liberapay.com/pboling/donate
[🖇osc-all-img]: https://img.shields.io/opencollective/all/galtzo-floss
[🖇osc-sponsors-img]: https://img.shields.io/opencollective/sponsors/galtzo-floss
[🖇osc-backers-img]: https://img.shields.io/opencollective/backers/galtzo-floss
[🖇osc-backers]: https://opencollective.com/galtzo-floss#backer
[🖇osc-backers-i]: https://opencollective.com/galtzo-floss/backers/badge.svg?style=flat
[🖇osc-sponsors]: https://opencollective.com/galtzo-floss#sponsor
[🖇osc-sponsors-i]: https://opencollective.com/galtzo-floss/sponsors/badge.svg?style=flat
[🖇osc-all-bottom-img]: https://img.shields.io/opencollective/all/galtzo-floss?style=for-the-badge
[🖇osc-sponsors-bottom-img]: https://img.shields.io/opencollective/sponsors/galtzo-floss?style=for-the-badge
[🖇osc-backers-bottom-img]: https://img.shields.io/opencollective/backers/galtzo-floss?style=for-the-badge
[🖇osc]: https://opencollective.com/galtzo-floss
[🖇sponsor-img]: https://img.shields.io/badge/Sponsor_Me!-pboling.svg?style=social&logo=github
[🖇sponsor-bottom-img]: https://img.shields.io/badge/Sponsor_Me!-pboling-blue?style=for-the-badge&logo=github
[🖇sponsor]: https://github.com/sponsors/pboling
[🖇polar-img]: https://img.shields.io/badge/polar-donate-a51611.svg?style=flat
[🖇polar]: https://polar.sh/pboling
[🖇kofi-img]: https://img.shields.io/badge/ko--fi-%E2%9C%93-a51611.svg?style=flat
[🖇kofi]: https://ko-fi.com/pboling
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
[⛳️gem-namespace]: https://github.com/galtzo-floss/flag_shih_tzu
[⛳️namespace-img]: https://img.shields.io/badge/namespace-FlagShihTzu-3C2D2D.svg?style=square&logo=ruby&logoColor=white
[⛳️gem-name]: https://bestgems.org/gems/flag_shih_tzu
[⛳️name-img]: https://img.shields.io/badge/name-flag__shih__tzu-3C2D2D.svg?style=square&logo=rubygems&logoColor=red
[⛳️tag-img]: https://img.shields.io/github/tag/galtzo-floss/flag_shih_tzu.svg
[⛳️tag]: https://github.com/galtzo-floss/flag_shih_tzu/releases
[🚂maint-blog]: http://www.railsbling.com/tags/flag_shih_tzu
[🚂maint-blog-img]: https://img.shields.io/badge/blog-railsbling-0093D0.svg?style=for-the-badge&logo=rubyonrails&logoColor=orange
[🚂maint-contact]: http://www.railsbling.com/contact
[🚂maint-contact-img]: https://img.shields.io/badge/Contact-Maintainer-0093D0.svg?style=flat&logo=rubyonrails&logoColor=red
[💖🖇linkedin]: http://www.linkedin.com/in/peterboling
[💖🖇linkedin-img]: https://img.shields.io/badge/LinkedIn-Profile-0B66C2?style=flat&logo=newjapanprowrestling
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
[📜src-gl]: https://gitlab.com/galtzo-floss/flag_shih_tzu
[📜src-cb-img]: https://img.shields.io/badge/CodeBerg-4893CC?style=for-the-badge&logo=CodeBerg&logoColor=blue
[📜src-cb]: https://codeberg.org/galtzo-floss/flag_shih_tzu
[📜src-gh-img]: https://img.shields.io/badge/GitHub-238636?style=for-the-badge&logo=Github&logoColor=green
[📜src-gh]: https://github.com/galtzo-floss/flag_shih_tzu
[📜docs-cr-rd-img]: https://img.shields.io/badge/RubyDoc-Current_Release-943CD2?style=for-the-badge&logo=readthedocs&logoColor=white
[📜docs-head-rd-img]: https://img.shields.io/badge/YARD_on_Galtzo.com-HEAD-943CD2?style=for-the-badge&logo=readthedocs&logoColor=white
[📜gl-wiki]: https://gitlab.com/galtzo-floss/flag_shih_tzu/-/wikis/home
[📜gh-wiki]: https://github.com/galtzo-floss/flag_shih_tzu/wiki
[📜gl-wiki-img]: https://img.shields.io/badge/wiki-gitlab-943CD2.svg?style=for-the-badge&logo=gitlab&logoColor=white
[📜gh-wiki-img]: https://img.shields.io/badge/wiki-github-943CD2.svg?style=for-the-badge&logo=github&logoColor=white
[👽dl-rank]: https://bestgems.org/gems/flag_shih_tzu
[👽dl-ranki]: https://img.shields.io/gem/rd/flag_shih_tzu.svg
[👽version]: https://bestgems.org/gems/flag_shih_tzu
[👽versioni]: https://img.shields.io/gem/v/flag_shih_tzu.svg
[🏀qlty-mnt]: https://qlty.sh/gh/galtzo-floss/projects/flag_shih_tzu
[🏀qlty-mnti]: https://qlty.sh/gh/galtzo-floss/projects/flag_shih_tzu/maintainability.svg
[🏀qlty-cov]: https://qlty.sh/gh/galtzo-floss/projects/flag_shih_tzu/metrics/code?sort=coverageRating
[🏀qlty-covi]: https://qlty.sh/gh/galtzo-floss/projects/flag_shih_tzu/coverage.svg
[🏀codecov]: https://codecov.io/gh/galtzo-floss/flag_shih_tzu
[🏀codecovi]: https://codecov.io/gh/galtzo-floss/flag_shih_tzu/graph/badge.svg
[🏀coveralls]: https://coveralls.io/github/galtzo-floss/flag_shih_tzu?branch=main
[🏀coveralls-img]: https://coveralls.io/repos/github/galtzo-floss/flag_shih_tzu/badge.svg?branch=main
[🚎ruby-2.4-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/ruby-2.4.yml
[🚎ruby-2.5-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/ruby-2.5.yml
[🚎ruby-2.6-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/ruby-2.6.yml
[🚎ruby-2.7-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/ruby-2.7.yml
[🚎ruby-3.0-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/ruby-3.0.yml
[🚎ruby-3.1-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/ruby-3.1.yml
[🚎ruby-3.2-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/ruby-3.2.yml
[🚎ruby-3.3-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/ruby-3.3.yml
[🚎ruby-3.4-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/ruby-3.4.yml
[🚎jruby-9.2-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/jruby-9.2.yml
[🚎jruby-9.3-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/jruby-9.3.yml
[🚎jruby-9.4-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/jruby-9.4.yml
[🚎truby-22.3-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/truffleruby-22.3.yml
[🚎truby-23.0-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/truffleruby-23.0.yml
[🚎truby-23.1-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/truffleruby-23.1.yml
[🚎truby-24.2-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/truffleruby-24.2.yml
[🚎truby-25.0-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/truffleruby-25.0.yml
[🚎2-cov-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/coverage.yml
[🚎2-cov-wfi]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/coverage.yml/badge.svg
[🚎3-hd-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/heads.yml
[🚎3-hd-wfi]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/heads.yml/badge.svg
[🚎5-st-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/style.yml
[🚎5-st-wfi]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/style.yml/badge.svg
[🚎9-t-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/truffle.yml
[🚎9-t-wfi]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/truffle.yml/badge.svg
[🚎10-j-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/jruby.yml
[🚎10-j-wfi]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/jruby.yml/badge.svg
[🚎11-c-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/current.yml
[🚎11-c-wfi]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/current.yml/badge.svg
[🚎12-crh-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/dep-heads.yml
[🚎12-crh-wfi]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/dep-heads.yml/badge.svg
[🚎13-🔒️-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/locked_deps.yml
[🚎13-🔒️-wfi]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/locked_deps.yml/badge.svg
[🚎14-🔓️-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/unlocked_deps.yml
[🚎14-🔓️-wfi]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/unlocked_deps.yml/badge.svg
[🚎15-🪪-wf]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/license-eye.yml
[🚎15-🪪-wfi]: https://github.com/galtzo-floss/flag_shih_tzu/actions/workflows/license-eye.yml/badge.svg
[💎ruby-2.4i]: https://img.shields.io/badge/Ruby-2.4-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.5i]: https://img.shields.io/badge/Ruby-2.5-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.6i]: https://img.shields.io/badge/Ruby-2.6-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.7i]: https://img.shields.io/badge/Ruby-2.7-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.0i]: https://img.shields.io/badge/Ruby-3.0-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.1i]: https://img.shields.io/badge/Ruby-3.1-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.2i]: https://img.shields.io/badge/Ruby-3.2-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.3i]: https://img.shields.io/badge/Ruby-3.3-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.4i]: https://img.shields.io/badge/Ruby-3.4-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-4.0i]: https://img.shields.io/badge/Ruby-4.0-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-c-i]: https://img.shields.io/badge/Ruby-current-CC342D?style=for-the-badge&logo=ruby&logoColor=green
[💎ruby-headi]: https://img.shields.io/badge/Ruby-HEAD-CC342D?style=for-the-badge&logo=ruby&logoColor=blue
[💎truby-22.3i]: https://img.shields.io/badge/Truffle_Ruby-22.3-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-23.0i]: https://img.shields.io/badge/Truffle_Ruby-23.0-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-23.1i]: https://img.shields.io/badge/Truffle_Ruby-23.1-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-24.2i]: https://img.shields.io/badge/Truffle_Ruby-24.2-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-25.0i]: https://img.shields.io/badge/Truffle_Ruby-25.0-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-c-i]: https://img.shields.io/badge/Truffle_Ruby-current-34BCB1?style=for-the-badge&logo=ruby&logoColor=green
[💎jruby-9.2i]: https://img.shields.io/badge/JRuby-9.2-FBE742?style=for-the-badge&logo=ruby&logoColor=red
[💎jruby-9.3i]: https://img.shields.io/badge/JRuby-9.3-FBE742?style=for-the-badge&logo=ruby&logoColor=red
[💎jruby-9.4i]: https://img.shields.io/badge/JRuby-9.4-FBE742?style=for-the-badge&logo=ruby&logoColor=red
[💎jruby-c-i]: https://img.shields.io/badge/JRuby-current-FBE742?style=for-the-badge&logo=ruby&logoColor=green
[💎jruby-headi]: https://img.shields.io/badge/JRuby-HEAD-FBE742?style=for-the-badge&logo=ruby&logoColor=blue
[🤝gh-issues]: https://github.com/galtzo-floss/flag_shih_tzu/issues
[🤝gh-pulls]: https://github.com/galtzo-floss/flag_shih_tzu/pulls
[🤝gl-issues]: https://gitlab.com/galtzo-floss/flag_shih_tzu/-/issues
[🤝gl-pulls]: https://gitlab.com/galtzo-floss/flag_shih_tzu/-/merge_requests
[🤝cb-issues]: https://codeberg.org/galtzo-floss/flag_shih_tzu/issues
[🤝cb-pulls]: https://codeberg.org/galtzo-floss/flag_shih_tzu/pulls
[🤝cb-donate]: https://donate.codeberg.org/
[🤝contributing]: https://github.com/galtzo-floss/flag_shih_tzu/blob/main/CONTRIBUTING.md
[🏀codecov-g]: https://codecov.io/gh/galtzo-floss/flag_shih_tzu/graph/badge.svg
[🖐contrib-rocks]: https://contrib.rocks
[🖐contributors]: https://github.com/galtzo-floss/flag_shih_tzu/graphs/contributors
[🖐contributors-img]: https://contrib.rocks/image?repo=galtzo-floss/flag_shih_tzu
[🚎contributors-gl]: https://gitlab.com/galtzo-floss/flag_shih_tzu/-/graphs/main
[🪇conduct]: https://github.com/galtzo-floss/flag_shih_tzu/blob/main/CODE_OF_CONDUCT.md
[🪇conduct-img]: https://img.shields.io/badge/Contributor_Covenant-2.1-259D6C.svg
[📌pvc]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint
[📌semver]: https://semver.org/spec/v2.0.0.html
[📌semver-img]: https://img.shields.io/badge/semver-2.0.0-259D6C.svg?style=flat
[📌semver-breaking]: https://github.com/semver/semver/issues/716#issuecomment-869336139
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html
[📌changelog]: https://github.com/galtzo-floss/flag_shih_tzu/blob/main/CHANGELOG.md
[📗keep-changelog]: https://keepachangelog.com/en/1.0.0/
[📗keep-changelog-img]: https://img.shields.io/badge/keep--a--changelog-1.0.0-34495e.svg?style=flat
[📌gitmoji]: https://gitmoji.dev
[📌gitmoji-img]: https://img.shields.io/badge/gitmoji_commits-%20%F0%9F%98%9C%20%F0%9F%98%8D-34495e.svg?style=flat-square
[🧮kloc]: https://www.youtube.com/watch?v=dQw4w9WgXcQ
[🧮kloc-img]: https://img.shields.io/badge/KLOC-0.453-FFDD67.svg?style=for-the-badge&logo=YouTube&logoColor=blue
[🔐security]: https://github.com/galtzo-floss/flag_shih_tzu/blob/main/SECURITY.md
[🔐security-img]: https://img.shields.io/badge/security-policy-259D6C.svg?style=flat
[📄copyright-notice-explainer]: https://opensource.stackexchange.com/questions/5778/why-do-licenses-such-as-the-mit-license-specify-a-single-year
[📄license]: LICENSE.md
[📄license-ref]: MIT.md
[📄license-img]: https://img.shields.io/badge/License-MIT-259D6C.svg
[📄license-compat]: https://www.apache.org/legal/resolved.html#category-a
[📄license-compat-img]: https://img.shields.io/badge/Apache_Compatible:_Category_A-✓-259D6C.svg?style=flat&logo=Apache
[🧪fossa]: https://app.fossa.com/projects/git%2Bgithub.com%2Fpboling%2Fflag_shih_tzu?ref=badge_shield
[🧪fossa-img]: https://app.fossa.com/api/projects/git%2Bgithub.com%2Fpboling%2Fflag_shih_tzu.svg?type=shield
[📄ilo-declaration]: https://www.ilo.org/declaration/lang--en/index.htm
[📄ilo-declaration-img]: https://img.shields.io/badge/ILO_Fundamental_Principles-✓-259D6C.svg?style=flat
[🚎yard-current]: http://rubydoc.info/gems/flag_shih_tzu
[🚎yard-head]: https://flag-shih-tzu.galtzo.com
[💎stone_checksums]: https://github.com/galtzo-floss/stone_checksums
[💎SHA_checksums]: https://gitlab.com/galtzo-floss/flag_shih_tzu/-/tree/main/checksums
[💎rlts]: https://github.com/rubocop-lts/rubocop-lts
[💎rlts-img]: https://img.shields.io/badge/code_style_&_linting-rubocop--lts-34495e.svg?plastic&logo=ruby&logoColor=white
[💎appraisal2]: https://github.com/appraisal-rb/appraisal2
[💎appraisal2-img]: https://img.shields.io/badge/appraised_by-appraisal2-34495e.svg?plastic&logo=ruby&logoColor=white
[💎d-in-dvcs]: https://railsbling.com/posts/dvcs/put_the_d_in_dvcs/

<!-- kettle-jem:metadata:start -->
| Field | Value |
|---|---|
| Package | flag_shih_tzu |
| Description | 🏁 Bit fields for ActiveRecord:<br>This gem lets you use a single integer column in an ActiveRecord model<br>to store a collection of boolean attributes (flags). Each flag can be used<br>almost in the same way you would use any boolean attribute on an<br>ActiveRecord object. |
| Homepage | https://github.com/galtzo-floss/flag_shih_tzu |
| Source | https://github.com/galtzo-floss/flag_shih_tzu/tree/v1.0.0 |
| License | `MIT` |
| Funding | https://github.com/sponsors/pboling, https://issuehunt.io/u/pboling, https://ko-fi.com/pboling, https://liberapay.com/pboling/donate, https://opencollective.com/galtzo-floss, https://patreon.com/galtzo, https://polar.sh/pboling, https://thanks.dev/u/gh/pboling, https://tidelift.com/funding/github/rubygems/flag_shih_tzu, https://www.buymeacoffee.com/pboling |
<!-- kettle-jem:metadata:end -->
