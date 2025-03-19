# frozen_string_literal: false

# Use this when using `bundle exec ...`
require 'spec_helper'

# Use this when using `rake spec` (without bundle)
# require_relative '../../spec_helper'

describe 'Minitest' do
  describe '::Expectations' do
    before do
      # Common HTML snippets
      @br_tag = '<br>'
      @hr_tag = '<hr class="divider">'
      @div_tag = '<div id="header" class="row"></div>'
      @div_multi_class = '<div id="header" class="row columns"></div>'
      @label_tag = '<label for="name">Name:</label>'
      @label_empty = '<label for="name"></label>'
      @label_username = '<label for="name">Username:</label>'
      @multiple_tags = '<tag>content1</tag><tag>content2</tag>'
    end

    describe '#.must_have_tag(:tag)' do
      describe 'edge cases' do
        it 'handles nil values' do
          assert_returns_error('Expected nil to have tag "br", but no such tag was found') do
            _(nil).must_have_tag('br')
          end
        end

        it 'handles empty string values' do
          assert_returns_error('Expected " " to have tag "br", but no such tag was found') do
            _(' ').must_have_tag('br')
          end
        end
      end

      describe 'basic tag matching' do
        it 'matches basic tags' do
          assert_no_error { _(@br_tag).must_have_tag('br') }
        end

        it 'fails with incorrect tag names' do
          error_message = 'Expected "<br>" to have tag "brr", but no such tag was found'
          assert_returns_error(error_message) do
            _(@br_tag).must_have_tag('brr')
          end
        end
      end

      describe 'attribute matching' do
        # Define test cases for attributes
        [
          # [selector, html, should_pass, error_pattern]
          ['hr[class]', '<hr class="divider">', true, nil],
          ['hr[classs]', '<hr class="divider">', false, /no such tag was found/],
          ['hr[class=divider]', '<hr class="divider">', true, nil],
          ['hr[class=divder]', '<hr class="divider">', false, /no such tag was found/]
        ].each do |selector, html, should_pass, error_pattern|
          it "#{should_pass ? "matches" : "fails for"} '#{selector}' with '#{html}'" do
            if should_pass
              assert_no_error { _(html).must_have_tag(selector) }
            else
              assert_returns_error(error_pattern) { _(html).must_have_tag(selector) }
            end
          end
        end

        describe 'with multiple attributes' do
          [
            'div#header',
            'div[id=header]',
            'div.row',
            'div[class=row]',
            'div#header.row',
            'div[id=header][class=row]'
          ].each do |selector|
            it "matches '#{selector}' with div having id and class" do
              assert_no_error { _(@div_tag).must_have_tag(selector) }
            end
          end
        end
      end

      describe 'content matching' do
        it 'matches tag with exact content' do
          assert_no_error { _(@label_tag).must_have_tag('label[for=name]', 'Name:') }
        end

        it 'matches tag with nil content parameter' do
          assert_no_error { _(@label_tag).must_have_tag('label[for=name]', nil) }
        end

        it 'matches tag with empty content' do
          assert_no_error { _(@label_empty).must_have_tag('label[for=name]', '') }
        end

        it 'fails when content does not match' do
          error_message = /Expected .* to have tag .* with expected contents .*, but found/
          assert_returns_error(error_message) do
            _(@label_tag).must_have_tag('label[for=name]', 'Wrong content')
          end
        end

        it 'matches tag with regexp content' do
          assert_no_error { _(@label_username).must_have_tag('label[for=name]', /User/) }
          assert_no_error { _(@label_username).must_have_tag('label[for=name]', /user/i) }
        end

        it 'fails when regexp content does not match' do
          assert_returns_error(/but did not match Regexp/) do
            _(@label_username).must_have_tag('label[for=name]', /nonexistent/)
          end
        end
      end

      describe 'multiple matching tags' do
        it 'finds first matching tag with content' do
          assert_no_error { _(@multiple_tags).must_have_tag('tag', 'content1') }
          assert_no_error { _(@multiple_tags).must_have_tag('tag', 'content2') }
        end
      end

      describe 'additional edge cases' do
        it 'handles malformed HTML' do
          malformed = '<div>unclosed'
          # Depending on how your implementation should handle this case
          assert_no_error { _(malformed).must_have_tag('div') }
        end

        it 'handles HTML with entities' do
          html_with_entity = '<div>&lt;escaped&gt;</div>'
          assert_no_error { _(html_with_entity).must_have_tag('div', '&lt;escaped&gt;') }
        end

        it 'handles nested tags' do
          nested_html = '<div><span>content</span></div>'
          assert_no_error { _(nested_html).must_have_tag('div') }
          assert_no_error { _(nested_html).must_have_tag('span', 'content') }
        end
      end

      describe 'handles being passed' do
        it 'a nil value' do
          assert_returns_error('Expected nil to have tag "br", but no such tag was found') do
            _(nil).must_have_tag('br')
          end
        end

        it 'an empty string value' do
          assert_returns_error('Expected " " to have tag "br", but no such tag was found') do
            _(' ').must_have_tag('br')
          end
        end

        it 'a basic <br> tag' do
          assert_no_error { _('<br>').must_have_tag('br') }
        end

        it 'an incorrectly expected tag' do
          msg = 'Expected "<br>" to have tag "brr", but no such tag was found'
          assert_returns_error(msg) do
            _('<br>').must_have_tag('brr')
          end
        end

        describe 'a basic <hr...> tag' do
          it 'with a class attribute' do
            str = '<hr class="divider">'
            assert_no_error { _(str).must_have_tag('hr[class]') }
          end

          it 'with a class attribute with an incorrectly expected' do
            msg = [
              'Expected "<hr class=\"divider\">" to have tag "hr[classs]",',
              ' but no such tag was found'
            ].join
            assert_returns_error(msg) do
              _('<hr class="divider">').must_have_tag('hr[classs]')
            end
          end

          it 'with a class attribute' do
            assert_no_error do
              _('<hr class="divider">').must_have_tag('hr[class=divider]')
            end
          end

          it 'with a class attribute with an incorrectly expected attribute' do
            msg = [
              'Expected "<hr class=\"divider\">" to have tag "hr[class=divder]",',
              ' but no such tag was found'
            ].join
            assert_returns_error(msg) do
              _('<hr class="divider">').must_have_tag('hr[class=divder]')
            end
          end
        end
        # /a basic <hr...> tag

        describe 'a basic <div...> tag' do
          it 'with id and class attributes' do
            str = '<div id="header" class="row"></div>'
            [
              'div#header',
              'div[id=header]',
              'div.row',
              'div[class=row]',
              'div#header.row',
              'div[id=header][class=row]'
            ].each do |t|
              assert_no_error { _(str).must_have_tag(t) }
            end
          end

          it 'with multiple classes' do
            str = '<div id="header" class="row columns"></div>'
            [
              'div[class=\'row columns\']',
              'div#header.row.columns',
              'div[id=header][class=\'row columns\']'
            ].each do |t|
              assert_no_error { _(str).must_have_tag(t) }
            end
          end

          it 'a basic <label...> tag with for attribute and contents' do
            html = %(<label for="name">Name:</label>\n)

            assert_no_error { _(html).must_have_tag('label[for=name]', 'Name:') }

            html = %(<label for="name">User Name:</label>\n)
            assert_no_error { _(html).must_have_tag('label[for=name]', 'User Name:') }
          end

          it 'with id & class attributes with an incorrectly expected attribute' do
            msg = [
              'Expected "<div id=\"header\" class=\"row\"></div>" to have tag "div#headers", ',
              'but no such tag was found'
            ].join

            assert_returns_error(msg) do
              _('<div id="header" class="row"></div>').must_have_tag('div#headers')
            end

            msg = [
              'Expected "<div id=\"header\" class=\"row\"></div>" to have tag ',
              '"div#header.rows", but no such tag was found'
            ].join

            assert_returns_error(msg) do
              _('<div id="header" class="row"></div>').must_have_tag('div#header.rows')
            end
          end
        end
        # /a basic <div...> tag

        describe 'a basic <label...> tag' do
          it 'with for attribute and nil contents' do
            assert_no_error do
              _(%(<label for="name">Name:</label>\n)).must_have_tag('label[for=name]', nil)
            end
          end

          it 'with for attribute and empty contents' do
            assert_no_error { _('<label for="name"></label>').must_have_tag('label[for=name]', '') }

            msg = [
              'Expected "<label for=\\"name\\">contents</label>" to have tag "label[for=name]" ',
              'with expected contents [""], but found [contents]'
            ].join

            assert_returns_error(msg) do
              _('<label for="name">contents</label>').must_have_tag('label[for=name]', '')
            end
          end

          it 'with for attribute and symbol contents' do
            html = %(<label for="name"></label>\n)

            assert_returns_error(
              /ERROR: contents is neither String nor Regexp, it's \[Symbol\]/
            ) do
              _(html).must_have_tag('label[for=name]', :symbol)
            end
          end

          it 'with inner_html and empty contents' do
            html = %(<label for="name">Username:</label>)

            msg = [
              'Expected "<label for=\"name\">Username:</label>" to have tag "label[for=name]"',
              ' with expected contents [""], but found [Username:]'
            ].join
            assert_returns_error(msg) { _(html).must_have_tag('label[for=name]', '') }
          end

          it 'with for attribute and contents with incorrect expectations' do
            str = %(<label for="name">Name:</label>\n)

            assert_no_error { _(str).must_have_tag('label[for=name]', 'Name:') }
          end

          it 'with for attribute and Regexp contents' do
            str = %(<label for="name">Username:</label>\n)
            assert_no_error { _(str).must_have_tag('label[for=name]', /User/) }
            assert_no_error { _(str).must_have_tag('label[for=name]', /user/i) }
          end

          it 'with for attribute and Regexp contents' do
            str = '<label for="name">Username:</label>'
            msg = [
              'Expected "<label for=\"name\">Username:</label>" to have tag "label[for=name]"',
              ' with contents [Username:], but did not match Regexp [/Users/]'
            ].join

            assert_returns_error(msg) { _(str).must_have_tag('label[for=name]', /Users/) }

            assert_returns_error(msg.sub('Regexp [/Users/]', 'Regexp [/users/i]')) do
              _(str).must_have_tag('label[for=name]', /users/i)
            end
          end
        end
        # /a basic <label...> tag

        it 'multiple tags when searching for contents' do
          html = '<tag>content1</tag><tag>content2</tag>'

          assert_no_error { _(html).must_have_tag('tag', 'content1') }
          assert_no_error { _(html).must_have_tag('tag', 'content2') }
        end
      end
      # /handles being passed

      describe 'case sensitivity' do
        it 'is case-sensitive for tag names by default' do
          assert_no_error { _('<DIV>content</DIV>').must_have_tag('div') }
        end

        # it 'is case-sensitive for attribute values' do
        #   html = '<div id="Header">content</div>'
        #   assert_returns_error(/no such tag was found/) do
        #     _(html).must_have_tag('div#Header')
        #   end
        # end
      end

      describe 'HTML with comments' do
        it 'ignores HTML comments' do
          html_with_comment = '<!-- comment --><div>content</div>'
          assert_no_error { _(html_with_comment).must_have_tag('div', 'content') }
        end
      end
    end
    # /#.must_have_tag(:tag)

    describe '#.wont_have_tag' do
      describe 'with simple inputs' do
        it 'passes for nil values' do
          assert_no_error { _(nil).wont_have_tag('br') }
        end

        it 'passes for empty strings' do
          assert_no_error { _(' ').wont_have_tag('br') }
        end

        it 'fails for basic tags that match' do
          msg = 'Expected "<br>" to NOT have tag "br", but such a tag was found'
          assert_returns_error(msg) { _('<br>').wont_have_tag('br') }
        end

        it 'passes for tags that do not match' do
          assert_no_error { _('<br>').wont_have_tag('brr') }
        end
      end

      describe 'with tags containing attributes' do
        describe 'hr tags' do
          it 'fails when attribute exists' do
            msg = [
              'Expected "<hr class=\"divider\">" to NOT have tag "hr[class]", ',
              'but such a tag was found'
            ].join

            assert_returns_error(msg) do
              _('<hr class="divider">').wont_have_tag('hr[class]')
            end
          end

          it 'passes when attribute does not exist' do
            assert_no_error { _('<hr class="divider">').wont_have_tag('hr[classs]') }
          end

          it 'fails when attribute with value exists' do
            msg = [
              'Expected "<hr class=\"divider\">" to NOT have tag "hr[class=divider]", ',
              'but such a tag was found'
            ].join

            assert_returns_error(msg) do
              _('<hr class="divider">').wont_have_tag('hr[class=divider]')
            end
          end

          it 'passes when attribute value does not match' do
            assert_no_error { _('<hr class="divider">').wont_have_tag('hr[class=divder]') }
          end
        end

        describe 'div tags' do
          let(:div_with_id_class) { '<div id="header" class="row"></div>' }
          let(:div_with_multiple_classes) { '<div id="header" class="row columns"></div>' }

          it 'fails with various selector formats that match' do
            [
              'div#header',
              'div[id=header]',
              'div.row',
              'div[class=row]',
              'div#header.row',
              'div[id=header][class=row]'
            ].each do |selector|
              # msg = [
              #   "Expected \"#{div_with_id_class}\" to NOT have tag [\"#{selector}\"], ",
              #   "but such a tag was found"
              # ].join
              msg = /Expected "(.*)" to NOT have tag "(.*)", but such a tag was found/
              assert_returns_error(msg) do
                _(div_with_id_class).wont_have_tag(selector)
              end
            end
          end

          it 'fails with multiple class selectors that match' do
            [
              'div[class="row columns"]',
              'div#header.row.columns',
              'div[id=header][class="row columns"]'
            ].each do |selector|
              msg = /Expected "(.*)" to NOT have tag "(.*)", but such a tag was found/
              assert_returns_error(msg) do
                _(div_with_multiple_classes).wont_have_tag(selector)
              end
            end
          end

          it 'passes when selectors do not match' do
            assert_no_error { _(div_with_id_class).wont_have_tag('div#headers') }
            assert_no_error { _(div_with_id_class).wont_have_tag('div#header.rows') }
          end
        end
      end

      describe 'with content matching' do
        describe 'label tags' do
          it 'fails when tag exists and nil content is specified' do
            assert_returns_error(
              /to NOT have tag "label\[for=name\]", but such a tag was found/
            ) do
              _('<label for="name">Name:</label>').wont_have_tag('label[for=name]', nil)
            end
          end

          it 'passes when tag exists but has different content than empty string' do
            assert_no_error do
              _(%(<label for="name">Username:</label>)).wont_have_tag('label[for=name]', '')
            end
          end

          it 'fails when tag exists with empty content and empty content is expected' do
            msg = /to NOT have tag "label\[for=name\]", but such a tag was found/
            assert_returns_error(msg) do
              _('<label for="name"></label>').wont_have_tag('label[for=name]', '')
            end
          end

          it 'fails when tag content matches string expectation' do
            html = %(<label for="name">Name:</label>)
            msg = [
              'Expected "<label for=\"name\">Name:</label>" to NOT have tag ',
              '"label[for=name]", but such a tag was found'
            ].join

            assert_returns_error(msg) { _(html).wont_have_tag('label[for=name]', 'Name:') }
          end

          it 'passes when symbol content is expected but not found' do
            html = %(<label for="name"></label>\n)
            assert_no_error { _(html).wont_have_tag('label[for=name]', :symbol) }
          end

          it 'fails when tag content matches regex expectation' do
            str = %(<label for="name">Username:</label>\n)
            msg = [
              'Expected "<label for=\"name\">Username:</label>\n" to NOT have tag ',
              '"label[for=name]", but such a tag was found'
            ].join

            assert_returns_error(msg) { _(str).wont_have_tag('label[for=name]', /User/) }
            assert_returns_error(msg) { _(str).wont_have_tag('label[for=name]', /user/i) }
          end

          it 'passes when tag content does not match regex expectation' do
            str = '<label for="name">Username:</label>'

            assert_no_error { _(str).wont_have_tag('label[for=name]', /Users/) }
            assert_no_error { _(str).wont_have_tag('label[for=name]', /users/i) }
          end
        end
      end
    end
  end
  # /::Expectations
end
