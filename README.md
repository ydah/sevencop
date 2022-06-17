# sevencop

[![test](https://github.com/r7kamura/sevencop/actions/workflows/test.yml/badge.svg)](https://github.com/r7kamura/sevencop/actions/workflows/test.yml)
[![Gem Version](https://badge.fury.io/rb/sevencop.svg)](https://rubygems.org/gems/sevencop)

Custom cops for [RuboCop](https://github.com/rubocop/rubocop).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sevencop', require: false
```

And then execute:

```
bundle install
```

Or install it yourself as:

```
gem install sevencop
```

## Usage

```yaml
# .rubocop.yml
require:
  - sevencop
```

## Cops

### `Sevencop/RedundantExistenceCheck`

Identifies redundant existent check before file operation.

```ruby
# bad
FileUtils.mkdir(a) unless FileTest.exist?(a)

# good
FileUtils.mkdir_p(a)

# bad
FileUtils.rm(a) if FileTest.exist?(a)

# good
FileUtils.rm_f(a)
```

### `Sevencop/UniquenessValidatorExplicitCaseSensitivity`

Identifies use of UniquenessValidator without :case_sensitive option.

```ruby
# bad
validates :name, uniqueness: true

# good
validates :name, uniqueness: { case_sensitive: true }

# bad
validates :name, uniqueness: { allow_nil: true, scope: :user_id }

# good
validates :name, uniqueness: { allow_nil: true, scope: :user_id, case_sensitive: true }
```

Useful to keep the same behavior between Rails 6.0 and 6.1 where case insensitive collation is used in MySQL.

Note that this cop is `Enabled: false` by default.
