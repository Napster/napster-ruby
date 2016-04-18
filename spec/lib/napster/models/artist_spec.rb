require 'spec_helper'
artists_top = FixtureLoader.init('artists_top.json')

describe Napster::Models::Artist do
  it 'has a class' do
    expect(Napster::Models::Artist).not_to be nil
  end

  describe '.new' do
    it 'should instantiate' do
      artist = Napster::Models::Artist.new({})

      Napster::Models::Artist::ATTRIBUTES.each do |attr|
        expect(artist).to respond_to(attr)
      end
    end

    it 'should assign values' do
      artist = Napster::Models::Artist.new(artists_top['artists'].first)

      expect(artist.type).to eql('artist')
    end
  end
end
