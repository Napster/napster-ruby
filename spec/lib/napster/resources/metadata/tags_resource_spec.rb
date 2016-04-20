require 'spec_helper'
fixture = FixtureLoader.init('main.json')
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET']
}
client = Napster::Client.new(options)
tag_id = fixture['tag']['id']

describe Napster::Resources::Metadata::TagsResource do
  it 'has a class' do
    expect(Napster::Resources::Metadata::TagsResource).not_to be nil
  end

  describe '.new' do
    it 'should respond to tracks' do
      expect(client).to respond_to('tags')
    end
  end

  it '.all' do
    tags = client.tags.all
    expect(tags.class).to eql(Napster::Resources::Metadata::TagsResource)
    expect(tags.data.class).to eql(Array)
    expect(tags.data.first.class).to eql(Napster::Models::Tag)
  end

  it '.featured' do
    tags = client.tags.featured
    expect(tags.class).to eql(Napster::Resources::Metadata::TagsResource)
    expect(tags.data.class).to eql(Array)
    expect(tags.data.first.class).to eql(Napster::Models::Tag)
  end

  describe '.find' do
    it 'with valid tag id' do
      tag = client.tags.find(tag_id)
      expect(tag.class)
        .to eql(Napster::Resources::Metadata::TagsResource)
      expect(tag.data.class).to eql(Napster::Models::Tag)
    end

    it 'with invalid tag id' do
      invalid_tag_id = 'invalid'
      expect { client.tags.find(invalid_tag_id) }
        .to raise_error(ArgumentError)
    end
  end
end
