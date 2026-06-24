# factory_bot を導入していないため、素の ActiveRecord でテストデータを組む薄いヘルパー。
module TestDataHelpers
  module_function

  # ブロック内で実行された実SQLクエリ数を数える（SCHEMA/トランザクション系は除外）。
  # N+1 の回帰テストに使う。
  def count_queries
    count = 0
    callback = lambda do |_name, _start, _finish, _id, payload|
      next if payload[:name] == "SCHEMA" || payload[:name] == "TRANSACTION"
      next if payload[:sql] =~ /\A\s*(BEGIN|COMMIT|ROLLBACK|SAVEPOINT|RELEASE)/i

      count += 1
    end
    ActiveSupport::Notifications.subscribed(callback, "sql.active_record") { yield }
    count
  end

  def unique_email(prefix = "user")
    @email_seq ||= 0
    @email_seq += 1
    "#{prefix}#{@email_seq}-#{SecureRandom.hex(4)}@example.com"
  end

  def create_user(user_type:, **attrs)
    User.create!(
      {
        name: "テスト#{user_type}",
        email: unique_email(user_type.to_s),
        password: "password",
        user_type: user_type
      }.merge(attrs)
    )
  end

  # 求職者ユーザー（User + JobSeeker）を作成して JobSeeker を返す
  def create_job_seeker(**attrs)
    user = create_user(user_type: :job_seeker)
    JobSeeker.create!({ user: user }.merge(attrs))
  end

  # 企業ユーザー（User + Company）を作成して Company を返す
  def create_company(**attrs)
    user = create_user(user_type: :company)
    Company.create!({ user: user, company_name: "テスト株式会社" }.merge(attrs))
  end

  def create_job(company:, **attrs)
    Job.create!(
      {
        company: company,
        title: "テスト求人",
        status: :published
      }.merge(attrs)
    )
  end

  def create_application(job_seeker:, job:, **attrs)
    Application.create!({ job_seeker: job_seeker, job: job }.merge(attrs))
  end

  # 実習を作成（application から company/job/job_seeker を自動補完）
  def create_internship(application:, status: :pending, **attrs)
    Internship.create!(
      {
        application: application,
        start_date: Date.current,
        end_date: Date.current + 13,
        status: status
      }.merge(attrs)
    )
  end

  def create_accommodation_tag(name:, category: "environment", **attrs)
    AccommodationTag.create!({ name: name, category: category }.merge(attrs))
  end
end
