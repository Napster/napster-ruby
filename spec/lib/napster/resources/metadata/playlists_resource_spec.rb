require 'spec_helper'
fixture = FixtureLoader.init('main.json')
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET']
}
client = Napster::Client.new(options)

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

  it '#playlists_of_the_day' do
    playlists = client.playlists.playlists_of_the_day
    expect(playlists.class).to eql(Napster::Resources::Metadata::PlaylistsResource)
    expect(playlists.data.class).to eql(Array)
    expect(playlists.data.first.class).to eql(Napster::Models::Playlist)
  end
end
