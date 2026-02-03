class InternshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_application, except: [:show, :update_status]
  before_action :set_internship, only: [:update]
  before_action :set_internship_directly, only: [:show, :update_status]

  # 実習詳細画面
  def show
    authorize_internship_access
    @daily_reports = @internship.daily_reports.by_date.includes(:user)
    @application = @internship.application
    @job = @internship.job
    @company = @internship.company
    @job_seeker = @internship.job_seeker
  end

  # 企業が実習オファーを作成
  def create
    unless current_user.company? && @application.job.company == current_user.company
      redirect_to root_path, alert: "アクセス権限がありません"
      return
    end

    if @application.internship.present?
      redirect_to application_messages_path(@application), alert: "既に実習オファーが存在します"
      return
    end

    @internship = @application.build_internship(internship_params)

    if @internship.save
      # 実習オファー作成時に応募ステータスを「承認」に変更
      @application.accepted!
      redirect_to application_messages_path(@application), notice: "実習オファーを送信しました"
    else
      redirect_to application_messages_path(@application), alert: @internship.errors.full_messages.join(", ")
    end
  end

  # 求職者がオファーに回答（承諾/辞退）
  def update
    unless current_user.job_seeker? && @application.job_seeker == current_user.job_seeker
      redirect_to root_path, alert: "アクセス権限がありません"
      return
    end

    case params[:response]
    when "accept"
      if @internship.pending?
        @internship.accepted!
        redirect_to job_seeker_dashboard_path, notice: "実習オファーを承諾しました。実習開始をお待ちください。"
      else
        redirect_to job_seeker_dashboard_path, alert: "このオファーは既に回答済みです"
      end
    when "decline"
      if @internship.pending?
        @internship.destroy
        redirect_to job_seeker_dashboard_path, notice: "実習オファーを辞退しました"
      else
        redirect_to job_seeker_dashboard_path, alert: "このオファーは既に回答済みです"
      end
    else
      redirect_to job_seeker_dashboard_path, alert: "不正なリクエストです"
    end
  end

  # 企業がステータスを変更
  def update_status
    unless current_user.company? && @internship.company == current_user.company
      redirect_to root_path, alert: "アクセス権限がありません"
      return
    end

    new_status = params[:status]
    allowed_transitions = {
      "accepted" => ["in_progress"],
      "in_progress" => ["completed"],
      "completed" => ["hired"]
    }

    if allowed_transitions[@internship.status]&.include?(new_status)
      @internship.update!(status: new_status)
      redirect_to internship_path(@internship), notice: status_change_message(new_status)
    else
      redirect_to internship_path(@internship), alert: "このステータス変更は許可されていません"
    end
  end

  private

  def set_application
    @application = Application.find(params[:application_id])
  end

  def set_internship
    @internship = @application.internship
    unless @internship
      redirect_to root_path, alert: "実習オファーが見つかりません"
    end
  end

  def set_internship_directly
    @internship = Internship.find(params[:id])
  end

  def authorize_internship_access
    job_seeker_access = current_user.job_seeker? && @internship.job_seeker == current_user.job_seeker
    company_access = current_user.company? && @internship.company == current_user.company

    unless job_seeker_access || company_access
      redirect_to root_path, alert: "アクセス権限がありません"
    end
  end

  def internship_params
    params.require(:internship).permit(:start_date, :end_date)
  end

  def status_change_message(status)
    case status
    when "in_progress"
      "実習を開始しました"
    when "completed"
      "実習が終了しました"
    when "hired"
      "本採用が決定しました！おめでとうございます"
    else
      "ステータスを更新しました"
    end
  end
end
