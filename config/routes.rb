Rails.application.routes.draw do
  get 'users/spotify'

  resources :tracks
  resources :playlists

  get 'playlist/update_all', to: 'playlists#update_all_new_tracks'

  root 'playlists#landing_page'

  get '/auth/spotify/callback', to: 'users#spotify'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
