# frozen_string_literal: true

require_relative '../spec_helper'

describe Minitest::HaveTag do
  it 'has a version number' do
    _(Minitest::HaveTag::VERSION).wont_be_nil
    _(Minitest::HaveTag::VERSION).must_match(/^\d+\.\d+\.\d+$/)
  end
end
