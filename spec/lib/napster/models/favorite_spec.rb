require 'spec_helper'
fixture = FixtureLoader.init('main.json')
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET']
}
client = Napster::Client.new(options)
album_id = fixture['album']['id']
artist_id = fixture['artist']['id']

describe Napster::Models::Favorite do
  it 'has a class' do
    expect(Napster::Models::Favorite).not_to be nil
  end

  describe '.new' do
    it 'should instantiate without data' do
      tag = Napster::Models::Favorite.new({})

      expect(tag.class).to eql(Napster::Models::Favorite)
    end

    it 'should instantiate with a client' do
      tag = Napster::Models::Favorite.new(client: client)

      expect(tag.class).to eql(Napster::Models::Favorite)
    end
  end

  it '#members_who_favorited_albums' do
    members = client.favorites.members_who_favorited_albums(album_id)
    expect(members.class).to eql(Array)
    expect(members.first.class).to eql(Napster::Models::Member)
  end

  it '#members_who_favorited_artists' do
    members = client.favorites.members_who_favorited_artists(artist_id)
    expect(members.class).to eql(Array)
    expect(members.first.class).to eql(Napster::Models::Member)
  end

  it 'favorite.member_favorites_for' do
    members = client.favorites.member_favorites_for(album_id)
    expect(members.class).to eql(Array)
    expect(members.first.class).to eql(Napster::Models::Member)
  end
end
