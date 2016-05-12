require 'spec_helper'
fixture = FixtureLoader.init('main.json')
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET'],
  username: config_variables['USERNAME'],
  password: config_variables['PASSWORD']
}
client = Napster::Client.new(options)
client.authenticate(:password_grant)
album_id = fixture['album']['id']
artist_id = fixture['artist']['id']
track_id = fixture['track']['id']

describe Napster::Me do
  it 'has a class' do
    expect(Napster::Me).not_to be nil
  end

  describe '.profile' do
    it '#get' do
      profile = client.me.profile.get

      expect(profile.class).to eql(Napster::Models::Profile)
    end

    it '#update' do
      body = {
        'me' => {
          'bio' => Faker::Lorem.word
        }
      }
      client.me.profile.update(body)
      profile = client.me.profile.get

      expect(profile.bio).to eql(body['me']['bio'])
    end
  end

  describe '.favorites' do
    it '#get' do
      params = {
        limit: 10
      }
      favorites = client.me.favorites.get(params)

      expect(favorites.class).to eql(Array)
      expect(favorites.first.class).to eql(Napster::Models::Favorite)
    end

    it '#status' do
      ids = [album_id, artist_id, track_id]
      favorite_statuses = client.me.favorites.status(ids)

      expect(favorite_statuses.class).to eql(Array)
      expect(favorite_statuses.first.class)
        .to eql(Napster::Models::FavoriteStatus)
    end

    it '#add' do
      ids = [album_id, artist_id, track_id]
      favorite_statuses = client.me.favorites.add(ids)

      expect(favorite_statuses.class).to eql(Array)
      expect(favorite_statuses.first.class)
        .to eql(Napster::Models::FavoriteStatus)
    end

    it 'remove' do
      ids = [album_id, artist_id, track_id]
      ids.each do |id|
        favorite_status = client.me.favorites.remove(id)
        expect(favorite_status.first.class)
          .to eql(Napster::Models::FavoriteStatus)
      end
    end
  end

  it '.listening_history' do
    params = {
      limit: 10
    }
    tracks = client.me.listening_history(params)

    expect(tracks.class).to eql(Array)
    expect(tracks.first.class).to eql(Napster::Models::Track)
  end
end
