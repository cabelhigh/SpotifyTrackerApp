class AddPTypeToPlaylists < ActiveRecord::Migration[5.0]
  def change
    add_column :playlists, :ptype, :string
  end
end
