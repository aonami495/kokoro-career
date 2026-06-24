require "rails_helper"

RSpec.describe "Jobs", type: :request do
  describe "GET /jobs" do
    it "公開求人一覧を表示できる（未ログインでも閲覧可）" do
      create_job(company: create_company, status: :published)

      get jobs_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /jobs（N+1 ガード）" do
    it "求人・企業が増えてもSQLクエリ数が件数に比例しない" do
      tag = create_accommodation_tag(name: "静かな個室あり")
      seeker = create_job_seeker
      JobSeekerAccommodation.create!(job_seeker: seeker, accommodation_tag: tag, priority: :required)
      sign_in seeker.user

      add_company_with_job = lambda do |label|
        company = create_company(company_name: label)
        CompanyAccommodation.create!(company: company, accommodation_tag: tag)
        create_job(company: company, status: :published)
      end

      # まず2社（各1求人）
      2.times { |i| add_company_with_job.call("S#{i}") }
      baseline = count_queries { get jobs_path }
      expect(response).to have_http_status(:ok)

      # さらに8社追加（計10社＝5倍）
      8.times { |i| add_company_with_job.call("L#{i}") }
      scaled = count_queries { get jobs_path }
      expect(response).to have_http_status(:ok)

      # N+1 が無ければ件数が5倍でもクエリ数はほぼ一定（許容スラック +3）
      expect(scaled).to be <= baseline + 3
    end
  end

  describe "GET /jobs/:id" do
    it "公開求人の詳細を表示できる" do
      job = create_job(company: create_company, status: :published)

      get job_path(job)
      expect(response).to have_http_status(:ok)
    end

    it "下書き(draft)の求人は公開されていないため404" do
      job = create_job(company: create_company, status: :draft)

      get job_path(job)
      expect(response).to have_http_status(:not_found)
    end
  end
end
