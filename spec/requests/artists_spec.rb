require 'rails_helper'

RSpec.describe "Artists", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/artists/show"
      expect(response).to have_http_status(:success)
    end
  end

end
