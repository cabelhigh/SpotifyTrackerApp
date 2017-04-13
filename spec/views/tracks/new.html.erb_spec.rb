require 'rails_helper'

RSpec.describe "tracks/new", type: :view do
  before(:each) do
    assign(:track, Track.new(
      :uri => "",
      :name => "",
      :playlist => nil
    ))
  end

  it "renders new track form" do
    render

    assert_select "form[action=?][method=?]", tracks_path, "post" do

      assert_select "input#track_uri[name=?]", "track[uri]"

      assert_select "input#track_name[name=?]", "track[name]"

      assert_select "input#track_playlist_id[name=?]", "track[playlist_id]"
    end
  end
end
