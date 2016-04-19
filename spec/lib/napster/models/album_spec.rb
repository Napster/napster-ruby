require 'spec_helper'
albums_top = FixtureLoader.init('albums_top.json')

describe Napster::Models::Album do
  it 'has a class' do
    expect(Napster::Models::Album).not_to be nil
  end

  describe '.new' do
    it 'should instantiate' do
      album = Napster::Models::Album.new({})

      Napster::Models::Album::ATTRIBUTES.each do |attr|
        expect(album).to respond_to(attr.to_s)
      end
    end

    it 'should assign values' do
      album = Napster::Models::Album.new(albums_top['albums'].first)
      expect(album.type).to eql('album')
    end
  end
end
