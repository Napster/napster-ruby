module Napster
  module Resources
    module Metadata
      # Tracks resources
      #   Makes /tracks namespaced calls to Napster API
      class TracksResource
        attr_accessor :client, :data

        def initialize(client)
          @client = client
          @data = nil
        end

        def top
          response = @client.get('/tracks/top')
          @data = Napster::Models::Track.collection(response['tracks'])
          self
        end

        def find(arg)
          return find_by_id(arg) if Napster::Moniker.check(arg, :track)
          find_by_name(arg)
        end

        def find_by_id(id)
          response = @client.get("/tracks/#{id}")
          @data = Napster::Models::Track.new(response['tracks'].first)
          self
        end

        def find_all_by_name(name)
          options = {
            params: {
              q: name,
              type: 'track'
            }
          }
          response = @client.get('/search', options)
          @data = Napster::Models::Track.collection(response['data'])
          self
        end

        def find_by_name(name)
          @data = find_all_by_name(name).data.first
          self
        end
      end
    end
  end
end
