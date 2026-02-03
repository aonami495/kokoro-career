module Admin
  class AccommodationTagsController < BaseController
    before_action :set_accommodation_tag, only: [:edit, :update, :destroy]

    def index
      @accommodation_tags = AccommodationTag.order(:category, :display_order)
      @tags_by_category = @accommodation_tags.group_by(&:category)
    end

    def new
      @accommodation_tag = AccommodationTag.new
    end

    def create
      @accommodation_tag = AccommodationTag.new(accommodation_tag_params)

      if @accommodation_tag.save
        flash[:notice] = "配慮タグ「#{@accommodation_tag.name}」を作成しました"
        redirect_to admin_accommodation_tags_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @accommodation_tag.update(accommodation_tag_params)
        flash[:notice] = "配慮タグ「#{@accommodation_tag.name}」を更新しました"
        redirect_to admin_accommodation_tags_path
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      name = @accommodation_tag.name
      @accommodation_tag.destroy
      flash[:notice] = "配慮タグ「#{name}」を削除しました"
      redirect_to admin_accommodation_tags_path
    end

    private

    def set_accommodation_tag
      @accommodation_tag = AccommodationTag.find(params[:id])
    end

    def accommodation_tag_params
      params.require(:accommodation_tag).permit(:name, :category, :description, :display_order)
    end
  end
end
