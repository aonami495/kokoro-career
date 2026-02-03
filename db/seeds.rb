# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# 配慮タグのシードデータ
accommodation_tags_data = [
  # カテゴリ1: 作業環境 (environment) - 8個
  {
    name: "静かな個室あり",
    category: "environment",
    description: "音に敏感な方向けの個室または防音ブース",
    display_order: 1
  },
  {
    name: "パーティション席",
    category: "environment",
    description: "視覚的な刺激を減らすための間仕切り席",
    display_order: 2
  },
  {
    name: "在宅勤務可（週3日以上）",
    category: "environment",
    description: "週の半分以上を在宅で勤務可能",
    display_order: 3
  },
  {
    name: "在宅勤務可（週1-2日）",
    category: "environment",
    description: "部分的なリモートワーク",
    display_order: 4
  },
  {
    name: "フルリモート可",
    category: "environment",
    description: "完全在宅勤務",
    display_order: 5
  },
  {
    name: "照明調整可",
    category: "environment",
    description: "デスクライトの使用、明るさ調整",
    display_order: 6
  },
  {
    name: "休憩スペースあり",
    category: "environment",
    description: "落ち着ける別室や休憩室",
    display_order: 7
  },
  {
    name: "騒音の少ない環境",
    category: "environment",
    description: "静かなオフィス、工場の騒音なし",
    display_order: 8
  },

  # カテゴリ2: コミュニケーション (communication) - 8個
  {
    name: "指示は文書で",
    category: "communication",
    description: "口頭ではなく、メール・チャットで明確に指示",
    display_order: 9
  },
  {
    name: "チャットツール使用",
    category: "communication",
    description: "Slack、Teams等での非同期コミュニケーション",
    display_order: 10
  },
  {
    name: "1on1定例あり",
    category: "communication",
    description: "週1回または隔週で上司との面談",
    display_order: 11
  },
  {
    name: "報連相のフォーマットあり",
    category: "communication",
    description: "報告の型が決まっている（テンプレート使用）",
    display_order: 12
  },
  {
    name: "会議は事前に議題共有",
    category: "communication",
    description: "アジェンダを事前送付、突然の議題変更なし",
    display_order: 13
  },
  {
    name: "電話対応なし",
    category: "communication",
    description: "電話応対を業務に含まない",
    display_order: 14
  },
  {
    name: "質問しやすい雰囲気",
    category: "communication",
    description: "何度聞いても怒られない、心理的安全性",
    display_order: 15
  },
  {
    name: "ゆっくり話す上司",
    category: "communication",
    description: "早口でなく、穏やかな話し方",
    display_order: 16
  },

  # カテゴリ3: 勤務時間 (schedule) - 7個
  {
    name: "時短勤務可（週20時間～）",
    category: "schedule",
    description: "週4時間×5日、または週5時間×4日など",
    display_order: 17
  },
  {
    name: "時短勤務可（週30時間～）",
    category: "schedule",
    description: "週6時間×5日など、フルタイムに近い時短",
    display_order: 18
  },
  {
    name: "フレックスタイム",
    category: "schedule",
    description: "始業・終業時刻を自由に調整可能",
    display_order: 19
  },
  {
    name: "通院配慮あり",
    category: "schedule",
    description: "月1-2回の通院時に休暇取得または早退可",
    display_order: 20
  },
  {
    name: "シフト制（希望考慮）",
    category: "schedule",
    description: "シフトを本人の希望に合わせて調整",
    display_order: 21
  },
  {
    name: "休憩時間の柔軟化",
    category: "schedule",
    description: "疲れたら随時休憩可（トータル1時間など）",
    display_order: 22
  },
  {
    name: "残業なし",
    category: "schedule",
    description: "定時退社が基本、突発残業なし",
    display_order: 23
  },

  # カテゴリ4: サポート体制 (support) - 7個
  {
    name: "ジョブコーチ常駐",
    category: "support",
    description: "職場適応援助者が常駐または定期訪問",
    display_order: 24
  },
  {
    name: "メンター制度",
    category: "support",
    description: "先輩社員が業務・生活面をサポート",
    display_order: 25
  },
  {
    name: "産業医面談あり",
    category: "support",
    description: "月1回または必要時に産業医と面談",
    display_order: 26
  },
  {
    name: "カウンセリング利用可",
    category: "support",
    description: "社内または提携カウンセラーへの相談可",
    display_order: 27
  },
  {
    name: "定期面談（上司）",
    category: "support",
    description: "週1回または隔週で上司と振り返り",
    display_order: 28
  },
  {
    name: "就労支援機関との連携",
    category: "support",
    description: "就労移行支援事業所と定期的に情報共有",
    display_order: 29
  },
  {
    name: "段階的業務増加",
    category: "support",
    description: "最初は簡単な業務から、徐々に難易度を上げる",
    display_order: 30
  }
]

# シードデータの投入
accommodation_tags_data.each do |tag_data|
  AccommodationTag.find_or_create_by!(name: tag_data[:name]) do |tag|
    tag.category = tag_data[:category]
    tag.description = tag_data[:description]
    tag.display_order = tag_data[:display_order]
  end
end

puts "✅ 配慮タグ #{AccommodationTag.count} 件を作成しました"

# カテゴリ別の件数を表示
AccommodationTag::CATEGORIES.each do |category|
  count = AccommodationTag.where(category: category).count
  puts "   - #{category}: #{count} 件"
end
