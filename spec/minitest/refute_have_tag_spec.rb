# frozen_string_literal: true

require_relative '../spec_helper'

# rubocop:disable Metrics/BlockLength
describe Minitest::Assertions do
  describe '#refute_have_tag(:html, :tag)' do
    describe 'handles being passed' do
      it 'a nil value' do
        assert_no_error { refute_have_tag(nil, 'br') }
      end

      it 'an empty string value' do
        assert_no_error { refute_have_tag(nil, 'br') }
      end

      it 'a basic <br> tag' do
        msg = 'Expected "<br>" to NOT have tag ["br"], but such a tag was found'
        assert_returns_error(msg) { refute_have_tag('<br>', 'br') }
      end

      it 'an incorrectly expected tag' do
        assert_no_error { refute_have_tag('<br>', 'brr') }
      end

      describe 'a basic <hr...> tag' do
        it 'with a class attribute' do
        end

        it 'with a class attribute with an incorrectly expected' do
          assert_no_error { refute_have_tag('<hr class="divider">', 'hr[classs]') }
        end

        it 'with a class attribute' do
          msg = [
            'Expected "<hr class=\\"divider\\">" to NOT have tag ["hr[class=divider]"],',
            ' but such a tag was found'
          ].join
          assert_returns_error(msg) do
            refute_have_tag('<hr class="divider">', 'hr[class=divider]')
          end
        end

        it 'with a class attribute with an incorrectly expected attribute' do
          assert_no_error { refute_have_tag('<hr class="divider">', 'hr[class=divder]') }
        end
      end
      # /a basic <hr...> tag

      describe 'a basic <div...> tag' do
        it 'with id and class attributes' do
          str = '<div id="header" class="row"></div>'
          msg = [
            'Expected "<div id=\"header\" class=\"row\"></div>" to NOT have tag ',
            '["TAG"], but such a tag was found'
          ].join

          [
            'div#header',
            'div[id=header]',
            'div.row',
            'div[class=row]',
            'div#header.row',
            'div[id=header][class=row]'
          ].each do |t|
            assert_returns_error(msg.sub('TAG', t)) { refute_have_tag(str, t) }
          end
        end

        it 'with multiple classes' do
          str = '<div id="header" class="row columns"></div>'
          msg = [
            'Expected "<div id=\"header\" class=\"row columns\"></div>" to NOT have tag',
            ' ["TAG"], but such a tag was found'
          ].join

          [
            'div[class=\'row columns\']',
            'div#header.row.columns',
            'div[id=header][class=\'row columns\']'
          ].each do |t|
            assert_returns_error(msg.sub('TAG', t)) do
              refute_have_tag(str, t)
            end
          end
        end

        it 'with id and class attributes with an incorrectly expected attribute' do
          html = '<div id="header" class="row"></div>'

          assert_no_error { refute_have_tag(html, 'div#headers') }
          assert_no_error { refute_have_tag(html, 'div#header.rows') }
        end
      end
      # /a basic <div...> tag

      describe 'a basic <label...> tag' do
        it 'with for attribute and nil contents' do
          assert_returns_error(
            /to NOT have tag \["label\[for=name\]"\], but such a tag was found/
          ) do
            refute_have_tag('<label for="name">Name:</label>', 'label[for=name]', nil)
          end
        end

        it 'with inner_html and empty contents' do
          html = %(<label for="name">Username:</label>)
          assert_no_error { refute_have_tag(html, 'label[for=name]', '') }
        end

        it 'with for attribute and empty contents' do
          assert_returns_error(
            /to NOT have tag \["label\[for=name\]"\], but such a tag was found/
          ) do
            refute_have_tag('<label for="name"></label>', 'label[for=name]', '')
          end

          assert_no_error do
            refute_have_tag('<label for="name">contents</label>', 'label[for=name]', '')
          end
        end

        it 'with for attribute and contents' do
          html = %(<label for="name">Name:</label>)
          msg = [
            'Expected "<label for=\"name\">Name:</label>" to NOT have tag ',
            '["label[for=name]"], but such a tag was found'
          ].join

          assert_returns_error(msg) { refute_have_tag(html, 'label[for=name]', 'Name:') }

          html = %(<label for="name">User Name:</label>)
          msg = [
            'Expected "<label for=\"name\">User Name:</label>" to NOT have tag ',
            '["label[for=name]"], but such a tag was found'
          ].join

          assert_returns_error(msg) { refute_have_tag(html, 'label[for=name]', 'User Name:') }
        end

        it 'with for attribute and symbol contents' do
          html = %(<label for="name"></label>\n)

          assert_no_error { refute_have_tag(html, 'label[for=name]', :symbol) }
        end

        it 'with for attribute and contents with incorrect expectations' do
          str = %(<label for="name">Name:</label>\n)
          msg = [
            'Expected "<label for=\\"name\\">Name:</label>\n" to NOT have tag ',
            '["label[for=name]"], but such a tag was found'
          ].join

          assert_returns_error(msg) { refute_have_tag(str, 'label[for=name]', 'Name:') }
        end

        it 'with for attribute and Regexp contents' do
          str = %(<label for="name">Username:</label>\n)
          msg = [
            'Expected "<label for=\\"name\\">Username:</label>\n" to NOT have tag',
            ' ["label[for=name]"], but such a tag was found'
          ].join

          assert_returns_error(msg) { refute_have_tag(str, 'label[for=name]', /User/) }
          assert_returns_error(msg) { refute_have_tag(str, 'label[for=name]', /user/i) }
        end

        it 'with for attribute and Regexp contents' do
          str = '<label for="name">Username:</label>'

          assert_no_error { refute_have_tag(str, 'label[for=name]', /Users/) }
          assert_no_error { refute_have_tag(str, 'label[for=name]', /users/i) }
        end
      end
      # /a basic <label...> tag
    end
    # /handles being passed
  end
  # /#refute_have_tag(:html, :tag)
end
# rubocop:enable Metrics/BlockLength
