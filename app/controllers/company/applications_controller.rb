class Company::ApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_company

  def index
    @applications = current_company.applications
                                   .includes(job_seeker: :user, job: {}, internship: {})
                                   .order(created_at: :desc)
    @pending_count = @applications.count(&:pending?)
  end

  private

  def ensure_company
    unless current_user&.company? && current_user.company
      redirect_to root_path, alert: "企業アカウントのみアクセスできます"
    end
  end

  def current_company
    current_user.company
  end
  helper_method :current_company
end
