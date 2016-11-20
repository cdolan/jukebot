require "jukebot/lastfm/profile"

RSpec.describe Jukebot::Lastfm::Profile do
  describe "#now_playing" do
    let(:profile) { Jukebot::Lastfm::Profile.new("cdolan_listens2") }

    context "when song is playing" do
      before do
        VCR.use_cassette("song_playing") do
          @song_name = profile.now_playing
        end
      end

      it "returns the song name" do
        expect(@song_name).to eq("Our Last Night — Sunrise")
      end
    end

    context "when no song is playing" do
      before do
        VCR.use_cassette("no_song_playing") do
          @song_name = profile.now_playing
        end
      end

      it "returns nil" do
        expect(@song_name).to be_nil
      end
    end
  end
end
