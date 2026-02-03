module Admin
  class UsersController < BaseController
    def index
      @users = User.order(created_at: :desc).limit(100)
    end

    def destroy
      @user = User.find(params[:id])

      if @user.admin?
        flash[:alert] = "管理者ユーザーは削除できません"
      else
        @user.destroy
        flash[:notice] = "ユーザー「#{@user.name}」を削除しました"
      end

      redirect_to admin_users_path
    end
  end
end
