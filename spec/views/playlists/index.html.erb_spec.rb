require 'rails_helper'

RSpec.describe "playlists/index", type: :view do
  before(:each) do
    assign(:playlists, [
      Playlist.create!(
        :uri => "",
        :name => "",
        :creator => "",
        :tracking => "",
        :gen_new_list => false
      ),
      Playlist.create!(
        :uri => "",
        :name => "",
        :creator => "",
        :tracking => "",
        :gen_new_list => false
      )
    ])
  end

  it "renders a list of playlists" do
    render
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
