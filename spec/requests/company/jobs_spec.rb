require 'rails_helper'

RSpec.describe "Company::Jobs", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/company/jobs/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/company/jobs/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/company/jobs/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/company/jobs/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/company/jobs/update"
      expect(response).to have_http_status(:success)
    end
  end

end
