class JobSeeker::AccommodationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_job_seeker
  before_action :set_tags, only: [:new, :edit]

  def show
    @required_tags = current_job_seeker.required_accommodation_tags
    @preferred_tags = current_job_seeker.preferred_accommodation_tags
  end

  def new
    # 既に登録済みの場合は編集画面へリダイレクト
    if current_job_seeker.job_seeker_accommodations.any?
      redirect_to edit_job_seeker_accommodations_path
    end
  end

  def create
    save_accommodations
    redirect_to job_seeker_accommodations_path, notice: "配慮タグを登録しました"
  end

  def edit
    @selected_accommodations = current_job_seeker.job_seeker_accommodations.index_by(&:accommodation_tag_id)
  end

  def update
    save_accommodations
    redirect_to job_seeker_accommodations_path, notice: "配慮タグを更新しました"
  end

  private

  def set_tags
    @tags_by_category = AccommodationTag.ordered.group_by(&:category)
  end

  def save_accommodations
    current_job_seeker.job_seeker_accommodations.destroy_all

    return unless params[:accommodations].present?

    params[:accommodations].each do |tag_id, priority|
      next if priority.blank? || priority == "none"

      current_job_seeker.job_seeker_accommodations.create!(
        accommodation_tag_id: tag_id,
        priority: priority
      )
    end
  end

  def ensure_job_seeker
    unless current_user&.job_seeker?
      redirect_to root_path, alert: "求職者のみアクセスできます"
      return
    end

    # JobSeekerレコードがなければ作成
    unless current_user.job_seeker
      current_user.create_job_seeker!
    end
  end

  def current_job_seeker
    current_user.job_seeker
  end
  helper_method :current_job_seeker
end
