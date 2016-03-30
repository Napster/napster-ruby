# Napster Gem

A Ruby interface to the [Napster/Rhapsody API](https://developer.rhapsody.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'napster'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install napster

## Usage

### Setting up a client

A **client** prepares you to make calls to Napster/Rhapsody API.
Here is an example code for setting up a client using
[implicit method](https://developer.rhapsody.com/api#authentication).

``` ruby
require 'napster'

options = {
  api_key: 'API_KEY',
  api_secret: 'API_SECRET',
}

client = Napster::Client.new(options)
```

### Getting an access token

#### Password grant

```ruby
client_hash = {
  api_key: 'API_KEY',
  api_secret: 'API_SECRET',
  username: 'USERNAME',
  password: 'PASSWORD'
}

client = Napster::Client.new(client_hash)
client.password_grant

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
# examples
client.artists.top
client.artists.find(artist_id) # => returns an artist
client.artists.find(artist_name) # => returns a list of search results for the artist
client.artists.find(artist_id).albums
client.artists.find(artist_id).topAlbums
client.artists.find(artist_id).topTracks({ params: { limit: 5 } })
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
# examples
client.me.profile
client.me.profile.update({ body: { bio: 'I like turtles' } })
client.me.playlists.create({ body: { name: 'My New Playlist', tracks: ['tra.123', 'tra.234'] } })
```

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

### Making Requests

#### Query Parameters

```ruby
client.artists.top({ params: { limit: 5, offset: 5 } })
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

## Development

### Running tests

Napster gem uses RSpec and FactoryGirl.

Rhapsody gem uses RSpec and FactoryGirl.

1. Get the API key and API secret from
[Rhapsody Developers site](https://developer.rhapsody.com/).

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

Bug reports and pull requests are welcome on GitHub at https://github.com/rhapsody/napster.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
