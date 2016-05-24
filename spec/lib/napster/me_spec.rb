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
guids = %w(2423C6DDE6B5F028E050960A3903252B D877082A5CBC5AC7E040960A390313EF)
to_follow = %w(139FBE71933C61B1E050960A38031E3F 0ED887A544D14846E050960A38036413)
playlist_ids = []

describe Napster::Me do
  after(:all) do
    ClientSpecHelper.delete_playlists(playlist_ids)
  end

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

    it '.library.last_updated_date' do
      library_date_time = client.me.library.last_updated_date
      expect(library_date_time.class).to eql(Napster::Models::LibraryDateTime)
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
      public_playlist = client.playlists.playlists_of_the_day(limit: 1).first
      playlist_hash = {
        'id' => public_playlist.id,
        'name' => Faker::Lorem.sentence
      }
      playlist = client.me.playlists.create(playlist_hash)
      playlist_ids << playlist.id

      # uses .authenticated_find
      playlist = client.me.playlists.find(playlist.id)
      expect(playlist.class).to eql(Napster::Models::Playlist) unless playlist
    end

    it '.update' do
      public_playlist = client.playlists.playlists_of_the_day(limit: 1).first
      playlist_hash = {
        'id' => public_playlist.id,
        'name' => Faker::Lorem.sentence
      }
      playlist = client.me.playlists.create(playlist_hash)
      playlist_ids << playlist.id
      new_name = {
        'name' => Faker::Lorem.sentence
      }
      updated_playlist = client.me.playlists.update(playlist.id, new_name)

      expect(updated_playlist.class).to eql(Napster::Models::Playlist)
      expect(updated_playlist.name).to eql(new_name['name'])
    end

    it '.delete' do
      public_playlist = client.playlists.playlists_of_the_day(limit: 1).first
      playlist_hash = {
        'id' => public_playlist.id,
        'name' => Faker::Lorem.sentence
      }
      playlist = client.me.playlists.create(playlist_hash)
      playlist_ids << playlist.id
      client.me.playlists.delete(playlist.id)

      unfound_playlist = client.me.playlists.find(playlist.id)
      expect(unfound_playlist).to eql(nil)
    end

    it '.set_private' do
      public_playlist = client.playlists.playlists_of_the_day(limit: 1).first
      playlist_hash = {
        'id' => public_playlist.id,
        'name' => Faker::Lorem.sentence
      }
      playlist = client.me.playlists.create(playlist_hash)
      playlist_ids << playlist.id
      privacy_value = rand(0..1) == 0 ? true : false

      client.me.playlists.set_private(playlist.id, privacy_value)
      updated_playlist = client.me.playlists.find(playlist.id)

      if privacy_value
        expect(updated_playlist.privacy).to eql('private')
      else
        expect(updated_playlist.privacy).to eql('public')
      end
    end

    it 'playlist.tracks' do
      public_playlist = client.playlists.playlists_of_the_day(limit: 1).first
      playlist_hash = {
        'id' => public_playlist.id,
        'name' => Faker::Lorem.sentence
      }
      playlist = client.me.playlists.create(playlist_hash)
      playlist_ids << playlist.id
      tracks = playlist.tracks(limit: 10)

      expect(tracks.class).to eql(Array)
      expect(tracks.first.class).to eql(Napster::Models::Track)
    end

    it '.add_tracks' do
      public_playlist = client.playlists.playlists_of_the_day(limit: 1).first
      playlist_hash = {
        'id' => public_playlist.id,
        'name' => Faker::Lorem.sentence
      }
      playlist = client.me.playlists.create(playlist_hash)
      playlist_ids << playlist.id

      client.me.playlists.add_tracks(playlist.id, [track_id])
      client.me.playlists.find(playlist.id)
      tracks = playlist.tracks(limit: 100)
      found = tracks.find { |track| track.id == track_id }

      expect(found.class).to eql(Napster::Models::Track) unless found
    end

    it 'me.tags' do
      public_playlist = client.playlists.playlists_of_the_day(limit: 1).first
      playlist_hash = {
        'id' => public_playlist.id,
        'name' => Faker::Lorem.sentence
      }
      playlist = client.me.playlists.create(playlist_hash)
      playlist_ids << playlist.id
      tags = playlist.tags

      expect(tags.class).to eql(Array)
      expect(tags.first.class).to eql(Napster::Models::Tag) unless tags.empty?
    end

    it 'playlists.recommended_tracks' do
      public_playlist = client.playlists.playlists_of_the_day(limit: 1).first
      playlist_hash = {
        'id' => public_playlist.id,
        'name' => Faker::Lorem.sentence
      }
      playlist = client.me.playlists.create(playlist_hash)
      playlist_ids << playlist.id
      tracks = playlist.recommended_tracks(playlist.id)

      expect(tracks.class).to eql(Array)
      unless tracks.empty?
        expect(tracks.first.class).to eql(Napster::Models::Track)
      end
    end
  end

  describe 'following' do
    it 'members' do
      members = client.me.following.members(limit: 5)
      expect(members.class).to eql(Array)
      unless members.empty?
        expect(members.first.class).to eql(Napster::Models::Member)
      end
    end

    it 'by?' do
      member_guids = client.me.following.by?(guids)
      expect(member_guids.class).to eql(Array)
    end

    it 'follow' do
      client.me.following.follow(to_follow)
      members = client.me.following.by?(guids)
      members.each do |member|
        expect(guids).to include(member)
      end
    end

    it 'unfollow' do
      client.me.following.unfollow(to_follow)
      members = client.me.following.by?(guids)
      members.each do |member|
        expect(guids).not_to include(member)
      end
    end
  end

  describe 'followers' do
    it 'members' do
      members = client.me.followers.members(limit: 5)
      expect(members.class).to eql(Array)
      unless members.empty?
        expect(members.first.class).to eql(Napster::Models::Member)
      end
    end

    it 'by?' do
      member_guids = client.me.followers.by?(guids)
      expect(member_guids.class).to eql(Array)
    end
  end

  describe 'tags' do
    it 'contents' do
      contents = client.me.tags.contents('favorite', '', {})
      expect(contents.class).to eql(Array)
      contents.each do |c|
        expect(c.class.to_s.include?('Napster::Models')).to eql(true)
      end
    end
  end
end
