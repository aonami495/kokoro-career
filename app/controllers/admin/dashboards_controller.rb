module Admin
  class DashboardsController < BaseController
    def show
      @total_users = User.count
      @job_seekers_count = User.job_seeker.count
      @companies_count = User.company.count
      @admins_count = User.admin.count

      @published_jobs_count = Job.published.count
      @total_jobs_count = Job.count

      @applications_count = Application.count
      @accepted_applications_count = Application.where(status: :accepted).count
      @hired_count = Internship.where(status: :hired).count

      @accommodation_tags = AccommodationTag.order(:category, :display_order)
      @tags_by_category = @accommodation_tags.group_by(&:category)
    end
  end
end
