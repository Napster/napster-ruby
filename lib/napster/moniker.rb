module Napster
  # Module for checking Napster API id monikers
  module Moniker
    MONIKER_REGEXES = {
      artist: /^\s*(Art\.\d+)\s*$/i,
      track: /^\s*(Tra\.\d+)\s*$/i,
      album: /^\s*(Alb\.\d+)\s*$/i,
      review: /^\s*(RevAl\.\d+)\s*$/i,
      genre: /^\s*(g\.\d+)\s*$/i,
      post: /^\s*(po\.\d+)\s*$/i,
      single_artist_station: /^\s*(sas\.\d+)\s*$/i,
      station: /^\s*((p|sa|ma|sma|st|mt|smt)s\.\d+)\s*$/i,
      playlist: /^\s*((m|p)p\.\d+)\s*$/i,
      tag: /^\s*(tag\.\d+)\s*$/i,
      radio: /^\s*(ts\.\d+)\s*$/i,
      member_guid: /^[0-9A-F]{32}$/,
      member_playlist: /^\s*(mp\.\d+)\s*$/i,
      published_playlist: /^\s*(pp\.\d+)\s*$/i
    }.freeze

    # Given id and type, check if the id is of the type
    # @param id [String]
    # @param type [Symbol]
    # @return [MatchData]
    def self.check(id, type)
      MONIKER_REGEXES[type].match(id)
    end
  end
end
