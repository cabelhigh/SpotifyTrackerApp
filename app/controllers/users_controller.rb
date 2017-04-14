require 'rspotify'

class UsersController < ApplicationController
  def spotify
    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    @test = request.env['omniauth.auth']
    @your_playlists = Playlist.where(owner: @spotify_user.uri)
    @spotify_user.playlists.each do |pl|
      if @your_playlists.select{|y_pls| y_pls.uri==pl.uri}.empty?
        playlist = Playlist.new
        playlist.uri = pl.uri
        playlist.name = pl.name
        playlist.creator = pl.owner.uri
        playlist.tracking = true
        playlist.gen_new_list = false
        playlist.owner = @spotify_user.uri
        playlist.ptype = "original"
        pl.tracks.each do |t|
          track = Track.new
          track.uri = t.uri
          track.name = t.name
          playlist.tracks << track
        end
        playlist.save
      else

      end
      # #Search thru ur pls for the current pl uri, if it exists, don't make a new one
    end

  end
end
