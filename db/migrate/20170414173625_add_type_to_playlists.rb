class AddTypeToPlaylists < ActiveRecord::Migration[5.0]
  def change
    add_column :playlists, :type, :string
  end
end
