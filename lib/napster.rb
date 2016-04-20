require 'faraday'
require 'oj'

require 'string'
require 'napster/client'
require 'napster/request'
require 'napster/version'
require 'napster/moniker'

# Models
require 'napster/models/artist'
require 'napster/models/album'
require 'napster/models/track'
require 'napster/models/genre'
require 'napster/models/playlist'
require 'napster/models/tag'

# Metadata resources
require 'napster/resources/metadata/artists_resource'
require 'napster/resources/metadata/albums_resource'
require 'napster/resources/metadata/tracks_resource'
require 'napster/resources/metadata/genres_resource'
require 'napster/resources/metadata/playlists_resource'

# Authenticated resources
