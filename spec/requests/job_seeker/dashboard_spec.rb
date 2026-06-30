require "rails_helper"

RSpec.describe "JobSeeker::Dashboards", type: :request do
  describe "GET /job_seeker/dashboard" do
    it "求職者ユーザーはダッシュボードを表示できる" do
      sign_in create_job_seeker.user

      get job_seeker_dashboard_path
      expect(response).to have_http_status(:ok)
    end

    it "未ログインはログイン画面へリダイレクトされる" do
      get job_seeker_dashboard_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "企業ユーザーは root へリダイレクトされる" do
      sign_in create_company.user

      get job_seeker_dashboard_path
      expect(response).to redirect_to(root_path)
    end

    # INC-2 回帰テスト: GETで JobSeeker レコードを生成しないこと
    it "プロフィール未生成の求職者ユーザーがGETしてもJobSeekerレコードを増やさない" do
      user = create_user(user_type: :job_seeker)
      sign_in user

      expect { get job_seeker_dashboard_path }.not_to change(JobSeeker, :count)
    end

    it "プロフィール未生成の求職者ユーザーはGETで root へリダイレクトされる" do
      user = create_user(user_type: :job_seeker)
      sign_in user

      get job_seeker_dashboard_path
      expect(response).to redirect_to(root_path)
    end
  end

  # INC-2 回帰テスト: 登録時にJobSeekerレコードが生成されること
  describe "POST /users（サインアップ）" do
    it "求職者として登録するとJobSeekerレコードが同時に生成される" do
      expect {
        post user_registration_path, params: {
          user: { name: "新規求職者", email: "newseeker@example.com", password: "password", user_type: "job_seeker" }
        }
      }.to change(JobSeeker, :count).by(1)

      user = User.find_by(email: "newseeker@example.com")
      expect(user.job_seeker).to be_present
    end
  end
end
