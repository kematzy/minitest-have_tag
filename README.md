# Minitest::HaveTag

[![Ruby](https://github.com/kematzy/minitest-have_tag/actions/workflows/ruby.yml/badge.svg?branch=master)](https://github.com/kematzy/minitest-have_tag/actions/workflows/ruby.yml)

[![Gem Version](https://badge.fury.io/rb/minitest-have_tag.svg)](https://badge.fury.io/rb/minitest-have_tag)

[![Minitest Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop-minitest)

Adds methods to Minitest to test for existence of HTML tags, including contents,
within a provided string.

## Added methods:

### Minitest::Assertions

- **`:assert_have_tag(actual, expected, contents = nil, msg = nil)`**

- **`:refute_have_tag(actual, expected, contents = nil, msg = nil)`**

### Minitest::Expectations

- **actual.`must_have_tag(expected, contents = nil, msg = nil)`**

- **actual.`wont_have_tag(expected, contents = nil, msg = nil)`**

---

## Installation

Add this gem to your application `Gemfile`:

```ruby
gem 'minitest-have_tag'
```

or for the cutting edge:

```ruby
gem 'minitest-have_tag', git: 'https://github.com/kematzy/minitest-have_tag', branch: 'master'
```

Then run `bundle install` to install the gems.

---

## Usage

Load the gem in your `spec/spec_helper.rb` file as follows:

```ruby
# <snip...>

require 'minitest/autorun'
# load assert_have_tag() support
require 'minitest/have_tag'

# <snip...>
```

Adding the above to your `spec/spec_helper.rb` file automatically adds the key
helper methods to the `Minitest::Assertions` to test for existence of HTML tag,
including contents, within the provided String.

---

### `assert_have_tag()`

```ruby
assert_have_tag('<br>', 'br')

# check for CSS :class attribute
assert_have_tag('<hr class="divider">', 'hr.divider')
assert_have_tag('<hr class="divider">', 'hr[@class=divider]')

# check for CSS :id attribute
assert_have_tag('<hr id="divider">', 'hr#divider')
assert_have_tag('<hr id="divider">', 'hr[@id=divider]')

# check for contents within a <div...>
assert_have_tag('<div class="row">contents</div>', 'hr.row', 'contents')

html = <<~HTML
  <div id="intro" class="row">
    <div class="col-md-12">
      <h1>Header</h1>
    </div>
  </div>
HTML

#
assert_have_tag(html, 'div#intro.row > .col-md-12 > h1', 'Header')
```

Produces an extensive error message when something is wrong

```ruby
assert_have_tag('<br>', 'brr')
   #=> 'Expected "<br>" to have tag ["brr"], but no such tag was found'
```

---

### `:refute_have_tag()`

Method to test for non-existence of the expected HTML tag, including contents,
within the provided string.

```ruby
refute_have_tag('<abbr>', 'br')

# check for CSS :class attribute
refute_have_tag('<hr class="divider">', 'hr.space')
refute_have_tag('<hr class="divider">', 'hr[@class=space]')

# check for CSS :id attribute
refute_have_tag('<hr id="divider">', 'hr#space')
refute_have_tag('<hr id="divider">', 'hr[@id=space]')

# check for contents within a <div...>
refute_have_tag('<div class="row">contents</div>', 'hr.row', '<h1>Header</h1>')

html = <<~HTML
  <div id="intro" class="row">
    <div class="col-md-12">
      <h1>Header</h1>
    </div>
  </div>
HTML

#
refute_have_tag(html, 'div#intro.row > .col-md-12 > h1', 'Header')
```

Produces an extensive error message when something is wrong:

```ruby
 refute_have_tag('<br>', 'br')
   #=> 'Expected "<br>" to NOT have tag ["br"], but such a tag was found'
```

---

## Dependencies

This Gem depends upon the following:

### Runtime

- minitest
- nokogiri

### Development & Tests

- guard
- guard-minitest
- minitest
- minitest-assert_errors
- minitest-hooks
- minitest-rg
- rack-test (~> 2.1)
- rake (~> 13.0)
- rubocop (~> 1.31)
- rubocop-minitest
- rubocop-performance
- rubocop-rake
- simplecov

---

## Development

Get started with these commands:

```bash
# clone the repository
git clone https://github.com/kematzy/minitest-have_tag.git

# change into repository directory
cd minitest-have_tag/

# install dependencies
bundle install

# run the default tests with coverage & rubocop checking
bundle exec rake

# enable automatic reloading of tests during development
bundle exec guard
```

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version:

- ensure `bundle exec rake` passes.
- update the version number in `version.rb`.
- run `bundle exec rake release` to:
  - create a Git tag for the version;
  - pushes Git commits and tags to GitHub;
  - pushes the `.gem` file to [rubygems.org](https://rubygems.org).

---

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/kematzy/minitest-have_tag).

This project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the
[Contributor Covenant](contributor-covenant.org) code of conduct.

---

## Note on Patches/Pull Requests

- Fork the project.
- Make your feature addition or bug fix in a separate branch.
- Add spec tests for it. This is important so I don't break it in a future
  version unintentionally.
- Commit, do not mess with Rakefile, version, or history.
  - (if you want to have your own version, that is fine but bump version in
    a commit by itself I can ignore when I pull)
- Send me a pull request. Bonus points for topic branches.

---

## Copyright

Copyright (c) 2015 - 2024 Kematzy

Released under the MIT License. See LICENSE for further details.
