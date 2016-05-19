require 'spec_helper'
fixture = FixtureLoader.init('main.json')
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET']
}
client = Napster::Client.new(options)
playlist_id = fixture['playlist']['id']

describe Napster::Models::Playlist do
  it 'has a class' do
    expect(Napster::Models::Playlist).not_to be nil
  end

  describe '.new' do
    it 'should instantiate without data' do
      playlist = Napster::Models::Playlist.new({})

      expect(playlist.class).to eql(Napster::Models::Playlist)
    end

    it 'should instantiate with a client' do
      playlist = Napster::Models::Playlist.new(client: client)

      expect(playlist.class).to eql(Napster::Models::Playlist)
    end
  end

  it '.playlists_of_the_day' do
    params = { limit: 5, offset: 5 }
    playlists = client.playlists.playlists_of_the_day(params)
    expect(playlists.class).to eql(Array)
    expect(playlists.first.class).to eql(Napster::Models::Playlist)
  end

  it '.featured' do
    params = { limit: 5, offset: 5 }
    playlists = client.playlists.featured(params)
    expect(playlists.class).to eql(Array)
    expect(playlists.first.class).to eql(Napster::Models::Playlist)
  end

  describe '.find' do
    it 'with valid playlist id' do
      playlist = client.playlists.find(playlist_id)
      expect(playlist.class).to eql(Napster::Models::Playlist)
    end

    it 'with invalid playlist id' do
      invalid_playlist_id = 'invalid'
      expect { client.playlists.find(invalid_playlist_id) }
        .to raise_error(ArgumentError)
    end
  end

  it '#tracks' do
    params = { limit: 5, offset: 5 }
    tracks = client.playlists.find(playlist_id).tracks(params)
    expect(tracks.class).to eql(Array)
    expect(tracks.first.class).to eql(Napster::Models::Track)
  end

  it '#tags' do
    tags = client.playlists.find(playlist_id).tags
    expect(tags.class).to eql(Array)
    expect(tags.first.class).to eql(Napster::Models::Tag)
  end
end
