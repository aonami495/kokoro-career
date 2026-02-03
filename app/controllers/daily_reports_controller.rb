class DailyReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_internship
  before_action :authorize_access

  def create
    @daily_report = @internship.daily_reports.build(daily_report_params)
    @daily_report.user = current_user
    @daily_report.report_date ||= Date.current

    if @daily_report.save
      redirect_to internship_path(@internship), notice: "日報を投稿しました"
    else
      redirect_to internship_path(@internship), alert: @daily_report.errors.full_messages.join(", ")
    end
  end

  private

  def set_internship
    @internship = Internship.find(params[:internship_id])
  end

  def authorize_access
    job_seeker_access = current_user.job_seeker? && @internship.job_seeker == current_user.job_seeker
    company_access = current_user.company? && @internship.company == current_user.company

    unless job_seeker_access || company_access
      redirect_to root_path, alert: "アクセス権限がありません"
    end

    # 日報は実習中のみ投稿可能
    unless @internship.in_progress? || @internship.completed?
      redirect_to internship_path(@internship), alert: "この実習では日報を投稿できません"
    end
  end

  def daily_report_params
    params.require(:daily_report).permit(:content, :report_date)
  end
end
