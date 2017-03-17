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
	   	uri = URI("https://www.last.fm/user/#{name}")
		Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
			request = Net::HTTP::Get.new uri
			response = http.request request

            case response
            when Net::HTTPSuccess
                extract_song_name(response.body)
            end
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
