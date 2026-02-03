class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_application
  before_action :authorize_access

  def index
    @messages = @application.messages.includes(:sender, :recipient).order(created_at: :asc)
    mark_messages_as_read
    @job = @application.job
    @job_seeker = @application.job_seeker
    @company = @job.company
  end

  def create
    @message = @application.messages.build(message_params)
    @message.sender = current_user
    @message.recipient = recipient_user

    if @message.save
      redirect_to application_messages_path(@application), notice: "メッセージを送信しました"
    else
      @messages = @application.messages.includes(:sender, :recipient).order(created_at: :asc)
      @job = @application.job
      @job_seeker = @application.job_seeker
      @company = @job.company
      flash.now[:alert] = @message.errors.full_messages.join(", ")
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_application
    @application = Application.find(params[:application_id])
  end

  def authorize_access
    # 求職者本人または企業担当者のみアクセス可能
    unless authorized_user?
      redirect_to root_path, alert: "アクセス権限がありません"
    end
  end

  def authorized_user?
    if current_user.job_seeker?
      @application.job_seeker == current_user.job_seeker
    elsif current_user.company?
      @application.job.company == current_user.company
    else
      false
    end
  end

  def recipient_user
    if current_user.job_seeker?
      # 求職者が送信 → 企業担当者へ
      @application.job.company.user
    else
      # 企業が送信 → 求職者へ
      @application.job_seeker.user
    end
  end

  def mark_messages_as_read
    @application.messages.where(recipient: current_user).unread.find_each(&:mark_as_read!)
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
