require 'rails_helper'

RSpec.describe "JobSeeker::Accommodations", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/job_seeker/accommodations/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/job_seeker/accommodations/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/job_seeker/accommodations/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/job_seeker/accommodations/update"
      expect(response).to have_http_status(:success)
    end
  end

end
