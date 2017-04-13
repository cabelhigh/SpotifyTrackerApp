json.extract! track, :id, :uri, :name, :playlist_id, :created_at, :updated_at
json.url track_url(track, format: :json)
