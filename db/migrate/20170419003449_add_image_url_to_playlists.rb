class AddImageUrlToPlaylists < ActiveRecord::Migration[5.0]
  def change
    add_column :playlists, :image_url, :string
  end
end
