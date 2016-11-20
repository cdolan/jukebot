require "net/http"
require "nokogiri"

module Jukebot
  module Lastfm
    class Profile
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def now_playing
        response = Net::HTTP.get_response("www.last.fm", "/user/#{name}")

        case response
        when Net::HTTPSuccess
          extract_song_name(response.body)
        end
      end

      private

        def extract_song_name(html)
          Nokogiri.HTML(html)
            .css(".now-scrobbling > td.chartlist-name > span")
            .text
            .gsub("\n", "")
            .squeeze[1..-2]
        end
    end
  end
end
