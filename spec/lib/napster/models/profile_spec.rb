require 'spec_helper'

describe Napster::Models::Profile do
  it 'has a class' do
    expect(Napster::Models::Profile).not_to be nil
  end

  describe '.new' do
    it 'should instantiate without data' do
      tag = Napster::Models::Profile.new({})

      expect(tag.class).to eql(Napster::Models::Profile)
    end
  end
end
