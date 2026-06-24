require "rails_helper"

RSpec.describe "JobSeeker::Accommodations", type: :request do
  let(:job_seeker) { create_job_seeker }

  before { sign_in job_seeker.user }

  describe "GET /job_seeker/accommodations/new" do
    it "未登録なら登録フォームを表示できる" do
      get new_job_seeker_accommodations_path
      expect(response).to have_http_status(:ok)
    end

    it "登録済みなら編集画面へリダイレクトされる" do
      tag = create_accommodation_tag(name: "静かな個室あり")
      JobSeekerAccommodation.create!(job_seeker: job_seeker, accommodation_tag: tag, priority: :required)

      get new_job_seeker_accommodations_path
      expect(response).to redirect_to(edit_job_seeker_accommodations_path)
    end
  end

  describe "POST /job_seeker/accommodations" do
    it "必須・希望の配慮を保存し、一覧へリダイレクトされる" do
      required = create_accommodation_tag(name: "静かな個室あり")
      preferred = create_accommodation_tag(name: "フルリモート可")

      post job_seeker_accommodations_path, params: {
        accommodations: { required.id.to_s => "required", preferred.id.to_s => "preferred" }
      }

      expect(response).to redirect_to(job_seeker_accommodations_path)
      expect(job_seeker.required_accommodation_tags).to include(required)
      expect(job_seeker.preferred_accommodation_tags).to include(preferred)
    end
  end

  describe "GET /job_seeker/accommodations/edit" do
    it "編集フォームを表示できる" do
      get edit_job_seeker_accommodations_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /job_seeker/accommodations" do
    it "配慮の登録内容を更新できる" do
      tag = create_accommodation_tag(name: "時短勤務可", category: "schedule")

      patch job_seeker_accommodations_path, params: {
        accommodations: { tag.id.to_s => "required" }
      }

      expect(response).to redirect_to(job_seeker_accommodations_path)
      expect(job_seeker.required_accommodation_tags).to include(tag)
    end
  end
end
