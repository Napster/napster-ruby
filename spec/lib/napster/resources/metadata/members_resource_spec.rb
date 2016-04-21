require 'spec_helper'
fixture = FixtureLoader.init('main.json')
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET']
}
client = Napster::Client.new(options)

describe Napster::Resources::Metadata::MembersResource do
  it 'has a class' do
    expect(Napster::Resources::Metadata::MembersResource).not_to be nil
  end

  describe '.new' do
    it 'should respond to members' do
      expect(client).to respond_to('members')
    end
  end

  describe '.find' do
    it 'with guid' do
      member_guid = fixture['member']['guid']
      member = client.members.find(member_guid)
      expect(member.class).to eql(Napster::Resources::Metadata::MembersResource)
      expect(member.data.class).to eql(Napster::Models::Member)
    end

    it 'with screenname' do
      member_screen_name = fixture['member']['screen_name']
      member = client.members.find(member_screen_name)
      expect(member.class).to eql(Napster::Resources::Metadata::MembersResource)
      expect(member.data.class).to eql(Napster::Models::Member)
    end
  end
end
