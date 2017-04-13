class AddOwnerToPlaylists < ActiveRecord::Migration[5.0]
  def change
    add_column :playlists, :owner, :string
  end
end
