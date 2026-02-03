require 'rails_helper'

RSpec.describe "Company::Dashboards", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/company/dashboard/show"
      expect(response).to have_http_status(:success)
    end
  end

end
