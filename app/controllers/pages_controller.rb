class PagesController < ApplicationController
  def enterprise_guide
    # 静的ページなので特別な処理は不要
  end

  def home
    # トップページ用（将来的にroot_pathとして使用）
    @published_jobs_count = Job.published.count
    @companies_count = Company.count
  end
end
