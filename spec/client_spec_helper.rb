require 'config_loader'
require 'napster'

module ClientSpecHelper
  # prepares a client that is able to call Napster API
  def self.get_client(includes = [])
    yaml = ConfigLoader.init['config_variables']
    client_options = {
      api_key: yaml['API_KEY'],
      api_secret: yaml['API_SECRET']
    }
    includes.each do |include|
      if include == 'username'
        client_options[:username] = yaml['USERNAME']
      elsif include == 'password'
        client_options[:password] = yaml['PASSWORD']
      end
    end
    Napster::Client.new(client_options)
  end

  def self.get_me_library_playlists(client)
    get_options = {
      params: {
        limit: 5
      },
      headers: {
        Authorization: 'Bearer ' + client.access_token
      }
    }
    client.get('/me/library/playlists', get_options)
  end

  def self.delete_playlists(ids)
    includes = %w(username password)
    client = ClientSpecHelper.get_client(includes)
    client.authenticate(:password_grant)
    ids.each do |playlist_id|
      client.me.playlists.delete(playlist_id)
    end
  end

  def self.content_in_library?
    params = { limit: 10 }
    includes = %w(username password)
    client = ClientSpecHelper.get_client(includes)
    client.authenticate(:password_grant)
    artists = client.me.library.artists(params)
    !artists.empty?
  end

  def self.owns_playlists?
    params = { limit: 10 }
    includes = %w(username password)
    client = ClientSpecHelper.get_client(includes)
    client.authenticate(:password_grant)
    playlists = client.me.playlists.all(params)
    !playlists.empty?
  end

  def self.prepare_refresh_token
    includes = %w(username password)
    client = ClientSpecHelper.get_client(includes)
    client.authenticate(:password_grant)
    client.refresh_token
  end
end
