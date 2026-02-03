module JobsHelper
  CATEGORY_NAMES = {
    "environment" => "作業環境",
    "communication" => "コミュニケーション",
    "schedule" => "勤務時間",
    "support" => "サポート体制"
  }.freeze

  def category_name(category)
    CATEGORY_NAMES[category] || category
  end

  # マッチ度に応じたボーダー色クラス
  def match_border_class(score)
    return "border-gray-300" if score.nil?

    case score
    when 80..100 then "border-green-500"
    when 60..79 then "border-blue-500"
    when 40..59 then "border-yellow-500"
    else "border-gray-300"
    end
  end

  # マッチ度に応じたテキスト色クラス
  def match_text_class(score)
    return "text-gray-500" if score.nil?

    case score
    when 80..100 then "text-green-600"
    when 60..79 then "text-blue-600"
    when 40..59 then "text-yellow-600"
    else "text-gray-500"
    end
  end

  # マッチ度に応じた背景色クラス
  def match_bg_class(score)
    return "bg-gray-100" if score.nil?

    case score
    when 80..100 then "bg-green-50"
    when 60..79 then "bg-blue-50"
    when 40..59 then "bg-yellow-50"
    else "bg-gray-50"
    end
  end

  # マッチ度のラベル
  def match_label(score)
    return "---" if score.nil?

    case score
    when 80..100 then "高マッチ"
    when 60..79 then "良好"
    when 40..59 then "やや合う"
    when 1..39 then "低マッチ"
    else "不一致"
    end
  end

  # 給与表示フォーマット
  def format_salary(min, max)
    return "応相談" if min.blank? && max.blank?

    if min.present? && max.present?
      "#{number_with_delimiter(min)}〜#{number_with_delimiter(max)}円"
    elsif min.present?
      "#{number_with_delimiter(min)}円〜"
    else
      "〜#{number_with_delimiter(max)}円"
    end
  end

  # カテゴリ内のタグが選択されているかチェック
  def selected_tags_in_category?(category, tags)
    return false unless params[:accommodation_tag_ids].present?

    tag_ids = tags.map { |t| t.id.to_s }
    (params[:accommodation_tag_ids] & tag_ids).any?
  end
end
