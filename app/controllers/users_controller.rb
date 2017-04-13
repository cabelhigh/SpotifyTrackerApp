require 'rspotify'

class UsersController < ApplicationController
  def spotify
    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    @spotify_user.playlists.each do |pl|
      
    end
  end
end
