require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #spotify" do
    it "returns http success" do
      get :spotify
      expect(response).to have_http_status(:success)
    end
  end

end
