module Admin
  class JobsController < BaseController
    def index
      @jobs = Job.includes(:company).order(created_at: :desc).limit(100)
    end

    def destroy
      @job = Job.find(params[:id])
      company_name = @job.company&.company_name || "不明"
      title = @job.title

      @job.destroy
      flash[:notice] = "求人「#{title}」（#{company_name}）を削除しました"

      redirect_to admin_jobs_path
    end
  end
end
