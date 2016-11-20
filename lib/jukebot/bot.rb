require "slack-ruby-bot"

require "jukebot/lastfm"

module Jukebot
  class Bot < SlackRubyBot::Bot
    help do
      title "Jukebot"
      desc "I tell you what everyone is listening to"

      command "What's everyone listening to?" do
        desc "See what what everyone is listening to"
      end

      command "I'm <name> on lastfm" do
        desc "Adds your Last.fm account name to Jukebot"
      end
    end

    match(/^I\'?m (?<name>[\w\d_]+) on lastfm/i) do |client, data, match|
      name = match[:name]

      Jukebot::Lastfm::Database.add_profile_name(name)

      response = "Thanks, added #{name}!"
      client.say(:channel => data.channel, :text => response)
    end

    match(/^What(\'?s| is)? every(one|body) listening to\??$/i) do
      |client, data, match|
        songs = songs_now_playing

        if songs.size.zero?
          response = "Nobody's listening to music"
          client.say(:channel => data.channel, :text => response)
        else
          response = "Everyone's listening to: #{songs.join(', ')}"
          client.say(:channel => data.channel, :text => response)
        end
      end

    private

      def self.songs_now_playing
        Jukebot::Lastfm.profiles.map(&:now_playing).find_all { |p| !p.nil? }
      end
  end
end
