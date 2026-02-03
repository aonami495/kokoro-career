module ApplicationHelper
  # Application（応募）ステータス
  def application_status_label(application)
    case application.status
    when "pending"
      "選考中"
    when "accepted"
      "承認"
    when "rejected"
      "見送り"
    else
      application.status
    end
  end

  def application_status_class(application)
    case application.status
    when "pending"
      "bg-orange-100 text-orange-700"
    when "accepted"
      "bg-green-100 text-green-700"
    when "rejected"
      "bg-gray-100 text-gray-600"
    else
      "bg-gray-100 text-gray-600"
    end
  end

  # Internship（実習）ステータス
  def internship_status_label(internship)
    case internship.status
    when "pending"
      "回答待ち"
    when "accepted"
      "実習確定"
    when "in_progress"
      "実習中"
    when "completed"
      "実習完了"
    when "hired"
      "本採用決定"
    else
      internship.status
    end
  end

  def internship_status_class(internship)
    case internship.status
    when "pending"
      "bg-yellow-100 text-yellow-700"
    when "accepted"
      "bg-blue-100 text-blue-700"
    when "in_progress"
      "bg-purple-100 text-purple-700"
    when "completed"
      "bg-gray-100 text-gray-600"
    when "hired"
      "bg-green-100 text-green-700"
    else
      "bg-gray-100 text-gray-600"
    end
  end
end
