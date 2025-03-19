# frozen_string_literal: true

# Use this when using `bundle exec ...`
require 'spec_helper'

# Use this when using `rake spec` (without bundle)
# require_relative '../../spec_helper'

describe 'Minitest' do
  describe '::HaveTag' do
    describe '::VERSION' do
      it 'has a version number' do
        _(Minitest::HaveTag::VERSION).wont_be_nil
      end

      it 'returns a string value' do
        _(Minitest::HaveTag::VERSION).must_be_kind_of(String)
      end

      it 'returns a string matching 0.1.0' do
        _(Minitest::HaveTag::VERSION).must_match(/\d+\.\d+\.\d+$/)
      end
    end
    # /::VERSION
  end
  # /::HaveTag
end
