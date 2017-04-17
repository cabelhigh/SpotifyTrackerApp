class Playlist < ApplicationRecord
  has_many :tracks

  def destroy
    self.tracks.destroy_all
    super
  end

  def owner_and_creator?(own, cre)
    owner==own && creator==cre
  end

  def formatted_creator
    creator.split(':')[2] if creator.include? ':'
  end

  def formatted_uri
    uri.split(':')[4]
  end

  def formatted_owner
    owner.split(':')[2]
  end

  def update_discover user
    new_pl = RSpotify::Playlist.new(RSpotify.get("https://api.spotify.com/v1/users/spotify/playlists/#{formatted_uri}"))
      debugger
      if Time.new >= new_pl.tracks_added_at.first.last+1.week && Playlist.find_by_name("Discover Weekly #{(new_pl.tracks_added_at.first.last-1.week).strftime("%m/%d/%Y")}").nil?
        create_old_dw(new_pl.tracks_added_at.first.last-1.week, user)
        self.tracks = [] #nils the pls's current tracks
        new_pl.tracks.each do |t| #adds all of the new, pulled tracks to the local pl
          track = Track.new
          track.uri = t.uri
          track.name = t.name
          self.tracks << track
        end
        debugger
      end
  end

  def add_remove_tracks
    new_pl=RSpotify::Playlist.find(formatted_creator, formatted_uri)
    puts "Updated playlist size #{new_pl.tracks.size}"
    puts "Old playlist size #{tracks.size}"
    #Below works for both removed AND added tracks rn
    diff_tracks = compare_tracks(tracks.map{|t| t.uri}, new_pl.tracks.map{|t| t.uri})
    if diff_tracks!=-1
      rmv_tracks_pl = Playlist.where(uri: uri, ptype: "removed_tracks") #checks if a 'removed_tracks' playlist has already been created for this playlist
      if rmv_tracks_pl.empty?
        create_new_song_pl(diff_tracks[:removed_tracks], self)
      else
        add_tracks(rmv_tracks_pl.first, diff_tracks[:removed_tracks])
      end
      self.tracks = [] #nils the pls's current tracks
      new_pl.tracks.each do |t| #adds all of the new, pulled tracks to the local pl
        track = Track.new
        track.uri = t.uri
        track.name = t.name
        self.tracks << track
      end
      # debugger
      puts "Current playlist size #{tracks.size}"
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
    pl.ptype = "discover_weekly" if rs_playlist.name == "Discover Weekly"
    rs_playlist.tracks.each do |t|
      track = Track.new
      track.uri = t.uri
      track.name = t.name
      pl.tracks << track
    end
    pl.save
  end

  private

    def create_old_dw(time, user)
      pl = Playlist.new
      pl.name = "Discover Weekly #{time.strftime("%m/%d/%Y")}"
      pl.creator = "spotify:user:spotify" #owner of the ORIGINAL playlist, not the current user
      pl.tracking = false
      pl.gen_new_list = false
      pl.owner = owner
      pl.ptype = "removed_tracks"
      self.tracks.each do |t|
        track = Track.new
        track.uri = t.uri
        track.name = t.name
        pl.tracks << track
      end
      pl.uri = create_spotify_pl(pl, user) #creates the playlist on spotify and returns its uri
      pl.save
    end

    def add_tracks(playlist, new_tracks)
      RSpotify.authenticate("13c33594a47d498fbcefb942a3d6193a", "be301da18e4342c69952a036b716be70")
      pl_track_uris = playlist.tracks.map{|t| t.uri}
      new_tracks.each do |t|
        if !pl_track_uris.include? t.uri
          track = Track.new
          track.uri = t
          track.name = RSpotify::Track.find(t.split(':')[2]).name
          playlist.tracks << track
        end
      end
      playlist.save
    end

    def create_new_song_pl(track_uris, parent_playlist)
      playlist = Playlist.new
      playlist.uri = parent_playlist.uri #should change -- be new, generated pl URI
      playlist.name = "#{parent_playlist.name} -- Removed Tracks"
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

    def create_spotify_pl(local_playlist, user)
      RSpotify.authenticate("13c33594a47d498fbcefb942a3d6193a", "be301da18e4342c69952a036b716be70")
      playlist = user.create_playlist!(local_playlist.name)
      tracks = local_playlist.tracks.map{|t| RSpotify::Track.find(t.formatted_uri)}
      playlist.add_tracks!(tracks)
      playlist.uri
    end

    def compare_tracks(old_pl_uris, new_pl_uris)
      #shamelessly lifted from http://stackoverflow.com/questions/22378457/array-with-only-non-duplicate-values/22379065
      removed_tracks = old_pl_uris.select{|i| !new_pl_uris.include? i} #(old_pl_uris+new_pl_uris).select{ |t| (old_pl_uris+new_pl_uris).count(t)==1}
      added_tracks = new_pl_uris.select{|i| !old_pl_uris.include? i}
      # debugger
      puts "Amount of removed tracks found #{removed_tracks.count}"
      removed_tracks.empty? && added_tracks.empty? ? -1 : {removed_tracks: removed_tracks, added_tracks: added_tracks}
       #could delete, but like the puts for rn
      # new_tracks = new_pl_uris.reject{ |i| old_pl_uris.include? i}
      # # {removed_tracks: removed_tracks, new_tracks: new_tracks}
      # removed_tracks
    end
end
