require 'spec_helper'
fixture = FixtureLoader.init('main.json')
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET']
}
client = Napster::Client.new(options)
artist_id = fixture['artist']['id']
artist_name = fixture['artist']['name']

describe Napster::Models::Artist do
  it 'has a class' do
    expect(Napster::Models::Artist).not_to be nil
  end

  describe '.new' do
    it 'should instantiate without data' do
      artist = Napster::Models::Artist.new({})

      expect(artist.class).to eql(Napster::Models::Artist)
    end

    it 'should instantiate with a client' do
      artist = Napster::Models::Artist.new(client: client)

      expect(artist.class).to eql(Napster::Models::Artist)
    end
  end

  it '#top' do
    artists = client.artists.top
    expect(artists.class).to eql(Array)
    expect(artists.first.class).to eql(Napster::Models::Artist)
  end

  describe '#find' do
    it 'by id' do
      artist = client.artists.find(artist_id)
      expect(artist.class).to eql(Napster::Models::Artist)
    end

    it 'by name' do
      artist = client.artists.find(artist_name)
      expect(artist.class).to eql(Napster::Models::Artist)
    end
  end

  it '#find_all_by_name' do
    artists = client.artists.find_all_by_name(artist_name)
    expect(artists.class).to eql(Array)
    expect(artists.first.class).to eql(Napster::Models::Artist)
  end

  it 'artist.albums' do
    albums = client.artists.find(artist_id).albums
    expect(albums.class).to eql(Array)
    expect(albums.first.class).to eql(Napster::Models::Album)
  end

  it 'artist.new_albums' do
    albums = client.artists.find(artist_id).new_albums
    expect(albums.class).to eql(Array)
    expect(albums.first.class).to eql(Napster::Models::Album)
  end

  it 'artist.tracks' do
    tracks = client.artists.find(artist_id).tracks
    expect(tracks.class).to eql(Array)
    expect(tracks.first.class).to eql(Napster::Models::Track)
  end

  it 'artist.top_tracks' do
    albums = client.artists.find(artist_id).tracks
    expect(albums.class).to eql(Array)
    expect(albums.first.class).to eql(Napster::Models::Track)
  end
end
