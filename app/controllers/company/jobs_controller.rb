class Company::JobsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_company
  before_action :set_job, only: [:edit, :update]

  def index
    @jobs = current_company.jobs.order(created_at: :desc)
  end

  def new
    @job = current_company.jobs.build
  end

  def create
    @job = current_company.jobs.build(job_params)

    if @job.save
      redirect_to company_jobs_path, notice: "求人を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @job.update(job_params)
      redirect_to company_jobs_path, notice: "求人を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_job
    @job = current_company.jobs.find(params[:id])
  end

  def job_params
    params.require(:job).permit(
      :title,
      :job_type,
      :description,
      :location,
      :salary_min,
      :salary_max,
      :internship_available,
      :status
    )
  end

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
