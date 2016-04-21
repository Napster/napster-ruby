require 'spec_helper'
member = FixtureLoader.init('member.json')

describe Napster::Models::Member do
  it 'has a class' do
    expect(Napster::Models::Member).not_to be nil
  end

  describe '.new' do
    it 'should instantiate' do
      album = Napster::Models::Member.new({})

      Napster::Models::Member::ATTRIBUTES.each do |attr|
        expect(album).to respond_to(attr.to_s)
      end
    end

    it 'should assign values' do
      member = Napster::Models::Member.new(member['members'].first)
      expect(member.type).to eql('member')
    end
  end
end
