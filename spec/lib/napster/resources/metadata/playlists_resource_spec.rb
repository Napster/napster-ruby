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

describe Napster::Resources::Metadata::PlaylistsResource do
  it 'has a class' do
    expect(Napster::Resources::Metadata::PlaylistsResource).not_to be nil
  end

  describe '.new' do
    it 'should respond to tracks' do
      options = {
        api_key: config_variables['API_KEY'],
        api_secret: config_variables['API_SECRET']
      }

      client = Napster::Client.new(options)
      expect(client).to respond_to('tracks')
    end
  end

  it '.playlists_of_the_day' do
    playlists = client.playlists.playlists_of_the_day
    expect(playlists.class)
      .to eql(Napster::Resources::Metadata::PlaylistsResource)
    expect(playlists.data.class).to eql(Array)
    expect(playlists.data.first.class).to eql(Napster::Models::Playlist)
  end

  it '.featured' do
    playlists = client.playlists.featured
    expect(playlists.class)
      .to eql(Napster::Resources::Metadata::PlaylistsResource)
    expect(playlists.data.class).to eql(Array)
    expect(playlists.data.first.class).to eql(Napster::Models::Playlist)
  end

  describe '.find' do
    it 'with valid playlist id' do
      playlist = client.playlists.find(playlist_id)
      expect(playlist.class)
        .to eql(Napster::Resources::Metadata::PlaylistsResource)
      expect(playlist.data.class).to eql(Napster::Models::Playlist)
    end

    it 'with invalid playlist id' do
      invalid_playlist_id = 'invalid'
      expect { client.playlists.find(invalid_playlist_id) }
        .to raise_error(ArgumentError)
    end
  end

  it '#tracks' do
    tracks = client.playlists.find(playlist_id).tracks(limit: 5)
    expect(tracks.class).to eql(Napster::Resources::Metadata::PlaylistsResource)
    expect(tracks.data.class).to eql(Array)
    expect(tracks.data.first.class).to eql(Napster::Models::Track)
  end

  it '#tags' do
    tags = client.playlists.find(playlist_id).tags
    expect(tags.class).to eql(Napster::Resources::Metadata::PlaylistsResource)
    expect(tags.data.class).to eql(Array)
    expect(tags.data.first.class).to eql(Napster::Models::Tag)
  end
end
