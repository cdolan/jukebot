require "jukebot/bot"
require "jukebot/lastfm"

RSpec.describe Jukebot::Bot do
  let(:app) { Jukebot::Bot.instance }

  subject { app }

  it_behaves_like "a slack ruby bot"

  describe "when someone states their Last.fm profile name" do
    let(:message) { "I'm foobar on Lastfm" }

    before do
      allow(Jukebot::Lastfm::Database).to receive(:add_profile_name)
    end

    it "confirms the addition of the profile" do
      expect(message).to respond_with_slack_message("Thanks, added foobar!")
      expect(Jukebot::Lastfm::Database).to have_received(:add_profile_name)
        .with("foobar")
    end
  end

  describe "when someone asks what everyone's listening to" do
    let(:message) { "What's everyone listening to?" }

    before do
      allow(Jukebot::Lastfm).to receive(:profiles).and_return(profiles)
    end

    context "someone is listening to music" do
      let(:profiles) do
        [
          instance_double("Jukebot::Lastfm::Profile", :now_playing => "foo"),
          instance_double("Jukebot::Lastfm::Profile", :now_playing => "bar"),
          instance_double("Jukebot::Lastfm::Profile", :now_playing => "baz"),
          instance_double("Jukebot::Lastfm::Profile", :now_playing => nil),
        ]
      end

      it "returns a list of songs now playing" do
        response = "Everyone's listening to: foo, bar, baz"
        expect(message).to respond_with_slack_message(response)
      end
    end

    context "no one is listening to music" do
      let(:profiles) { [] }

      it "returns a list of songs now playing" do
        response = "Nobody's listening to music"
        expect(message).to respond_with_slack_message(response)
      end
    end
  end
end
