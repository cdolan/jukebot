require "jukebot/lastfm/database"

RSpec.describe Jukebot::Lastfm::Database do
  describe ".filename" do
    let(:filename) do
      File.expand_path("../../../../lastfm_profiles.txt", __FILE__)
    end

    subject { Jukebot::Lastfm::Database.filename }

    it { is_expected.to eq(filename) }
  end

  describe ".add_profile_name" do
    before do
      @file = Tempfile.new("lastfm_profiles.txt").tap do |f|
        f.write("foo\n")
        f.close
      end

      allow(Jukebot::Lastfm::Database).to receive(:filename) { @file.path }

      Jukebot::Lastfm::Database.add_profile_name("bar")
    end

    after do
      @file.unlink
    end

    it "appends names to lastfm_profiles.txt" do
      expect(File.open(@file.path, "r", &:read)).to eq("foo\nbar\n")
    end
  end

  describe ".profile_names" do
    before do
      @file = Tempfile.new("lastfm_profiles.txt").tap do |f|
        f.write("foo\n")
        f.write("bar\n")
        f.close
      end

      allow(Jukebot::Lastfm::Database).to receive(:filename) { @file.path }
    end

    after do
      @file.unlink
    end

    it "returns array of names in lastfm_profiles.txt" do
      expect(Jukebot::Lastfm::Database.profile_names).to eq(%w(foo bar))
    end
  end
end
