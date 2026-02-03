class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_target

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)
    @report.reporter = current_user
    @report.target = @target

    if @report.save
      flash[:notice] = "通報を受け付けました。ご協力ありがとうございます。"
      redirect_to after_report_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_target
    @target_type = params[:target_type]
    @target_id = params[:target_id]

    case @target_type
    when "Job"
      @target = Job.find(@target_id)
    when "User"
      @target = User.find(@target_id)
    else
      flash[:alert] = "通報対象が不正です"
      redirect_to root_path
    end
  end

  def report_params
    params.require(:report).permit(:reason, :description)
  end

  def after_report_path
    case @target
    when Job
      job_path(@target)
    when User
      root_path
    else
      root_path
    end
  end
end
