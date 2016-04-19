require 'spec_helper'
playlists = FixtureLoader.init('playlists.json')

describe Napster::Models::Playlist do
  it 'has a class' do
    expect(Napster::Models::Playlist).not_to be nil
  end

  describe '.new' do
    it 'should instantiate' do
      playlist = Napster::Models::Playlist.new({})

      Napster::Models::Playlist::ATTRIBUTES.each do |attr|
        expect(playlist).to respond_to(attr)
      end
    end

    it 'should assign values' do
      playlist = Napster::Models::Playlist.new(playlists['playlists'].first)

      expect(playlist.type).to eql('playlist')
    end
  end
end
