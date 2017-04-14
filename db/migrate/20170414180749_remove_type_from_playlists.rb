class RemoveTypeFromPlaylists < ActiveRecord::Migration[5.0]
  def change
    remove_column :playlists, :type
  end
end
