require 'rspotify'

class UsersController < ApplicationController
  def spotify
    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    @test = request.env['omniauth.auth']
    @your_playlists = Playlist.where(owner: @spotify_user.uri)
    @spotify_user.playlists.each do |pl|
        Playlist.convert_playlist(pl, @spotify_user.uri) if @your_playlists.select{|y_pls| y_pls.uri==pl.uri}.empty? #grabs any new pls
    end

    session[:user_hash] = request.env['omniauth.auth'].to_yaml
  end
end
