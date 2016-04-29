require 'spec_helper'
fixture = FixtureLoader.init('main.json')
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET']
}
client = Napster::Client.new(options)
tag = fixture['tag']['id']

describe Napster::Models::Tag do
  it 'has a class' do
    expect(Napster::Models::Tag).not_to be nil
  end

  describe '.new' do
    it 'should instantiate without data' do
      tag = Napster::Models::Tag.new({})

      expect(tag.class).to eql(Napster::Models::Tag)
    end

    it 'should instantiate with a client' do
      tag = Napster::Models::Tag.new(client: client)

      expect(tag.class).to eql(Napster::Models::Tag)
    end
  end
end
