require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, "13c33594a47d498fbcefb942a3d6193a", "9d243cbe30a14b1da2873b66ca4f80cd", scope: 'user-read-email playlist-modify-public user-library-read user-library-modify'
end
