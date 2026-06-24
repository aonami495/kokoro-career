require "rails_helper"

RSpec.describe "Company::Jobs", type: :request do
  let(:company) { create_company }

  before { sign_in company.user }

  describe "GET /company/jobs" do
    it "自社の求人一覧を表示できる" do
      create_job(company: company)

      get company_jobs_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /company/jobs/new" do
    it "求人作成フォームを表示できる" do
      get new_company_job_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /company/jobs" do
    it "有効な値で求人を作成し、一覧へリダイレクトされる" do
      expect {
        post company_jobs_path, params: { job: { title: "新しい求人", status: "published" } }
      }.to change(company.jobs, :count).by(1)

      expect(response).to redirect_to(company_jobs_path)
    end

    it "タイトルが空だと作成されず 422 を返す" do
      expect {
        post company_jobs_path, params: { job: { title: "", status: "published" } }
      }.not_to change(Job, :count)

      expect(response).to have_http_status(422)
    end
  end

  describe "GET /company/jobs/:id/edit" do
    it "自社求人の編集フォームを表示できる" do
      job = create_job(company: company)

      get edit_company_job_path(job)
      expect(response).to have_http_status(:ok)
    end

    it "他社の求人は編集できない（404）" do
      other_job = create_job(company: create_company)

      get edit_company_job_path(other_job)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /company/jobs/:id" do
    it "自社求人を更新し、一覧へリダイレクトされる" do
      job = create_job(company: company, title: "旧タイトル")

      patch company_job_path(job), params: { job: { title: "新タイトル" } }

      expect(response).to redirect_to(company_jobs_path)
      expect(job.reload.title).to eq("新タイトル")
    end
  end
end
