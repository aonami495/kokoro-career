module Users
  # 公開のユーザー登録（Devise）。
  #
  # セキュリティ上の要点:
  #   User#user_type は enum で admin(9) / support_agency(2) を持つが、
  #   ApplicationController の Devise パラメータサニタイザは :user_type を許可する。
  #   そのため対策を入れないと、登録フォームのラジオ（求職者/企業）を無視して
  #   `user[user_type]=admin` を直接POSTするだけで管理者アカウントを作成でき、
  #   権限昇格となる。
  #
  #   ここで sign_up_params を許可リスト方式に絞り込み、公開登録から作れるのを
  #   求職者・企業に限定する。admin / support_agency はコンソールやシード
  #   （README の bin/rails runner 手順）からのみ作成する想定。
  class RegistrationsController < Devise::RegistrationsController
    ALLOWED_USER_TYPES = %w[job_seeker company].freeze

    # サインアップ完了直後にプロフィールレコードを1回だけ生成する。
    # GETに副作用を持たせない（INC-2）ためここで集約し、各コントローラーの
    # ensure_* では生成せず redirect のみに絞る。
    def after_sign_up_path_for(resource)
      case resource.user_type
      when "company"
        resource.create_company!(company_name: "未設定") unless resource.company
        company_dashboard_path
      when "job_seeker"
        resource.create_job_seeker! unless resource.job_seeker
        job_seeker_dashboard_path
      else
        super
      end
    end

    private

    def sign_up_params
      permitted = super
      requested = permitted[:user_type].to_s

      # 許可リスト外（admin など）が指定された場合は user_type を空にし、
      # モデルの presence バリデーションで弾く（=登録フォームを再表示）。
      return permitted if ALLOWED_USER_TYPES.include?(requested)

      permitted.merge(user_type: nil)
    end

    # user_type は登録後に変更不可。プロフィール更新（PATCH /users）では
    # 現状 Devise のデフォルトサニタイザが user_type を許可しないため安全だが、
    # 将来 :account_update に user_type が足されても昇格できないよう明示的に除去する。
    def account_update_params
      super.except("user_type", :user_type)
    end
  end
end
