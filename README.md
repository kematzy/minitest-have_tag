<!-- markdownlint-disable MD013 MD033 -->

# Minitest::HaveTag

[![Ruby](https://github.com/kematzy/minitest-have_tag/actions/workflows/ruby.yml/badge.svg?branch=master)](https://github.com/kematzy/minitest-have_tag/actions/workflows/ruby.yml) - [![Gem Version](https://badge.fury.io/rb/minitest-have_tag.svg)](https://badge.fury.io/rb/minitest-have_tag) - [![Minitest Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop-minitest)

Coverage: **100%**

Adds methods to Minitest to test for existence of HTML tags, including contents,
within a provided string.

---

## Installation

Add this gem to your application's `Gemfile`:

```ruby
gem 'minitest-have_tag'
```

And then execute `bundle install`.

Or install it yourself with:

```bash
gem install minitest-have_tag
```

---

## Usage

### Setup

Add the gem in your `spec/spec_helper.rb` file after the `'minitest/autorun'` gem to automatically
add the assertion methods.

```ruby
require 'minitest/autorun'
require 'minitest/have_tag'
# ...
```

---

### Usage with default assertions

```ruby
class MyTest < Minitest::Test
  def test_basic_html_tag
    html = '<br>'
    assert_have_tag(html, 'br')
  end

  def test_basic_html_attributes
    html = '<div id="header" class="flex"></div>'

    # CSS class paths
    assert_have_tag(html, 'div.flex')
    assert_have_tag(html, 'div[@class=flex]')

    assert_have_tag(html, 'div#header')
  end

  # check for contents within a <div...>
  def test_basic_html_tag_contents
    html = '<div class="row">contents</div>'

    assert_have_tag(html, 'div.row', 'contents')
  end

  def test_complex_html_with_contents
    html = <<~HTML
      <div id="intro" class="row">
        <div class="col-md-12">
          <h1>Header</h1>
        </div>
      </div>
    HTML

    assert_have_tag(html, 'div#intro.row > .col-md-12 > h1', 'Header')
  end

  # Error handling
  def test_basic_error_handling
    html = '<br>'
    error_msg = 'Expected "<br>" to have tag "div", but no such tag was found'

    assert_returns_error(error_msg) do
      assert_have_tag(html, 'div')
    end
  end

  ## Testing for non-existence of the expected HTML tag, including contents

  def test_negated_basic_html_tag
    html = '<abbr>'
    refute_have_tag(html, 'br')
  end

  def test_negated_basic_html_attributes
    html = '<div id="header" class="flex"></div>'

    refute_have_tag(html, 'div.flex-wrap')
    refute_have_tag(html, 'div[@class=flex-wrap]')

    refute_have_tag(html, 'div#hero')
  end

  def test_negated_basic_html_tag_contents
    html = '<div class="row">contents</div>'

    refute_have_tag(html, 'div.row', 'some content')
  end

  def test_negated_complex_html_with_contents
    html = <<~HTML
      <div id="intro" class="row">
        <div class="col-md-12">
          <h1>Header</h1>
        </div>
      </div>
    HTML

    refute_have_tag(html, 'div#intro.row > .col-lg-12 > h2', 'Header')
  end

  def test_negated_basic_error_handling
    html = '<br>'
    error_msg = 'Expected "<br>" to NOT have tag "br", but such a tag was found'

    assert_returns_error(error_msg) do
      refute_have_tag(html, 'br')
    end
  end
end
```

<br>
<br>

### Using Expectation Syntax

```ruby
describe 'HTML Response' do
  let(:html) { '<div id="header" class="flex"></div>' }
  let(:label) { %(<label for="name">Username:</label>\n) }

  it 'confirms HTML attributes' do
    _(html).must_have_tag('div.flex')
  end

  it 'refutes HTML attribute' do
    _(html).wont_have_tag('div.flex-wrap')
  end

  it 'regex content matching' do
   _(label).must_have_tag('label[for=name]', /User/) }

   _(label).wont_have_tag('label[for=name]', /Name/) }
  end
  # ...
end
```


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

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### Install locally

To install this gem onto your local machine, run `bundle exec rake install`.

### Release new version

To release a new version:

- ensure `bundle exec rake` passes.
- update the version number in `version.rb`.
- run `bundle exec rake release` which:
  - creates a Git tag for the version;
  - pushes Git commits and tags to GitHub;
  - pushes the `.gem` file to [RubyGems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome at [github.com/kematzy/minitest-have_tag](https://github.com/kematzy/minitest-have_tag/issues).

## Copyright

Copyright (c) 2015 - 2025 Kematzy

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
