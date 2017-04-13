json.extract! playlist, :id, :uri, :name, :creator, :tracking, :gen_new_list, :created_at, :updated_at
json.url playlist_url(playlist, format: :json)
