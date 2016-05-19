require 'spec_helper'
fixture = FixtureLoader.init('main.json')
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET']
}
client = Napster::Client.new(options)
album_id = fixture['album']['id']

describe Napster::Models::Album do
  it 'has a class' do
    expect(Napster::Models::Album).not_to be nil
  end

  describe '.new' do
    it 'should instantiate without data' do
      album = Napster::Models::Album.new({})

      expect(album.class).to eql(Napster::Models::Album)
    end

    it 'should instantiate with a client' do
      album = Napster::Models::Album.new(client: client)

      expect(album.class).to eql(Napster::Models::Album)
    end
  end

  it '#new_releases' do
    params = { limit: 5, offset: 5 }
    albums = client.albums.new_releases(params)
    expect(albums.class).to eql(Array)
    expect(albums.first.class).to eql(Napster::Models::Album)
  end

  it '#staff_picks' do
    params = { limit: 5, offset: 5 }
    albums = client.albums.staff_picks(params)
    expect(albums.class).to eql(Array)
    expect(albums.first.class).to eql(Napster::Models::Album)
  end

  it '#top' do
    params = { limit: 5, offset: 5 }
    albums = client.albums.top(params)
    expect(albums.class).to eql(Array)
    expect(albums.first.class).to eql(Napster::Models::Album)
  end

  describe '#find' do
    it 'by id' do
      album = client.albums.find(album_id)
      expect(album.class).to eql(Napster::Models::Album)
    end

    it 'by name' do
      album_name = fixture['album']['name']
      album = client.albums.find(album_name)
      expect(album.class).to eql(Napster::Models::Album)
    end
  end

  it 'album.tracks' do
    params = { limit: 5, offset: 5 }
    tracks = client.albums.find(album_id).tracks(params)
    expect(tracks.class).to eql(Array)
    expect(tracks.first.class).to eql(Napster::Models::Track)
  end
end
