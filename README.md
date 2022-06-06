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
FileUtils.mkdir(a)

# bad
FileUtils.rm(a) if FileTest.exist?(a)

# good
FileUtils.rm(a)
```