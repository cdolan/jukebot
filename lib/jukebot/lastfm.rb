require_relative "lastfm/database"
require_relative "lastfm/profile"

module Jukebot
  module Lastfm
    def self.profiles
      Jukebot::Lastfm::Database.profile_names.map do |name|
        Jukebot::Lastfm::Profile.new(name)
      end
    end
  end
end
