require "rails_helper"

RSpec.describe "Jobs", type: :request do
  describe "GET /jobs" do
    it "公開求人一覧を表示できる（未ログインでも閲覧可）" do
      create_job(company: create_company, status: :published)

      get jobs_path
      expect(response).to have_http_status(:ok)
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
