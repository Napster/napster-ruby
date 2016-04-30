require 'spec_helper'
fixture = FixtureLoader.init('main.json')
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET']
}
client = Napster::Client.new(options)
member_guid = fixture['member']['guid']

describe Napster::Models::Member do
  it 'has a class' do
    expect(Napster::Models::Member).not_to be nil
  end

  describe '.new' do
    it 'should instantiate without data' do
      member = Napster::Models::Member.new({})

      expect(member.class).to eql(Napster::Models::Member)
    end

    it 'should instantiate with a client' do
      member = Napster::Models::Member.new(client: client)

      expect(member.class).to eql(Napster::Models::Member)
    end
  end

  describe '.find' do
    it 'with guid' do
      member = client.members.find(member_guid)
      expect(member.class).to eql(Napster::Models::Member)
    end

    it 'with screenname' do
      member_screen_name = fixture['member']['screen_name']
      member = client.members.find(member_screen_name)
      expect(member.class).to eql(Napster::Models::Member)
    end
  end

  describe '#screenname_available?' do
    it 'is not available' do
      member_screen_name = fixture['member']['screen_name']
      expected = client.members.screenname_available?(member_screen_name)
      expect(expected).to eql(false)
    end

    it 'is available' do
      member_screen_name = 'this-does-not-exist-12345'
      expected = client.members.screenname_available?(member_screen_name)
      expect(expected).to eql(false)
    end
  end

  it 'member.playlists' do
    params = {
      limit: 3,
      offset: 0
    }
    playlists = client.members.find(member_guid).playlists(params)
    expect(playlists.class).to eql(Array)
    expect(playlists.first.class).to eql(Napster::Models::Playlist)
  end

  it 'member.playlists_for' do
    params = {
      limit: 3,
      offset: 0
    }
    playlists = client.members.playlists_for(member_guid, params)
    expect(playlists.class).to eql(Array)
    expect(playlists.first.class).to eql(Napster::Models::Playlist)
  end

  it 'member.favorites' do
    params = {
      limit: 3,
      offset: 0
    }
    favoites = client.members.find(member_guid).favorites(params)
    expect(favoites.class).to eql(Array)
    expect(favoites.first.class).to eql(Napster::Models::Favorite)
  end

  it 'member.favorites_for' do
    params = {
      limit: 3,
      offset: 0
    }
    favoites = client.members.favorites_for(member_guid, params)
    expect(favoites.class).to eql(Array)
    expect(favoites.first.class).to eql(Napster::Models::Favorite)
  end

  it 'member.favorite_playlists' do
    params = {
      limit: 3,
      offset: 0
    }
    playlists = client.members.find(member_guid).favorite_playlists(params)
    expect(playlists.class).to eql(Array)
    expect(playlists.first.class).to eql(Napster::Models::Playlist)
  end

  it 'member.favorite_playlists_for' do
    params = {
      limit: 3,
      offset: 0
    }
    playlists = client.members.favorite_playlists_for(member_guid, params)
    expect(playlists.class).to eql(Array)
    expect(playlists.first.class).to eql(Napster::Models::Playlist)
  end
end
