require "rails_helper"

RSpec.describe "Company::Dashboards", type: :request do
  describe "GET /company/dashboard" do
    it "企業ユーザーはダッシュボードを表示できる" do
      sign_in create_company.user

      get company_dashboard_path
      expect(response).to have_http_status(:ok)
    end

    it "未ログインはログイン画面へリダイレクトされる" do
      get company_dashboard_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "求職者ユーザーは root へリダイレクトされる" do
      sign_in create_job_seeker.user

      get company_dashboard_path
      expect(response).to redirect_to(root_path)
    end
  end
end
