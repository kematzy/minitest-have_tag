# Minitest::HaveTag

Adds methods to Minitest to test for existence of HTML tags, including contents, within a provided 
string.

Currently adds the following methods:

### Minitest::Assertions

#### `:assert_have_tag(actual, expected, contents = nil, msg = nil)`

#### `:refute_have_tag(actual, expected, contents = nil, msg = nil)`

### Minitest::Expectations

#### `actual.must_have_tag(expected, contents = nil, msg = nil)`

#### `actual.wont_have_tag(expected, contents = nil, msg = nil)`

<br>
---

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'minitest-have_tag'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install minitest-have_tag

<br>
---


## Usage

Add the gem to your **Gemfile** or **.gemspec** file and then load the gem in your `spec_helper.rb`
file as follows:

```ruby
 # <snip...>
 
 require 'minitest/autorun'
 
 # load assert_have_tag() support
 require 'minitest/have_tag'
 
 # <snip...>
```

Adding the above to your `spec_helper.rb` file automatically adds the key helper methods to the 
`Minitest::Assertions` to test for existence of HTML tag, including contents, within the provided 
String.

### `assert_have_tag()`

```ruby
 assert_have_tag('<br>', 'br')  #=> 
 
 # check for CSS :class attribute
 assert_have_tag('<hr class="divider">', 'hr.divider')
 assert_have_tag('<hr class="divider">', 'hr[@class=divider]')
 
 # check for CSS :id attribute
 assert_have_tag('<hr id="divider">', 'hr#divider')
 assert_have_tag('<hr id="divider">', 'hr[@id=divider]')
 
 # check for contents within a <div...>
 assert_have_tag('<div class="row">contents</div>', 'hr.row', 'contents')
 
 html = <<-HTML
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


### `:refute_have_tag()`
  
Method to test for non-existence of the expected HTML tag, including contents, 
within the provided string.

```ruby
 refute_have_tag('<abbr>', 'br')  #=> 
 
 # check for CSS :class attribute
 refute_have_tag('<hr class="divider">', 'hr.space')
 refute_have_tag('<hr class="divider">', 'hr[@class=space]')
 
 # check for CSS :id attribute
 refute_have_tag('<hr id="divider">', 'hr#space')
 refute_have_tag('<hr id="divider">', 'hr[@id=space]')
 
 # check for contents within a <div...>
 refute_have_tag('<div class="row">contents</div>', 'hr.row', '<h1>Header</h1>')
 
 html = <<-HTML
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


<br>

## Dependencies

This Gem depends upon the following:

### Runtime:

* minitest
* nokogiri


### Development & Tests:

* bundler (~> 1.10)
* rake  (~> 10.0)
* minitest-hooks
* minitest-rg

* simplecov


<br>


## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run 
`bundle exec rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new 
version, update the version number in `version.rb`, and then run `bundle exec rake release`, which 
will create a git tag for the version, push git commits and tags, and push the `.gem` file to 
[rubygems.org](https://rubygems.org).

<br>


## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/kematzy/minitest-have_tag). 

This project is intended to be a safe, welcoming space for collaboration, and contributors are 
expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

<br>


## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix in a separate branch.
* Add spec tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with Rakefile, version, or history.
  * (if you want to have your own version, that is fine but bump version in a commit by itself 
    I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.


<br>


## Copyright

Copyright (c) 2015 Kematzy

Released under the MIT License. See LICENSE for further details.

