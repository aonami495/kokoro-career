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

    # INC-2 回帰テスト: GETで Company レコードを生成しないこと
    it "プロフィール未生成の企業ユーザーがGETしてもCompanyレコードを増やさない" do
      user = create_user(user_type: :company)
      sign_in user

      expect { get company_dashboard_path }.not_to change(Company, :count)
    end

    it "プロフィール未生成の企業ユーザーはGETで root へリダイレクトされる" do
      user = create_user(user_type: :company)
      sign_in user

      get company_dashboard_path
      expect(response).to redirect_to(root_path)
    end
  end

  # INC-2 回帰テスト: 登録時にCompanyレコードが生成されること
  describe "POST /users（サインアップ）" do
    it "企業として登録するとCompanyレコードが同時に生成される" do
      expect {
        post user_registration_path, params: {
          user: { name: "新規企業", email: "newco@example.com", password: "password", user_type: "company" }
        }
      }.to change(Company, :count).by(1)

      user = User.find_by(email: "newco@example.com")
      expect(user.company).to be_present
    end
  end
end
