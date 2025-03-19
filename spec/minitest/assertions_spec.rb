# frozen_string_literal: false

# Use this when using `bundle exec ...`
require 'spec_helper'

# Use this when using `rake spec` (without bundle)
# require_relative '../../spec_helper'

describe 'Minitest' do
  describe '::Assertions' do
    describe '#assert_have_tag(:html, :tag)' do
      describe 'basic validation' do
        # Edge cases
        it 'handles nil values' do
          assert_returns_error('Expected nil to have tag "br", but no such tag was found') do
            assert_have_tag(nil, 'br')
          end
        end

        it 'handles empty strings' do
          assert_returns_error('Expected " " to have tag "br", but no such tag was found') do
            assert_have_tag(' ', 'br')
          end
        end

        # Basic tag assertions
        it 'validates the presence of simple tags' do
          assert_no_error { assert_have_tag('<br>', 'br') }
        end

        it 'reports when expected tags are not found' do
          msg = 'Expected "<br>" to have tag "brr", but no such tag was found'
          assert_returns_error(msg) do
            assert_have_tag('<br>', 'brr')
          end
        end
      end

      describe 'tag attributes' do
        describe 'simple attribute validation' do
          it 'validates tags with class attributes' do
            assert_no_error { assert_have_tag('<hr class="divider">', 'hr[class]') }
            assert_no_error { assert_have_tag('<hr class="divider">', 'hr[class=divider]') }
          end

          it 'reports when expected attributes are not found' do
            msg = [
              'Expected "<hr class=\"divider\">" to have tag "hr[classs]", ',
              'but no such tag was found'
            ].join

            assert_returns_error(msg) do
              assert_have_tag('<hr class="divider">', 'hr[classs]')
            end

            msg = [
              'Expected "<hr class=\"divider\">" to have tag "hr[class=divder]", ',
              'but no such tag was found'
            ].join

            assert_returns_error(msg) do
              assert_have_tag('<hr class="divider">', 'hr[class=divder]')
            end
          end
        end

        describe 'complex attribute validation' do
          it 'validates tags with id and class attributes' do
            html = '<div id="header" class="row"></div>'

            selectors = [
              'div#header',
              'div[id=header]',
              'div.row',
              'div[class=row]',
              'div#header.row',
              'div[id=header][class=row]'
            ]

            selectors.each do |selector|
              assert_no_error { assert_have_tag(html, selector) }
            end
          end

          it 'validates tags with multiple class values' do
            html = '<div id="header" class="row columns"></div>'

            selectors = [
              'div[class=\'row columns\']',
              'div#header.row.columns',
              'div[id=header][class=\'row columns\']'
            ]

            selectors.each do |selector|
              assert_no_error { assert_have_tag(html, selector) }
            end
          end

          it 'reports when expected complex attributes are not found' do
            html = '<div id="header" class="row"></div>'
            msg = [
              'Expected "<div id=\"header\" class=\"row\"></div>" to have tag ',
              '"TAG", but no such tag was found'
            ].join

            ['div#headers', 'div#headers.rows'].each do |selector|
              assert_returns_error(msg.sub('TAG', selector)) do
                assert_have_tag(html, selector)
              end
            end
          end
        end
      end

      describe 'tag contents' do
        describe 'string content validation' do
          it 'validates tags with specific content' do
            assert_no_error do
              assert_have_tag('<label for="name">Name:</label>', 'label[for=name]', 'Name:')
            end
          end

          it 'handles nil content appropriately' do
            assert_no_error do
              assert_have_tag(%(<label for="name">Name:</label>\n), 'label[for=name]', nil)
            end
          end

          it 'handles empty content validation' do
            assert_no_error do
              assert_have_tag('<label for="name"></label>', 'label[for=name]', '')
            end

            msg = [
              'Expected "<label for=\\"name\\">contents</label>" to have tag ',
              '"label[for=name]" with expected contents [""], but found [contents]'
            ].join

            assert_returns_error(msg) do
              assert_have_tag('<label for="name">contents</label>', 'label[for=name]', '')
            end
          end

          it 'reports when expected content is not found' do
            html = %(<label for="name">Username:</label>)

            msg = [
              'Expected "<label for=\"name\">Username:</label>" to have tag ',
              '"label[for=name]" with expected contents [""], but found [Username:]'
            ].join

            assert_returns_error(msg) { assert_have_tag(html, 'label[for=name]', '') }
          end

          it 'properly handles non-string/non-regex content parameters' do
            html = %(<label for="name"></label>\n)

            msg = /ERROR: contents is neither String nor Regexp, it's \[Symbol\]/
            assert_returns_error(msg) do
              assert_have_tag(html, 'label[for=name]', :symbol)
            end
          end
        end

        describe 'regex content validation' do
          it 'validates content matching regex patterns' do
            html = %(<label for="name">Username:</label>\n)

            assert_no_error { assert_have_tag(html, 'label[for=name]', /User/) }
            assert_no_error { assert_have_tag(html, 'label[for=name]', /user/i) }
          end

          it 'reports when content does not match regex pattern' do
            html = '<label for="name">Username:</label>'

            msg = [
              'Expected "<label for=\"name\">Username:</label>" to have tag ',
              '"label[for=name]" with contents [Username:], but did not match Regexp'
            ].join

            assert_returns_error("#{msg} [/Users/]") do
              assert_have_tag(html, 'label[for=name]', /Users/)
            end

            assert_returns_error("#{msg} [/users/i]") do
              assert_have_tag(html, 'label[for=name]', /users/i)
            end
          end
        end

        it 'finds content in multiple matching tags' do
          html = '<tag>content1</tag><tag>content2</tag>'

          assert_no_error { assert_have_tag(html, 'tag', 'content1') }
          assert_no_error { assert_have_tag(html, 'tag', 'content2') }
        end
      end
    end
    # /#assert_have_tag(:html, :tag)

  end
  # /::Assertions
end
