class ApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_job_seeker

  def create
    @job = Job.published.find(params[:job_id])
    @application = current_user.job_seeker.applications.build(
      job: @job,
      message: params[:application]&.dig(:message)
    )

    if @application.save
      redirect_to job_path(@job), notice: "応募が完了しました。企業からの連絡をお待ちください。"
    else
      redirect_to job_path(@job), alert: @application.errors.full_messages.join(", ")
    end
  end

  private

  def require_job_seeker
    unless current_user.job_seeker? && current_user.job_seeker
      redirect_to root_path, alert: "求職者プロフィールを作成してから応募してください"
    end
  end
end
