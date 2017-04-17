require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, "13c33594a47d498fbcefb942a3d6193a", "be301da18e4342c69952a036b716be70", scope: 'user-read-email playlist-modify-public user-library-read user-library-modify playlist-read-private playlist-modify-private'
end
