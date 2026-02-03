module Company::AccommodationsHelper
  CATEGORY_NAMES = {
    "environment" => "作業環境",
    "communication" => "コミュニケーション",
    "schedule" => "勤務時間",
    "support" => "サポート体制"
  }.freeze

  def category_name(category)
    CATEGORY_NAMES[category] || category
  end

  def category_icon(category)
    case category
    when "environment" then "🏢"
    when "communication" then "💬"
    when "schedule" then "🕐"
    when "support" then "🤝"
    else ""
    end
  end
end
