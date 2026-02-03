module Company::JobsHelper
  JOB_STATUS_LABELS = {
    "draft" => "下書き",
    "published" => "公開中",
    "closed" => "募集終了"
  }.freeze

  JOB_TYPE_OPTIONS = [
    ["正社員", "正社員"],
    ["契約社員", "契約社員"],
    ["パート・アルバイト", "パート・アルバイト"],
    ["業務委託", "業務委託"]
  ].freeze

  def job_status_label(status)
    JOB_STATUS_LABELS[status] || status
  end

  def job_status_class(status)
    case status
    when "draft" then "bg-gray-100 text-gray-700"
    when "published" then "bg-green-100 text-green-700"
    when "closed" then "bg-red-100 text-red-700"
    else "bg-gray-100 text-gray-700"
    end
  end

  def job_status_border_class(status)
    case status
    when "draft" then "border-gray-300"
    when "published" then "border-green-500"
    when "closed" then "border-red-500"
    else "border-gray-300"
    end
  end

  def job_status_options_for_select
    Job.statuses.map { |k, v| [job_status_label(k), k] }
  end
end
