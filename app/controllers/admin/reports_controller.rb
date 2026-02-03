module Admin
  class ReportsController < BaseController
    before_action :set_report, only: [:show, :update_status]

    def index
      @reports = Report.includes(:reporter, :target).recent
      @pending_reports = @reports.pending
      @resolved_reports = @reports.where.not(status: :pending)
    end

    def show
    end

    def update_status
      new_status = params[:status]

      if Report.statuses.key?(new_status)
        @report.update(status: new_status)
        flash[:notice] = "通報のステータスを「#{@report.status_label}」に変更しました"
      else
        flash[:alert] = "無効なステータスです"
      end

      redirect_to admin_reports_path
    end

    private

    def set_report
      @report = Report.find(params[:id])
    end
  end
end
