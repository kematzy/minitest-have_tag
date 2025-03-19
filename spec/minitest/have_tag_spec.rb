# frozen_string_literal: false

# Use this when using `bundle exec ...`
require 'spec_helper'

# Use this when using `rake spec` (without bundle)
# require_relative '../spec_helper'

describe 'Minitest' do
  describe '::Assertions' do
    describe 'private methods' do
      # Create a test class that includes the Assertions
      let(:klass) do
        Class.new do
          include Minitest::Assertions

          # Make private methods public for testing
          public :have_tag_build_message, :have_tag_check_contents, :have_tag_check_string_contents,
                 :have_tag_check_regexp_contents, :have_tag_ensure_nokogiri_document,
                 :have_tag_nokogiri_document?
        end
      end

      before do
        @instance = klass.new
      end

      describe '#have_tag_build_message' do
        it 'builds a basic message for assertion' do
          msg = @instance.have_tag_build_message(nil, '<p>test</p>', 'p')

          _(msg).must_equal('Expected "<p>test</p>" to have tag "p"')
        end

        it 'builds a message for refutation' do
          msg = @instance.have_tag_build_message(nil, '<p>test</p>', 'p', refute: true)

          _(msg).must_equal('Expected "<p>test</p>" to NOT have tag "p"')
        end

        it 'includes custom message when provided' do
          msg = @instance.have_tag_build_message('Custom message', '<p>test</p>', 'p')

          _(msg).must_match(/^Custom message/)
        end

        it 'formats Nokogiri document properly' do
          doc = Nokogiri::HTML('<p>test</p>')
          msg = @instance.have_tag_build_message(nil, doc, 'p')

          _(msg).must_equal('Expected [Nokogiri Document] to have tag "p"')
        end
      end

      describe '#have_tag_check_contents' do
        it 'returns true when no contents are specified' do
          nodeset = Nokogiri::HTML('<p>test</p>').css('p')

          assert @instance.have_tag_check_contents(nodeset, nil, '')
        end

        it 'delegates to check_string_contents for string contents' do
          nodeset = Nokogiri::HTML('<p>test</p>').css('p')

          assert @instance.have_tag_check_contents(nodeset, 'test', '')
        end

        it 'delegates to check_regexp_contents for regexp contents' do
          nodeset = Nokogiri::HTML('<p>test</p>').css('p')

          assert @instance.have_tag_check_contents(nodeset, /test/, '')
        end

        it 'returns false for invalid content types' do
          nodeset = Nokogiri::HTML('<p>test</p>').css('p')
          msg = ''

          refute @instance.have_tag_check_contents(nodeset, 123, msg)
          assert_match(/ERROR: contents is neither String nor Regexp/, msg)
        end
      end

      describe '#have_tag_check_string_contents' do
        it 'returns true when string matches exactly' do
          nodeset = Nokogiri::HTML('<p>test</p>').css('p')

          assert @instance.have_tag_check_string_contents(nodeset, 'test', '')
        end

        it "returns false with error message when string doesn't match" do
          nodeset = Nokogiri::HTML('<p>test</p>').css('p')
          msg = ''

          refute @instance.have_tag_check_string_contents(nodeset, 'different', msg)
          assert_match(/but found \[test\]/, msg)
        end
      end

      describe '#have_tag_check_regexp_contents' do
        it 'returns true when regexp matches' do
          nodeset = Nokogiri::HTML('<p>test123</p>').css('p')
          msg = ''

          assert @instance.have_tag_check_regexp_contents(nodeset, /test\d+/, msg)
        end

        it "returns false with error message when regexp doesn't match" do
          nodeset = Nokogiri::HTML('<p>test</p>').css('p')
          msg = ''

          refute @instance.have_tag_check_regexp_contents(nodeset, /different/, msg)
          assert_match(/did not match Regexp/, msg)
        end
      end

      describe '#have_tag_ensure_nokogiri_document' do
        it 'returns the document when already a Nokogiri document' do
          doc = Nokogiri::HTML('<p>test</p>')

          _(@instance.have_tag_ensure_nokogiri_document(doc)).must_equal(doc)
        end

        it 'creates a Nokogiri document from an HTML string' do
          res = @instance.have_tag_ensure_nokogiri_document('<p>test</p>')

          _(res).must_be_instance_of(Nokogiri::HTML::Document)
          _(res.css('p').length).must_equal(1)
        end
      end

      describe '#have_tag_nokogiri_document?' do
        it 'returns true for HTML documents' do
          doc = Nokogiri::HTML('<p>test</p>')

          assert @instance.have_tag_nokogiri_document?(doc)
        end

        it 'returns true for XML documents' do
          doc = Nokogiri::XML('<p>test</p>')

          assert @instance.have_tag_nokogiri_document?(doc)
        end

        it 'returns false for strings' do
          refute @instance.have_tag_nokogiri_document?('<p>test</p>')
        end

        it 'returns false for other objects' do
          refute @instance.have_tag_nokogiri_document?(123)
          refute @instance.have_tag_nokogiri_document?([])
          refute @instance.have_tag_nokogiri_document?({})
        end
      end
    end
    # /private methods
  end
  # /::Assertions
end
