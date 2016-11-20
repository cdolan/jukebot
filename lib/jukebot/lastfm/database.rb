module Jukebot
  module Lastfm
    class Database
      def self.filename
        File.expand_path("../../../../lastfm_profiles.txt", __FILE__)
      end

      def self.add_profile_name(name)
        File.open(filename, "a") { |f| f.write("#{name}\n") }
      end

      def self.profile_names
        File.open(filename, "r", &:read).split
      end
    end
  end
end
