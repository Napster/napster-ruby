[![Stories in Ready](https://badge.waffle.io/Napster/napster-ruby.png?label=ready&title=Ready)](https://waffle.io/Napster/napster-ruby)
<!-- TODO: Move this SVG to Dev Portal assets when we have more assets.  Right now it's in Dropbox :) -->
<a href="http://developer.napster.com/">
  <img src="https://dl.dropboxusercontent.com/s/bfydqpzisetm7y3/napster.svg?dl=0" alt="Napster Logo" title="Napster API" align="right" width=150 height=150/>
</a>

<!--
Put Badges here when we have them:
[![Build Status](https://travis-ci.org/)
-->
<!--
TODO: Add this link to the top when we change name of Google Forum
**Got a question?** Let us know via the Napster API [google forum](https://groups.google.com/forum/#!forum/rhapsody-api).
-->
# Napster Gem

A Ruby interface to the [Napster API](https://developer.napster.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'napster'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install napster

### Ruby version

Ruby version should be 2.0 or greater.

## Usage

### Setting up a client

A **client** prepares you to make calls to Napster API.
Here is an example code for setting up a client using
[implicit method](https://developer.napster.com/api#authentication).

``` ruby
require 'napster'

options = {
  api_key: 'API_KEY',
  api_secret: 'API_SECRET',
}

client = Napster::Client.new(options)
```

You can still set up a client with just an access token. However, you will
not be able to refresh the access token and you won't be able to make any
metadata calls. Only authenticated member calls will be allowed with this
client.

``` ruby
options = { access_token: 'ACCESS_TOKEN' }
client = Napster::Client.new(options)
```

### Getting an access token

#### Password grant

##### Method 1

```ruby
client_hash = {
  api_key: 'API_KEY',
  api_secret: 'API_SECRET',
  username: 'USERNAME',
  password: 'PASSWORD'
}

# Just by instantiating with api_key, api_secret, username, and password
# you can authenticate by password_grant.
client = Napster::Client.new(client_hash)

client.authentication.access_token # => returns access_token
client.authentication.refresh_token
client.authentication.expires_in
```

##### Method 2

```ruby
client_hash = {
  api_key: 'API_KEY',
  api_secret: 'API_SECRET'
}

client = Napster::Client.new(client_hash)
client.username = 'USERNAME'
client.password = 'PASSWORD'
client.connect

client.authentication.access_token # => returns access_token
client.authentication.refresh_token
client.authentication.expires_in
```

#### OAuth 2

```ruby
client_hash = {
  api_key: 'API_KEY',
  api_secret: 'API_SECRET',
  redirect_uri: 'REDIRECT_URI',
  auth_code: 'AUTH_CODE'
}

client = Napster::Client.new(client_hash)
client.connect

client.authentication.access_token # => returns access_token
client.authentication.refresh_token
client.authentication.expires_in
```

### Refresh an access token

Napster API's `access_token` expires in 24 hours after it is issued.
You need to use the `refresh_token` to generate a new `access_token` when
it is expired.

*It is not recommended to get a new access_token - refresh_token
through authentication after the old access_token expires.*

```ruby
client.refresh # => returns new access_token by refreshing it
```

### Making Requests

#### Metadata API

Metadata endpoints do not need the client to be authenticated.
First, set up a client with `api_key` and `api_secret`.
Then you can call metadata endpoints following this pattern.

```ruby
# takes a form of client.[resources].[method]

# albums
client.albums.new_releases(limit: 10)
client.albums.staff_picks(limit: 10)
client.albums.top(limit: 10)
client.albums.find(artist_id) # => returns an album
client.albums.find(artist_name) # => returns an album
client.albums.find(artist_id).tracks(limit: 10) # => returns an album
client.albums.find(artist_name).tracks(limit: 10) # => returns an album

# artists
client.artists.top(limit: 5)
client.artists.find(artist_id) # => returns an artist
client.artists.find(artist_name) # => returns an artist
client.artists.find(artist_id).albums(offset: 5)
client.artists.find(artist_id).new_albums(offset: 5)
client.artists.find(artist_id).tracks(limit: 5)
client.artists.find(artist_id).top_tracks(limit: 5)

# favorites
client.favorites.members_who_favorited_albums('Alb.5153820')
client.favorites.members_who_favorited_artists('Art.954')
client.favorites.member_favorites_for('Tra.5156528')

# members
client.members.playlists_for('D877082A5CBC5AC7E040960A390313EF', limit: 2)
client.members.favorites_for('D877082A5CBC5AC7E040960A390313EF', limit: 2)
client.members.favorite_playlists_for('D877082A5CBC5AC7E040960A390313EF', limit: 2)
client.members.chart_for('D877082A5CBC5AC7E040960A390313EF', limit: 2)
client.members.find('D877082A5CBC5AC7E040960A390313EF')
client.members.find('dduda')
client.members.screenname_available?('dduda')
client.members.find('dduda').playlists(limit: 5)
client.members.find('dduda').favorites(limit: 5)
client.members.find('dduda').favorite_playlists(limit: 5)
client.members.find('dduda').chart(limit: 5)

# playlists
client.playlists.playlists_of_the_day(limit: 3)
client.playlists.featured(limit: 3)
client.playlists.find('pp.125821370')
client.playlists.find('pp.125821370').tracks(limit: 10)
client.playlists.find('pp.125821370').tags

# tags
client.tags.all
client.tags.find('tag.156763217')

# tracks
client.tracks.find('Tra.5156528')
client.tracks.find_by_name('Marvins Room')
```

#### Authenticated Member API

Authenticated member endpoints require the client to be authenticated.
First, set up a client with `api_key` and `api_secret`.
Authenticate the client by going through password grant method or
OAuth2 method.
Ensure that the client has access_token and refresh_token.
Then you can call metadata endpoints following this pattern.

```ruby
# takes a form of client.me.[resources].[method]

# favorites
client.me.favorites.get(limit: 5)
client.me.favorites.status(['Art.954', 'Alb.5153820', 'Tra.5156528'])
client.me.favorites.add(['Art.954', 'Alb.5153820', 'Tra.5156528'])
client.me.favorites.remove('Art.954')

# followers
client.me.followers.members(limit: 5)
client.me.followers.by?(guids)

# following
client.me.following.members(limit: 5)
client.me.following.by?(guids)
client.me.following.follow(guids)
client.me.following.unfollow(guids)

# library
client.me.library.artists(limit: 10)
client.me.library.artist_albums('Art.954', limit: 10)
client.me.library.artist_tracks('Art.954', limit: 10)
client.me.library.albums(limit: 10)
client.me.library.album_tracks('Alb.5153820', limit: 10)
client.me.library.tracks(limit: 10)
client.me.library.add_track(['Tra.5156528'])
client.me.library.remove_track('Tra.5156528')
client.me.library.last_updated_date

# listening history
client.me.listening_history(limit: 10)

# playlists
client.me.playlists.all(limit: 10)
client.me.playlists.create({ 'name' => 'hiphop playlist' })
client.me.playlists.find('mp.123123')
client.me.playlists.update('mp.123123', { 'name' => 'hiphop playlist 2' })
client.me.playlists.delete('mp.123123')
client.me.playlists.set_private('mp.123123', 'public')
client.me.playlists.set_private('mp.123123', 'private')
client.me.playlists.add_tracks('mp.123123', ['Tra.5156528'])
client.me.playlists.recommended_tracks('mp.123123')
client.me.playlists.uploaded_images(id: 'mp.123123', size: 500) # id and size in px
client.me.playlists.sourced_by('my_own_playlists',
                               { artists: ['art.123', 'art.234'], tags: ['tag.123', 'tag.234'], guid: 'xyz', sort: 'alpha_asc', include_private: true, limit: 10, offset: 5})
client.me.playlists.find('mp.123123').tracks(limit: 10)
client.me.playlists.find('mp.123123').tags
client.me.playlists.find('mp.123123').uploaded_images(500) # size in px

# profile
client.me.profile.get
client.me.profile.update({ 'me' => { 'bio' => Faker::Lorem.word } })

# tags
client.me.tags.contents('favorite', '', {})
```

#### Query Parameters

```ruby
client.artists.top(limit: 5, offset: 5)
```

#### Request body for PUT / POST

```ruby
request_hash = {
  body: {
    name: 'name of the playlist',
    tags: ['tag.1', 'tag.2'],
    privacy: 'public',
    tracks: ['tra.1', 'tra.2']
  }
}
client.me.create_playlist(request_hash)
```

#### Error Handling

Napster gem provides `ResponseError` which wraps response errors from Napster
API. You can inspect error attributes as shown below.

```ruby
begin
  client.playlists.find('pp.125821370').tracks({}) # problematic request
rescue Exception => error
  puts error.http_status # => 400
  puts error.response_body
    # => {"code":"BadRequestError","message":"limit query parameter is required"}
  puts error.faraday_response.inspect
    # => #<Faraday::Response:0x007fe9bc957150 @on_complete_callbacks=[], ...
end
```

<!--
### Versioning

The Napster gem supports Napster API version 2.x and above only.
When the client does not specify the version, it'll use the latest
Napster API version.

#### Versioned client

You can set client to always use a specific version of Napster API.

```ruby
client.version = 'v2.1'
client.artists.top # returns top artists using v2.1
```

#### Making one-off versioned request

Even though the client already has a version set, you can still make
one-off calls to a different version of Napster API.

```ruby
client.version = 'v2.1'
client.v2_2.artists.top # returns top artists using v2.2
client.artists.top # returns top artists using v2.1
```
-->

## Development

### Running tests

Napster gem uses RSpec and FactoryGirl.

1. Get the API key and API secret from
[Napster Developers site](https://developer.napster.com/).

2. Create a file called `config.yml` in `spec` directory.

3. Add the following with the correct API key and API secret

``` yml
config_variables:
  API_KEY: 'API_KEY'
  API_SECRET: 'API_SECRET'
  USERNAME: 'USERNAME'
  PASSWORD: 'PASSWORD'
  REDIRECT_URI: 'REDIRECT_URI'
```

4. `$ bundle install`

5. `$ rspec`


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/napster/napster-ruby.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

Napster and Napster logo are registered and unregistered trademarks of Rhapsody International in the United States and/or other countries. All company, product and service names used in this website are for identification purposes only.  All product names, logos, and brands are property of their respective owners.
