require 'rails_helper'
require 'RSpotify'

RSpec.describe Playlist, type: :model do
  before(:each) do
    for i in 1..10
      playlist = Playlist.new
      playlist.uri = "ABCD#{i+1}#{i+2}#{i+3}#{i+4}"
      playlist.name = "New Name #{i}"
      playlist.creator = "N/A"
      playlist.owner = "N/A"
      playlist.tracking = true
      playlist.gen_new_list = false
      playlist.ptype = "original"
      for t in 1..10
        track = Track.new
        track.uri = "ABCD#{t+1}#{t+2}#{t+3}#{t+4}"
        track.name = "Track#{i}#{t}"
        playlist.tracks << track
      end
      playlist.save
    end
  end

  it "exists" do
    expect{Playlist.new}.to_not raise_error
  end

  it "can create a new Playlist based off an RSpotify playlist" do
    expect{Playlist.convert_playlist(RSpotify::Playlist.find('1220911400','4NM2ao67Lyao5NDfIMKl4R'), "N/A")}.to_not raise_error
  end

  describe "understands when tracks have been removed from a playlist" do
    it "will not generate a new 'removed_tracks' playlist if no tracks have changes" do
      Playlist.convert_playlist(RSpotify::Playlist.find('1220911400','4NM2ao67Lyao5NDfIMKl4R'), "N/A") #The Old EDM Collection
      pl = Playlist.last
      pl.add_remove_tracks
      expect(Playlist.last.ptype).to eq 'original'
    end
  end
end
