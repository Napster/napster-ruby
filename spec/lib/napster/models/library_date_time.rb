require 'spec_helper'
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET']
}
client = Napster::Client.new(options)

describe Napster::Models::LibraryDateTime do
  it 'has a class' do
    expect(Napster::Models::LibraryDateTime).not_to be nil
  end

  describe '.new' do
    it 'should instantiate without data' do
      tag = Napster::Models::LibraryDateTime.new({})

      expect(tag.class).to eql(Napster::Models::LibraryDateTime)
    end

    it 'should instantiate with a client' do
      tag = Napster::Models::LibraryDateTime.new(client: client)

      expect(tag.class).to eql(Napster::Models::LibraryDateTime)
    end
  end
end
