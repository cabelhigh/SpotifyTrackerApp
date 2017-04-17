require 'rails_helper'
require 'RSpotify'

RSpec.describe Playlist, type: :model do
  let(:oldEDM) do
    VCR.use_cassette('playlist:find:1220911400:4NM2ao67Lyao5NDfIMKl4R') do
      RSpotify::Playlist.find('1220911400','4NM2ao67Lyao5NDfIMKl4R')
    end
  end

  it "exists" do
    expect{Playlist.new}.to_not raise_error
  end

  it "can create a new Playlist based off an RSpotify playlist" do
    expect{Playlist.convert_playlist(oldEDM, "N/A")}.to_not raise_error
  end

  it "can format its uri for easy searching" do
    Playlist.convert_playlist(oldEDM, "spotify:user:spotify")
    expect(Playlist.last.formatted_uri).to eq '4NM2ao67Lyao5NDfIMKl4R'
  end

  it "can format its owner for easy searching" do
    Playlist.convert_playlist(oldEDM, "spotify:user:spotify")
    expect(Playlist.last.formatted_owner).to eq 'spotify'
  end

  it "can format its creator for easy searching" do
    Playlist.convert_playlist(oldEDM, "spotify:user:spotify")
    expect(Playlist.last.formatted_creator).to eq '1220911400'
  end

  it "will return nil if its owner is not formatted correctly " do
    Playlist.convert_playlist(oldEDM, "dude")
    expect(Playlist.last.formatted_owner).to eq nil
  end

  describe "understands when tracks have been removed from a playlist" do
    it "will not generate a new 'removed_tracks' playlist if no tracks have changes" do
      Playlist.convert_playlist(oldEDM, "N/A") #The Old EDM Collection
      pl = Playlist.last
      pl.add_remove_tracks
      expect(Playlist.last.ptype).to eq 'original'
    end

    it "will generate a new 'removed_tracks' playlist if this is the first time tracks have been removed" do
      Playlist.convert_playlist(oldEDM, "N/A") #The Old EDM Collection
      pl = Playlist.last
      new_tracks = pl.tracks.to_a
      removed_track=new_tracks.shift
      pl.tracks = []
      new_tracks.each do |t|
        pl.tracks << t
      end
      pl.add_remove_tracks
      expect(Playlist.last.ptype).to eq 'removed_tracks'
      expect(Playlist.last.tracks.first.name).to eq removed_track.name
    end

    #won't work correctly, since usually the pulled pl will be changed and now the local pl. This tests the reverse
    it "will update an old 'removed_tracks' playlist if this is not the first time tracks have been removed" do
      Playlist.convert_playlist(oldEDM, "N/A") #The Old EDM Collection
      pl = Playlist.last
      new_tracks = pl.tracks.to_a
      removed_track1=new_tracks.shift
      pl.tracks = []
      new_tracks.each do |t|
        pl.tracks << t
      end
      pl.add_remove_tracks
      expect(Playlist.last.ptype).to eq 'removed_tracks'
      expect(Playlist.last.tracks.first.name).to eq removed_track1.name

      new_tracks = pl.tracks.to_a
      removed_track2=new_tracks.shift
      pl.tracks = []
      new_tracks.each do |t|
        pl.tracks << t
      end
      pl.add_remove_tracks
      expect(Playlist.last.ptype).to eq 'removed_tracks'
      expect(Playlist.last.tracks[0].name).to eq removed_track1.name
      expect(Playlist.last.tracks[1].name).to eq removed_track1.name #repeats the original result of the add_remove_tracks, bc of
      expect(Playlist.last.tracks[2].name).to eq removed_track2.name
      expect(Playlist.last.tracks.count).to eq 3
    end


  end
end
