require 'spec_helper'
tracks_top = FixtureLoader.init('tracks_top.json')
require 'spec_helper'
fixture = FixtureLoader.init('main.json')
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET']
}
client = Napster::Client.new(options)

describe Napster::Models::Track do
  it 'has a class' do
    expect(Napster::Models::Track).not_to be nil
  end

  describe '.new' do
    it 'should instantiate without data' do
      track = Napster::Models::Track.new({})

      expect(track.class).to eql(Napster::Models::Track)
    end

    it 'should instantiate with a client' do
      track = Napster::Models::Track.new(client: client)

      expect(track.class).to eql(Napster::Models::Track)
    end
  end

  it '#top' do
    tracks = client.tracks.top
    expect(tracks.class).to eql(Array)
    expect(tracks.first.class).to eql(Napster::Models::Track)
  end

  describe '#find' do
    it 'by id' do
      track_id = fixture['track']['id']
      track = client.tracks.find(track_id)
      expect(track.class).to eql(Napster::Models::Track)
    end

    it 'by name' do
      track_name = fixture['track']['name']
      track = client.tracks.find(track_name)
      expect(track.class).to eql(Napster::Models::Track)
    end
  end

  it '#find_all_by_name' do
    track_name = fixture['track']['name']
    tracks = client.tracks.find_all_by_name(track_name)
    expect(tracks.class).to eql(Array)
    expect(tracks.first.class).to eql(Napster::Models::Track)
  end
end
