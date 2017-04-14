class Playlist < ApplicationRecord
  has_many :tracks

  def owner_and_creator?(own, cre)
    owner==own && creator==cre
  end

  def add_remove_tracks
    formatted_creator = creator.split(':')[2]
    formatted_uri = uri.split(':')[4]
    new_pl=RSpotify::Playlist.find(formatted_creator, formatted_uri)
    diff_tracks =compare_tracks(tracks.map{|t| t.uri}, new_pl.tracks{|t| t.uri})
    if diff_tracks!=-1
      rmv_tracks_pl = Playlist.where(uri: uri, ptype: "removed_tracks") #checks if a 'removed_tracks' playlist has already been created for this playlist
      if rmv_tracks_pl.empty?
          puts "#{diff_tracks} OMG3"
        create_new_song_pl(diff_tracks, self)
      else
        add_tracks(rmv_tracks_pl.first, diff_tracks)
      end
    end
  end

  def self.convert_playlist (rs_playlist, current_user_uri)
    pl = Playlist.new
    pl.uri = rs_playlist.uri
    pl.name = rs_playlist.name
    pl.creator = rs_playlist.owner.uri #owner of the ORIGINAL playlist, not the current user
    pl.tracking = true
    pl.gen_new_list = false
    pl.owner = current_user_uri
    pl.ptype = "original"
    rs_playlist.tracks.each do |t|
      track = Track.new
      track.uri = t.uri
      track.name = t.name
      pl.tracks << track
    end
    pl.save
  end

  private

    def add_tracks(playlist, new_tracks)
      new_tracks.each do |t|
        track = Track.new
        track.uri = t.uri
        track.name = RSpotify::Track.find(t.uri).name
        playlist.tracks << track
      end
      playlist.save
    end

    def create_new_song_pl(track_uris, parent_playlist)
      playlist = Playlist.new
      playlist.uri = parent_playlist.uri
      playlist.name = parent_playlist.name
      playlist.creator = parent_playlist.creator
      playlist.tracking = true
      playlist.gen_new_list = false
      playlist.owner = parent_playlist.owner
      playlist.ptype = "removed_tracks"
      track_uris.each do |t|
        track = Track.new
        track.uri = t
        track.name = RSpotify::Track.find(t.split(':')[2]).name
        playlist.tracks << track
      end
      playlist.save
    end

    def compare_tracks(old_pl_uris, new_pl_uris)
      removed_tracks = old_pl_uris.select{ |i| new_pl_uris.include? i}
      puts "NEW1 #{removed_tracks.count}"
      return -1 if removed_tracks.empty?
      new_tracks = new_pl_uris.reject{ |i| old_pl_uris.include? i}
      # {removed_tracks: removed_tracks, new_tracks: new_tracks}
      removed_tracks
    end
end
