require 'spec_helper'
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']

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
    options = {
      api_key: config_variables['API_KEY'],
      api_secret: config_variables['API_SECRET']
    }

    client = Napster::Client.new(options)
    artists = client.artists.top
    expect(artists.class).to eql(Array)
    expect(artists.first.class).to eql(Napster::Models::Artist)
  end
end
