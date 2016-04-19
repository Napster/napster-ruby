require 'spec_helper'
fixture = FixtureLoader.init('main.json')
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET']
}
client = Napster::Client.new(options)

describe Napster::Resources::Metadata::AlbumsResource do
  it 'has a class' do
    expect(Napster::Resources::Metadata::AlbumsResource).not_to be nil
  end

  describe '.new' do
    it 'should respond to albums' do
      options = {
        api_key: config_variables['API_KEY'],
        api_secret: config_variables['API_SECRET']
      }

      client = Napster::Client.new(options)
      expect(client).to respond_to('albums')
    end
  end

  it '#new_releases' do
    albums = client.albums.new_releases
    expect(albums.class).to eql(Napster::Resources::Metadata::AlbumsResource)
    expect(albums.data.class).to eql(Array)
    expect(albums.data.first.class).to eql(Napster::Models::Album)
  end

  it '#top' do
    albums = client.albums.top
    expect(albums.class).to eql(Napster::Resources::Metadata::AlbumsResource)
    expect(albums.data.class).to eql(Array)
    expect(albums.data.first.class).to eql(Napster::Models::Album)
  end

  describe '#find' do
    it 'by id' do
      album_id = fixture['album']['id']
      album = client.albums.find(album_id)
      expect(album.class).to eql(Napster::Resources::Metadata::AlbumsResource)
      expect(album.data.class).to eql(Napster::Models::Album)
    end

    it 'by name' do
      album_name = fixture['album']['name']
      album = client.albums.find(album_name)
      expect(album.class).to eql(Napster::Resources::Metadata::AlbumsResource)
      expect(album.data.class).to eql(Napster::Models::Album)
    end
  end

  it 'album.tracks' do
    album_id = fixture['album']['id']
    tracks = client.albums.find(album_id).tracks
    expect(tracks.class).to eql(Napster::Resources::Metadata::AlbumsResource)
    expect(tracks.data.class).to eql(Array)
    expect(tracks.data.first.class).to eql(Napster::Models::Track)
  end

  it 'album.similar' do
    album_id = fixture['album']['id']
    albums = client.albums.find(album_id).similar
    expect(albums.class).to eql(Napster::Resources::Metadata::AlbumsResource)
    expect(albums.data.class).to eql(Array)
    expect(albums.data.first.class).to eql(Napster::Models::Album)
  end
end
