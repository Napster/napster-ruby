require 'spec_helper'
fixture = FixtureLoader.init('main.json')
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET']
}
client = Napster::Client.new(options)

describe Napster::Resources::Metadata::ArtistsResource do
  it 'has a class' do
    expect(Napster::Resources::Metadata::ArtistsResource).not_to be nil
  end

  describe '.new' do
    it 'should respond to artists' do
      options = {
        api_key: config_variables['API_KEY'],
        api_secret: config_variables['API_SECRET']
      }

      client = Napster::Client.new(options)
      expect(client).to respond_to('artists')
    end
  end

  it '#top' do
    artists = client.artists.top
    expect(artists.class).to eql(Napster::Resources::Metadata::ArtistsResource)
    expect(artists.data.class).to eql(Array)
    expect(artists.data.first.class).to eql(Napster::Models::Artist)
  end

  describe '#find' do
    it 'by id' do
      artist_id = fixture['artist']['id']
      artist = client.artists.find(artist_id)
      expect(artist.class).to eql(Napster::Resources::Metadata::ArtistsResource)
      expect(artist.data.class).to eql(Napster::Models::Artist)
    end

    it 'by name' do
      artist_name = fixture['artist']['name']
      artist = client.artists.find(artist_name)
      expect(artist.class).to eql(Napster::Resources::Metadata::ArtistsResource)
      expect(artist.data.class).to eql(Napster::Models::Artist)
    end
  end

  it '#find_all_by_name' do
    artist_name = fixture['artist']['name']
    artists = client.artists.find_all_by_name(artist_name)
    expect(artists.class).to eql(Napster::Resources::Metadata::ArtistsResource)
    expect(artists.data.class).to eql(Array)
    expect(artists.data.first.class).to eql(Napster::Models::Artist)
  end

  it 'artist.albums' do
    artist_id = fixture['artist']['id']
    albums = client.artists.find(artist_id).albums
    expect(albums.class).to eql(Napster::Resources::Metadata::ArtistsResource)
    expect(albums.data.class).to eql(Array)
    expect(albums.data.first.class).to eql(Napster::Models::Album)
  end
end
