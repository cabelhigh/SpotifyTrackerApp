require 'rails_helper'

RSpec.describe "tracks/edit", type: :view do
  before(:each) do
    @track = assign(:track, Track.create!(
      :uri => "",
      :name => "",
      :playlist => nil
    ))
  end

  it "renders the edit track form" do
    render

    assert_select "form[action=?][method=?]", track_path(@track), "post" do

      assert_select "input#track_uri[name=?]", "track[uri]"

      assert_select "input#track_name[name=?]", "track[name]"

      assert_select "input#track_playlist_id[name=?]", "track[playlist_id]"
    end
  end
end
