require 'spec_helper'
genres = FixtureLoader.init('genres.json')
fixture = FixtureLoader.init('main.json')
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET']
}
client = Napster::Client.new(options)

describe Napster::Models::Genre do
  it 'has a class' do
    expect(Napster::Models::Genre).not_to be nil
  end

  describe '.new' do
    it 'should instantiate without data' do
      genre = Napster::Models::Genre.new({})

      expect(genre.class).to eql(Napster::Models::Genre)
    end

    it 'should instantiate with a client' do
      genre = Napster::Models::Genre.new(client: client)

      expect(genre.class).to eql(Napster::Models::Genre)
    end
  end

  it '#all' do
    genres = client.genres.all
    expect(genres.class).to eql(Array)
    expect(genres.first.class).to eql(Napster::Models::Genre)
  end

  describe '.find' do
    it 'with valid genre id' do
      genre_id = fixture['genre']['id']
      genre = client.genres.find(genre_id)
      expect(genre.class).to eql(Napster::Models::Genre)
    end

    it 'with invalid genre id' do
      genre_id = 'invalid'
      expect { client.genres.find(genre_id) }.to raise_error(ArgumentError)
    end
  end

  it '#top_artists' do
    genre_id = fixture['genre']['id']
    artists = client.genres.find(genre_id).top_artists
    expect(artists.class).to eql(Array)
    expect(artists.first.class).to eql(Napster::Models::Artist)
  end

  it '#top_albums' do
    genre_id = fixture['genre']['id']
    albums = client.genres.find(genre_id).top_albums
    expect(albums.class).to eql(Array)
    expect(albums.first.class).to eql(Napster::Models::Album)
  end

  it '#top_tracks' do
    genre_id = fixture['genre']['id']
    tracks = client.genres.find(genre_id).top_tracks
    expect(tracks.class).to eql(Array)
    expect(tracks.first.class).to eql(Napster::Models::Track)
  end

  it '#new_releases' do
    genre_id = fixture['genre']['id']
    albums = client.genres.find(genre_id).new_releases
    expect(albums.class).to eql(Array)
    expect(albums.first.class).to eql(Napster::Models::Album)
  end
end
