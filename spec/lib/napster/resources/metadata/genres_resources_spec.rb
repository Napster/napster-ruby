require 'spec_helper'
fixture = FixtureLoader.init('main.json')
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET']
}
client = Napster::Client.new(options)

describe Napster::Resources::Metadata::GenresResource do
  it 'has a class' do
    expect(Napster::Resources::Metadata::GenresResource).not_to be nil
  end

  describe '.new' do
    it 'should respond to genres' do
      options = {
        api_key: config_variables['API_KEY'],
        api_secret: config_variables['API_SECRET']
      }

      client = Napster::Client.new(options)
      expect(client).to respond_to('genres')
    end
  end

  it '#all' do
    genres = client.genres.all
    expect(genres.class).to eql(Napster::Resources::Metadata::GenresResource)
    expect(genres.data.class).to eql(Array)
    expect(genres.data.first.class).to eql(Napster::Models::Genre)
  end

  describe '.find' do
    it 'with valid genre id' do
      genre_id = fixture['genre']['id']
      genre = client.genres.find(genre_id)
      expect(genre.class).to eql(Napster::Resources::Metadata::GenresResource)
      expect(genre.data.class).to eql(Napster::Models::Genre)
    end

    it 'with invalid genre id' do
      genre_id = 'invalid'
      expect { client.genres.find(genre_id) }.to raise_error(ArgumentError)
    end
  end

  it '#top_artists' do
    genre_id = fixture['genre']['id']
    artists = client.genres.find(genre_id).top_artists
    expect(artists.class).to eql(Napster::Resources::Metadata::GenresResource)
    expect(artists.data.class).to eql(Array)
    expect(artists.data.first.class).to eql(Napster::Models::Artist)
  end

  it '#top_albums' do
    genre_id = fixture['genre']['id']
    albums = client.genres.find(genre_id).top_albums
    expect(albums.class).to eql(Napster::Resources::Metadata::GenresResource)
    expect(albums.data.class).to eql(Array)
    expect(albums.data.first.class).to eql(Napster::Models::Album)
  end

  it '#top_tracks' do
    genre_id = fixture['genre']['id']
    tracks = client.genres.find(genre_id).top_tracks
    expect(tracks.class).to eql(Napster::Resources::Metadata::GenresResource)
    expect(tracks.data.class).to eql(Array)
    expect(tracks.data.first.class).to eql(Napster::Models::Track)
  end

  it '#new_releases' do
    genre_id = fixture['genre']['id']
    albums = client.genres.find(genre_id).new_releases
    expect(albums.class).to eql(Napster::Resources::Metadata::GenresResource)
    expect(albums.data.class).to eql(Array)
    expect(albums.data.first.class).to eql(Napster::Models::Album)
  end
end
