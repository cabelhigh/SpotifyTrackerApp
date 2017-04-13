require 'rails_helper'

RSpec.describe "playlists/edit", type: :view do
  before(:each) do
    @playlist = assign(:playlist, Playlist.create!(
      :uri => "",
      :name => "",
      :creator => "",
      :tracking => "",
      :gen_new_list => false
    ))
  end

  it "renders the edit playlist form" do
    render

    assert_select "form[action=?][method=?]", playlist_path(@playlist), "post" do

      assert_select "input#playlist_uri[name=?]", "playlist[uri]"

      assert_select "input#playlist_name[name=?]", "playlist[name]"

      assert_select "input#playlist_creator[name=?]", "playlist[creator]"

      assert_select "input#playlist_tracking[name=?]", "playlist[tracking]"

      assert_select "input#playlist_gen_new_list[name=?]", "playlist[gen_new_list]"
    end
  end
end
