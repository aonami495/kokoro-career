class Company::AccommodationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_company
  before_action :set_tags, only: [:edit]

  def show
    @accommodations = current_company.company_accommodations.includes(:accommodation_tag)
  end

  def edit
    @selected_accommodations = current_company.company_accommodations.index_by(&:accommodation_tag_id)
  end

  def update
    save_accommodations
    redirect_to company_accommodations_path, notice: "配慮タグを更新しました"
  end

  private

  def set_tags
    @tags_by_category = AccommodationTag.ordered.group_by(&:category)
  end

  def save_accommodations
    current_company.company_accommodations.destroy_all

    return unless params[:accommodations].present?

    params[:accommodations].each do |tag_id, data|
      next if data[:selected] != "1"

      current_company.company_accommodations.create!(
        accommodation_tag_id: tag_id,
        detail_description: data[:detail_description].presence
      )
    end
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
