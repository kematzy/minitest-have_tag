# frozen_string_literal: true

require_relative '../spec_helper'

# rubocop:disable Metrics/BlockLength
describe Minitest::Assertions do
  describe '#assert_have_tag(:html, :tag)' do
    describe 'handles being passed' do
      it 'a nil value' do
        assert_returns_error('Expected nil to have tag ["br"], but no such tag was found') do
          assert_have_tag(nil, 'br')
        end
      end

      it 'an empty string value' do
        assert_returns_error('Expected " " to have tag ["br"], but no such tag was found') do
          assert_have_tag(' ', 'br')
        end
      end

      it 'a basic <br> tag' do
        assert_no_error { assert_have_tag('<br>', 'br') }
      end

      it 'an incorrectly expected tag' do
        msg = 'Expected "<br>" to have tag ["brr"], but no such tag was found'
        assert_returns_error(msg) do
          assert_have_tag('<br>', 'brr')
        end
      end

      describe 'a basic <hr...> tag' do
        it 'with a class attribute' do
          assert_no_error { assert_have_tag('<hr class="divider">', 'hr[class]') }
        end

        it 'with a class attribute with an incorrectly expected' do
          msg = [
            'Expected "<hr class=\"divider\">" to have tag ["hr[classs]"],',
            ' but no such tag was found'
          ].join
          assert_returns_error(msg) do
            assert_have_tag('<hr class="divider">', 'hr[classs]')
          end
        end

        it 'with a class attribute' do
          assert_no_error { assert_have_tag('<hr class="divider">', 'hr[class=divider]') }
        end

        it 'with a class attribute with an incorrectly expected attribute' do
          msg = [
            'Expected "<hr class=\"divider\">" to have tag ["hr[class=divder]"],',
            ' but no such tag was found'
          ].join
          assert_returns_error(msg) do
            assert_have_tag('<hr class="divider">', 'hr[class=divder]')
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
            assert_no_error { assert_have_tag(str, t) }
          end
        end

        it 'with multiple classes' do
          str = '<div id="header" class="row columns"></div>'
          [
            'div[class=\'row columns\']',
            'div#header.row.columns',
            'div[id=header][class=\'row columns\']'
          ].each do |t|
            assert_no_error { assert_have_tag(str, t) }
          end
        end

        it 'with id and class attributes with an incorrectly expected attribute' do
          html = '<div id="header" class="row"></div>'
          msg = [
            'Expected "<div id=\"header\" class=\"row\"></div>" to have tag ["TAG"], ',
            'but no such tag was found'
          ].join

          ['div#headers', 'div#headers.rows'].each do |t|
            assert_returns_error(msg.sub('TAG', t)) { assert_have_tag(html, t) }
          end
        end
      end
      # /a basic <div...> tag

      describe 'a basic <label...> tag' do
        it 'with for attribute and nil contents' do
          assert_no_error { assert_have_tag(%(<label for="name">Name:</label>\n), 'label[for=name]', nil) }
        end

        it 'with for attribute and empty contents' do
          assert_no_error { assert_have_tag('<label for="name"></label>', 'label[for=name]', '') }

          msg = [
            'Expected "<label for=\\"name\\">contents</label>" to have tag ["label[for=name]"] ',
            'with contents [""], but the tags content found is [contents]'
          ].join

          assert_returns_error(msg) do
            assert_have_tag('<label for="name">contents</label>', 'label[for=name]', '')
          end
        end

        it 'with for attribute and symbol contents' do
          html = %(<label for="name"></label>\n)

          assert_returns_error(
            /ERROR: contents is neither String nor Regexp, it's \[Symbol\]/
          ) do
            assert_have_tag(html, 'label[for=name]', :symbol)
          end
        end

        it 'with inner_html and empty contents' do
          html = %(<label for="name">Username:</label>)

          msg = [
            'Expected "<label for=\"name\">Username:</label>" to have tag ["label[for=name]"] ',
            'with contents [""], but the tags content found is [Username:]'
          ].join
          assert_returns_error(msg) { assert_have_tag(html, 'label[for=name]', '') }
        end

        it 'with for attribute and contents with incorrect expectations' do
          str = %(<label for="name">Name:</label>\n)

          assert_no_error { assert_have_tag(str, 'label[for=name]', 'Name:') }
        end

        it 'with for attribute and Regexp contents' do
          str = %(<label for="name">Username:</label>\n)
          assert_no_error { assert_have_tag(str, 'label[for=name]', /User/) }
          assert_no_error { assert_have_tag(str, 'label[for=name]', /user/i) }
        end

        it 'with for attribute and Regexp contents' do
          str = '<label for="name">Username:</label>'
          msg = [
            'Expected "<label for=\"name\">Username:</label>" to have tag ["label[for=name]"] ',
            'with inner_html [Username:], but did not match Regexp [/Users/]'
          ].join

          assert_returns_error(msg) { assert_have_tag(str, 'label[for=name]', /Users/) }

          assert_returns_error(msg.sub('Regexp [/Users/]', 'Regexp [/users/i]')) do
            assert_have_tag(str, 'label[for=name]', /users/i)
          end
        end
      end
      # /a basic <label...> tag

      it 'multiple tags when searching for contents' do
        html = '<tag>content1</tag><tag>content2</tag>'

        assert_no_error { assert_have_tag(html, 'tag', 'content1') }
        assert_no_error { assert_have_tag(html, 'tag', 'content2') }
      end
    end
    # /handles being passed
  end
  # /#assert_have_tag(:html, :tag)
end
# rubocop:enable Metrics/BlockLength
