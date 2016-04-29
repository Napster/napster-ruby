require 'spec_helper'
fixture = FixtureLoader.init('main.json')
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET']
}
client = Napster::Client.new(options)
station_id = fixture['station']['id']

describe Napster::Models::Station do
  it 'has a class' do
    expect(Napster::Models::Station).not_to be nil
  end

  describe '.new' do
    it 'should instantiate without data' do
      station = Napster::Models::Station.new({})

      expect(station.class).to eql(Napster::Models::Station)
    end

    it 'should instantiate with a client' do
      station = Napster::Models::Station.new(client: client)

      expect(station.class).to eql(Napster::Models::Station)
    end
  end

  it '#top' do
    stations = client.stations.top
    expect(stations.class).to eql(Array)
    expect(stations.first.class).to eql(Napster::Models::Station)
  end

  it '#decade' do
    stations = client.stations.decade
    expect(stations.class).to eql(Array)
    expect(stations.first.class).to eql(Napster::Models::Station)
  end

  describe '#find' do
    it 'with valid playlist id' do
      station = client.stations.find(station_id)
      expect(station.class).to eql(Napster::Models::Station)
    end

    it 'with invalid playlist id' do
      invalid_playlist_id = 'invalid'
      expect { client.stations.find(invalid_playlist_id) }
        .to raise_error(ArgumentError)
    end
  end
end
