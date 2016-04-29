require 'spec_helper'
fixture = FixtureLoader.init('main.json')
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET']
}
client = Napster::Client.new(options)
radio_id = fixture['radio']['id']

describe Napster::Models::Radio do
  it 'has a class' do
    expect(Napster::Models::Radio).not_to be nil
  end

  describe '.new' do
    it 'should instantiate without data' do
      radio = Napster::Models::Radio.new({})

      expect(radio.class).to eql(Napster::Models::Radio)
    end

    it 'should instantiate with a client' do
      radio = Napster::Models::Radio.new(client: client)

      expect(radio.class).to eql(Napster::Models::Radio)
    end
  end

  it '#featured' do
    radios = client.radios.featured
    expect(radios.class).to eql(Array)
    expect(radios.first.class).to eql(Napster::Models::Radio)
  end

  describe '#find' do
    it 'with valid playlist id' do
      radio = client.radios.find(radio_id)
      expect(radio.class).to eql(Napster::Models::Radio)
    end

    it 'with invalid playlist id' do
      invalid_playlist_id = 'invalid'
      expect { client.stations.find(invalid_playlist_id) }
        .to raise_error(ArgumentError)
    end
  end
end
