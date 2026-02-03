require 'rails_helper'

RSpec.describe "Company::Accommodations", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/company/accommodations/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/company/accommodations/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/company/accommodations/update"
      expect(response).to have_http_status(:success)
    end
  end

end
