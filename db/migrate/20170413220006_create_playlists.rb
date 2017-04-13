class CreatePlaylists < ActiveRecord::Migration[5.0]
  def change
    create_table :playlists do |t|
      t.string :uri
      t.string :name
      t.string :creator
      t.boolean :tracking
      t.boolean :gen_new_list

      t.timestamps
    end
  end
end
