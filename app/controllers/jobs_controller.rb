class JobsController < ApplicationController
  def index
    @jobs = Job.published.includes(company: :accommodation_tags)

    # 配慮タグでフィルタリング
    if params[:accommodation_tag_ids].present?
      tag_ids = params[:accommodation_tag_ids].reject(&:blank?).map(&:to_i)
      if tag_ids.any?
        @jobs = @jobs.joins(company: :accommodation_tags)
                     .where(accommodation_tags: { id: tag_ids })
                     .distinct
      end
    end

    # 体験実習可のみフィルタリング
    if params[:internship_only] == "1"
      @jobs = @jobs.with_internship
    end

    # マッチ度計算＋ソート
    if current_user&.job_seeker? && current_user.job_seeker
      @jobs_with_score = @jobs.map do |job|
        { job: job, score: job.company.match_score(current_user.job_seeker) }
      end.sort_by { |item| -item[:score] }
    else
      @jobs_with_score = @jobs.order(created_at: :desc).map do |job|
        { job: job, score: nil }
      end
    end

    # フィルター用のタグ一覧
    @tags_by_category = AccommodationTag.ordered.group_by(&:category)
  end

  def show
    @job = Job.published.includes(company: :accommodation_tags).find(params[:id])
    @company = @job.company

    # マッチ度計算
    if current_user&.job_seeker? && current_user.job_seeker
      @match_score = @company.match_score(current_user.job_seeker)
    end

    # 応募状況を確認
    if current_user&.job_seeker?
      @application = current_user.job_seeker.applications.find_by(job: @job)
    end
  end

  private

  def current_job_seeker
    current_user&.job_seeker
  end
  helper_method :current_job_seeker
end
