# frozen_string_literal: true

require_relative '../spec_helper'

# rubocop:disable Metrics/BlockLength
describe Minitest::Expectations do
  describe '#must_have_tag(:tag)' do
    describe 'handles being passed' do
      it 'a nil value' do
        assert_returns_error('Expected nil to have tag ["br"], but no such tag was found') do
          _(nil).must_have_tag('br')
        end
      end

      it 'an empty string value' do
        assert_returns_error('Expected " " to have tag ["br"], but no such tag was found') do
          _(' ').must_have_tag('br')
        end
      end

      it 'a basic <br> tag' do
        assert_no_error { _('<br>').must_have_tag('br') }
      end

      it 'an incorrectly expected tag' do
        msg = 'Expected "<br>" to have tag ["brr"], but no such tag was found'
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
            'Expected "<hr class=\"divider\">" to have tag ["hr[classs]"],',
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
            'Expected "<hr class=\"divider\">" to have tag ["hr[class=divder]"],',
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
            'Expected "<div id=\"header\" class=\"row\"></div>" to have tag ["div#headers"], ',
            'but no such tag was found'
          ].join

          assert_returns_error(msg) do
            _('<div id="header" class="row"></div>').must_have_tag('div#headers')
          end

          msg = [
            'Expected "<div id=\"header\" class=\"row\"></div>" to have tag ["div#header.rows"], ',
            'but no such tag was found'
          ].join

          assert_returns_error(msg) do
            _('<div id="header" class="row"></div>').must_have_tag('div#header.rows')
          end
        end
      end
      # /a basic <div...> tag

      describe 'a basic <label...> tag' do
        it 'with for attribute and nil contents' do
          assert_no_error { _(%(<label for="name">Name:</label>\n)).must_have_tag('label[for=name]', nil) }
        end

        it 'with for attribute and empty contents' do
          assert_no_error { _('<label for="name"></label>').must_have_tag('label[for=name]', '') }

          msg = [
            'Expected "<label for=\\"name\\">contents</label>" to have tag ["label[for=name]"] ',
            'with contents [""], but the tags content found is [contents]'
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
            'Expected "<label for=\"name\">Username:</label>" to have tag ["label[for=name]"]',
            ' with contents [""], but the tags content found is [Username:]'
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
            'Expected "<label for=\"name\">Username:</label>" to have tag ["label[for=name]"]',
            ' with inner_html [Username:], but did not match Regexp [/Users/]'
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
  end
  # /#must_have_tag(:tag)
end
# rubocop:enable Metrics/BlockLength
