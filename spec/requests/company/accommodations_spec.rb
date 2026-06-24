require "rails_helper"

RSpec.describe "Company::Accommodations", type: :request do
  let(:company) { create_company }

  before { sign_in company.user }

  describe "GET /company/accommodations" do
    it "提供可能な配慮の一覧を表示できる" do
      get company_accommodations_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /company/accommodations/edit" do
    it "配慮の編集フォームを表示できる" do
      create_accommodation_tag(name: "静かな個室あり")

      get edit_company_accommodations_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /company/accommodations" do
    it "選択した配慮タグを保存し、一覧へリダイレクトされる" do
      tag = create_accommodation_tag(name: "フルリモート可")

      patch company_accommodations_path, params: {
        accommodations: { tag.id.to_s => { selected: "1", detail_description: "全社リモート可" } }
      }

      expect(response).to redirect_to(company_accommodations_path)
      expect(company.accommodation_tags).to include(tag)
    end

    it "未選択のタグは保存されない" do
      tag = create_accommodation_tag(name: "時短勤務可", category: "schedule")

      patch company_accommodations_path, params: {
        accommodations: { tag.id.to_s => { selected: "0" } }
      }

      expect(company.accommodation_tags).not_to include(tag)
    end
  end
end
