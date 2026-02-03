class JobSeeker::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_job_seeker

  def show
    @applications = current_job_seeker.applications
                                      .includes(job: :company, internship: {})
                                      .order(created_at: :desc)
    @accommodation_count = current_job_seeker.accommodation_tags.count

    # 回答待ちの実習オファー（直接参照を使用）
    @pending_internships = current_job_seeker.internships
                                             .pending
                                             .includes(:company, :job)

    # 確定済み・進行中の実習（直接参照を使用）
    @active_internships = current_job_seeker.internships
                                            .active
                                            .includes(:company, :job)
  end

  private

  def ensure_job_seeker
    unless current_user&.job_seeker?
      redirect_to root_path, alert: "求職者アカウントのみアクセスできます"
      return
    end

    unless current_user.job_seeker
      current_user.create_job_seeker!
    end
  end

  def current_job_seeker
    current_user.job_seeker
  end
  helper_method :current_job_seeker
end
