require "net/http"
require "json"
require "uri"
require "date"

module Jukebot
  module Lastfm
    class Profile
      attr_reader :name
      attr_reader :lastFmApiKey

      def initialize(name)
        @name = name
        @lastFmApiKey = "YOUR_LAST_FM_API_KEY"
      end

      def now_playing
        uri = URI.parse("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=#{name}&api_key=#{lastFmApiKey}&format=json&limit=1")
        response = Net::HTTP.get_response(uri)   

        case response
        when Net::HTTPSuccess
          extract_song_name(response.body)
        end
      end

      private

        def extract_song_name(json)
          parsedJson = JSON.parse(json)

          artistAndTrack = nil

          if parsedJson["recenttracks"] && parsedJson["recenttracks"]["track"] then

            recentTrack = parsedJson["recenttracks"]["track"][0]            

            timeLastPlayedInSeconds = "0"

            if recentTrack and recentTrack["date"] and recentTrack["date"]["uts"] then
              timeLastPlayedInSeconds = recentTrack["date"]["uts"]
            end

            differenceInLastPlayed = Integer(DateTime.now.strftime('%s')) - Integer(timeLastPlayedInSeconds)

            if recentTrack and recentTrack["@attr"] and recentTrack["@attr"]["nowplaying"] then            
              artistAndTrack = recentTrack["artist"]["#text"] + " - " + recentTrack["name"]
            elsif recentTrack and differenceInLastPlayed < 600 then #Check if last song is less than 10 minutes since scrobbled
              artistAndTrack = recentTrack["artist"]["#text"] + " - " + recentTrack["name"]
            end

          end

          artistAndTrack
        end
    end
  end
end
