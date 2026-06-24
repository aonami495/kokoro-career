require "rails_helper"

RSpec.describe "Users::Registrations", type: :request do
  let(:base_params) do
    { name: "新規ユーザー", email: "newuser@example.com", password: "password" }
  end

  def sign_up_with(user_type)
    post user_registration_path, params: { user: base_params.merge(user_type: user_type) }
  end

  describe "正常系" do
    it "求職者として登録できる" do
      expect { sign_up_with("job_seeker") }.to change(User, :count).by(1)
      expect(User.find_by(email: "newuser@example.com")).to be_job_seeker
    end

    it "企業として登録できる" do
      expect { sign_up_with("company") }.to change(User, :count).by(1)
      expect(User.find_by(email: "newuser@example.com")).to be_company
    end
  end

  describe "権限昇格の防止（新規登録）" do
    # これが本丸の回帰テスト：許可リストを外すと "admin" は有効な enum ラベルなので
    # 実際に管理者が作成され、このテストは fail する。
    it "user_type=admin を指定しても管理者は作成されず、サインインもされない" do
      expect { sign_up_with("admin") }.not_to change(User, :count)
      expect(User.where(user_type: :admin)).to be_empty
      expect(User.find_by(email: "newuser@example.com")).to be_nil

      # 失敗した登録ではログイン状態にならない（保護されたページに入れない）
      get job_seeker_dashboard_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "user_type=support_agency を指定しても作成されない" do
      expect { sign_up_with("support_agency") }.not_to change(User, :count)
      expect(User.find_by(email: "newuser@example.com")).to be_nil
    end
  end

  describe "権限昇格の防止（プロフィール更新 / account_update）" do
    it "ログイン済み求職者が user_type=admin へ更新しても昇格できない" do
      seeker = create_job_seeker
      user = seeker.user
      sign_in user

      patch user_registration_path, params: {
        user: { user_type: "admin", current_password: "password" }
      }

      expect(user.reload).to be_job_seeker
      expect(user).not_to be_admin
    end
  end
end
