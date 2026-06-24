require "rails_helper"

RSpec.describe "DailyReports", type: :request do
  let(:company) { create_company }
  let(:job_seeker) { create_job_seeker }
  let(:job) { create_job(company: company) }
  let(:application) { create_application(job_seeker: job_seeker, job: job) }
  let(:internship) { create_internship(application: application, status: status) }

  let(:valid_params) { { daily_report: { content: "本日の作業内容です", report_date: Date.current } } }

  def post_report
    post internship_daily_reports_path(internship), params: valid_params
  end

  context "実習中（in_progress）の当事者" do
    let(:status) { :in_progress }

    it "企業担当者は日報を投稿できる" do
      sign_in company.user
      expect { post_report }.to change(DailyReport, :count).by(1)
      expect(response).to redirect_to(internship_path(internship))
    end

    it "求職者本人は日報を投稿できる" do
      sign_in job_seeker.user
      expect { post_report }.to change(DailyReport, :count).by(1)
    end
  end

  context "実習開始前（pending）" do
    let(:status) { :pending }

    it "当事者でもステータス的に投稿できず、実習詳細へリダイレクトされる" do
      sign_in company.user
      expect { post_report }.not_to change(DailyReport, :count)
      expect(response).to redirect_to(internship_path(internship))
    end

    # 旧実装では「無権限 かつ pending」で redirect_to が二重に呼ばれ
    # AbstractController::DoubleRenderError（500）になっていた回帰テスト。
    it "無権限ユーザーが pending の実習に投稿しても500にならず root へリダイレクトされる" do
      outsider = create_company.user
      sign_in outsider
      expect { post_report }.not_to change(DailyReport, :count)
      expect(response).to redirect_to(root_path)
    end
  end

  # accepted も in_progress/completed ではないため、旧実装では無権限ユーザーで
  # 二重 redirect（500）になりえた。部分リバートにも気づけるよう別ステータスでも担保。
  context "実習確定前（accepted）に無権限ユーザーが投稿" do
    let(:status) { :accepted }

    it "500にならず root へリダイレクトされる" do
      sign_in create_company.user
      expect { post_report }.not_to change(DailyReport, :count)
      expect(response).to redirect_to(root_path)
    end
  end

  context "無権限ユーザー（実習中の実習に対して）" do
    let(:status) { :in_progress }

    it "root へリダイレクトされ投稿できない" do
      sign_in create_job_seeker.user
      expect { post_report }.not_to change(DailyReport, :count)
      expect(response).to redirect_to(root_path)
    end
  end
end
