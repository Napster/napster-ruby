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
    params = { limit: 10 }
    tracks = client.me.listening_history(params)

    expect(tracks.class).to eql(Array)
    expect(tracks.first.class).to eql(Napster::Models::Track)
  end

  describe '.library' do
    it '.library.artists' do
      params = { limit: 10 }
      artists = client.me.library.artists(params)

      expect(artists.class).to eql(Array)
      expect(artists.first.class).to eql(Napster::Models::Artist)
    end

    it '.library.artist_albums' do
      params = { limit: 10 }
      albums = client.me.library.artist_albums(artist_id, params)

      expect(albums.class).to eql(Array)
      expect(albums.first.class).to eql(Napster::Models::Album)
    end

    it '.library.artist_tracks' do
      params = { limit: 10 }
      tracks = client.me.library.artist_tracks(artist_id, params)

      expect(tracks.class).to eql(Array)
      expect(tracks.first.class).to eql(Napster::Models::Track)
    end

    it '.library.albums' do
      params = { limit: 10 }
      albums = client.me.library.albums(params)

      expect(albums.class).to eql(Array)
      expect(albums.first.class).to eql(Napster::Models::Album)
    end

    it '.library.album_tracks' do
      params = { limit: 10 }
      tracks = client.me.library.album_tracks(album_id, params)

      expect(tracks.class).to eql(Array)
      unless tracks.empty?
        expect(tracks.first.class).to eql(Napster::Models::Track)
      end
    end

    it '.library.tracks' do
      params = { limit: 10 }
      tracks = client.me.library.tracks(params)

      expect(tracks.class).to eql(Array)
      unless tracks.empty?
        expect(tracks.first.class).to eql(Napster::Models::Track)
      end
    end

    it '.library.add_track' do
      client.me.library.add_track([track_id])
      params = { limit: 200 }
      tracks = client.me.library.tracks(params)
      selected = tracks.find { |track| track.id == track_id }
      expect(selected.class).to eql(Napster::Models::Track) unless selected
    end

    it '.library.remove_track' do
      client.me.library.remove_track(track_id)
      params = { limit: 200 }
      tracks = client.me.library.tracks(params)
      selected = tracks.select { |track| track.id == track_id }
      expect(selected).to be_empty
    end
  end

  describe '.playlists' do
    it '.all' do
      params = { limit: 10 }
      playlists = client.me.playlists.all(params)
      expect(playlists.class).to eql(Array)
      unless playlists.empty?
        expect(playlists.first.class).to eql(Napster::Models::Playlist)
      end
    end

    it '.authenticated_find and .create' do
      public_playlist = client.playlists.playlists_of_the_day.first
      playlist_hash = {
        'id' => public_playlist.id,
        'name' => Faker::Lorem.sentence
      }
      playlist = client.me.playlists.create(playlist_hash)

      # uses .authenticated_find
      playlist = client.me.playlists.find(playlist.id)
      expect(playlist.class).to eql(Napster::Models::Playlist) unless playlist
    end

    describe '.update' do
      it '.me.playlists.update' do
        public_playlist = client.playlists.playlists_of_the_day.first
        playlist_hash = {
          'id' => public_playlist.id,
          'name' => Faker::Lorem.sentence
        }
        playlist = client.me.playlists.create(playlist_hash)
        new_name = {
          'name' => Faker::Lorem.sentence
        }
        updated_playlist = client.me.playlists.update(playlist.id, new_name)

        expect(updated_playlist.class).to eql(Napster::Models::Playlist)
        expect(updated_playlist.name).to eql(new_name['name'])
      end
    end
  end
end