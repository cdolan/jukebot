require "jukebot/lastfm"

RSpec.describe Jukebot::Lastfm do
  describe ".profiles" do
    before do
      names = %w(foo bar)
      allow(Jukebot::Lastfm::Database).to receive(:profile_names) { names }
    end

    it "returns instances of Jukebot::Lastfm::Profile" do
      Jukebot::Lastfm.profiles.each do |profile|
        expect(profile).to be_an_instance_of(Jukebot::Lastfm::Profile)
      end
    end
  end
end
