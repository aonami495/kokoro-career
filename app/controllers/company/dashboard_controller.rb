class Company::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_company

  def show
    @jobs = current_company.jobs.order(created_at: :desc).limit(5)
    @accommodation_count = current_company.accommodation_tags.count
    @applications = current_company.applications
                                   .includes(job_seeker: :user, job: {}, internship: {})
                                   .order(created_at: :desc)
                                   .limit(10)
    @pending_count = current_company.applications.pending.count

    # 進行中・確定済みの実習（直接参照を使用）
    @active_internships = current_company.internships
                                         .active
                                         .includes(:job_seeker, :job)
                                         .order(:start_date)
  end

  private

  def ensure_company
    unless current_user&.company?
      redirect_to root_path, alert: "企業アカウントのみアクセスできます"
      return
    end

    unless current_user.company
      current_user.create_company!(company_name: "未設定")
    end
  end

  def current_company
    current_user.company
  end
  helper_method :current_company
end
