# 通しテストスクリプト
# rails runner test_scenario.rb で実行

puts "\n" + "=" * 70
puts "🔍 ココロキャリア 通しテスト開始"
puts "=" * 70

# テスト結果を記録するハッシュ
results = {
  matching: {},
  application_message: {},
  internship: {},
  dashboard: {}
}

# ========================================
# 準備: テストデータのクリーンアップと作成
# ========================================
puts "\n📋 準備: テストデータの作成..."

# 既存のテストデータをクリーンアップ
DailyReport.destroy_all
Internship.destroy_all
Message.destroy_all
Application.destroy_all
Job.destroy_all
JobSeekerAccommodation.destroy_all
CompanyAccommodation.destroy_all
JobSeeker.destroy_all
Company.destroy_all
User.destroy_all

# 配慮タグがなければ作成
if AccommodationTag.count == 0
  puts "⚠️  配慮タグがありません。rails db:seed を実行してください。"
  exit 1
end

# 企業ユーザーを作成
company_user = User.create!(
  name: "テスト企業株式会社",
  email: "company@test.kokoro.jp",
  password: "password123",
  user_type: :company
)
company = Company.create!(
  user: company_user,
  company_name: "テスト企業株式会社",
  location: "東京都渋谷区",
  employee_count: 100,
  industry: "IT・ソフトウェア",
  description: "障がい者雇用に積極的な企業です"
)
puts "✅ 企業ユーザー作成: #{company_user.email}"

# 求職者ユーザーを作成
job_seeker_user = User.create!(
  name: "山田 太郎",
  email: "seeker@test.kokoro.jp",
  password: "password123",
  user_type: :job_seeker
)
job_seeker = JobSeeker.create!(
  user: job_seeker_user,
  disability_type: :mental,
  disability_certificate: true,
  preferred_location: "東京都",
  preferred_job_type: "事務",
  bio: "発達障害（ASD）の診断を受けています。静かな環境で集中して働きたいです。"
)
puts "✅ 求職者ユーザー作成: #{job_seeker_user.email}"

# ========================================
# 1. マッチング精度の確認
# ========================================
puts "\n" + "-" * 70
puts "【1. マッチング精度の確認】"
puts "-" * 70

# 企業: 配慮タグを登録（在宅勤務、チャットツール等）
remote_tag = AccommodationTag.find_by(name: "在宅勤務可（週3日以上）") || AccommodationTag.find_by(category: "environment")
chat_tag = AccommodationTag.find_by(name: "チャットツール使用") || AccommodationTag.find_by(category: "communication")
quiet_tag = AccommodationTag.find_by(name: "静かな個室あり") || AccommodationTag.where(category: "environment").second
flex_tag = AccommodationTag.find_by(name: "フレックスタイム") || AccommodationTag.find_by(category: "schedule")

# 企業に配慮タグを登録
[remote_tag, chat_tag, quiet_tag, flex_tag].compact.each do |tag|
  CompanyAccommodation.create!(
    company: company,
    accommodation_tag: tag,
    detail_description: "#{tag.name}に対応しています"
  )
end
puts "✅ 企業: 配慮タグ #{company.company_accommodations.count} 件を登録"
company.company_accommodations.includes(:accommodation_tag).each do |ca|
  puts "   - #{ca.accommodation_tag.name}"
end

# 求人を公開
job = Job.create!(
  company: company,
  title: "データ入力スタッフ（在宅勤務あり）",
  job_type: "事務",
  description: "自社データベースへの入力作業がメインです。静かな環境で集中して作業できます。",
  location: "東京都渋谷区（在宅勤務可）",
  salary_min: 180000,
  salary_max: 250000,
  internship_available: true,
  status: :published
)
puts "✅ 企業: 求人「#{job.title}」を公開"

# 求職者: 同じタグを「必須」にして登録
puts "\n📌 テスト1-1: 同じタグを「必須」で検索"
JobSeekerAccommodation.destroy_all
[remote_tag, chat_tag].compact.each do |tag|
  JobSeekerAccommodation.create!(
    job_seeker: job_seeker,
    accommodation_tag: tag,
    priority: :required
  )
end
puts "   求職者: 必須タグ #{job_seeker.job_seeker_accommodations.required.count} 件を登録"

# マッチ度を計算（企業と求職者の配慮タグマッチング）
match_score = MatchingService.calculate_score(company, job_seeker)
puts "   👉 マッチ度: #{match_score}%"

if match_score >= 80
  puts "   ✅ 結果: マッチ度が80%以上（#{match_score}%）で表示 → 合格"
  results[:matching][:same_tags] = { passed: true, score: match_score }
else
  puts "   ❌ 結果: マッチ度が80%未満（#{match_score}%）→ 不合格"
  results[:matching][:same_tags] = { passed: false, score: match_score }
end

# 求職者: 全く違うタグを「必須」にして検索
puts "\n📌 テスト1-2: 違うタグを「必須」で検索"
JobSeekerAccommodation.destroy_all

# 企業が登録していないタグを探す
company_tag_ids = company.company_accommodations.pluck(:accommodation_tag_id)
different_tags = AccommodationTag.where.not(id: company_tag_ids).limit(2)

different_tags.each do |tag|
  JobSeekerAccommodation.create!(
    job_seeker: job_seeker,
    accommodation_tag: tag,
    priority: :required
  )
end
puts "   求職者: 違う必須タグ #{job_seeker.job_seeker_accommodations.reload.required.count} 件を登録"
job_seeker.job_seeker_accommodations.includes(:accommodation_tag).each do |jsa|
  puts "   - #{jsa.accommodation_tag.name}"
end

# マッチ度を計算
match_score_diff = MatchingService.calculate_score(company, job_seeker)
puts "   👉 マッチ度: #{match_score_diff}%"

if match_score_diff <= 50
  puts "   ✅ 結果: マッチ度が50%以下（#{match_score_diff}%）で表示 → 合格"
  results[:matching][:different_tags] = { passed: true, score: match_score_diff }
else
  puts "   ❌ 結果: マッチ度が50%超（#{match_score_diff}%）→ 不合格"
  results[:matching][:different_tags] = { passed: false, score: match_score_diff }
end

# ========================================
# 2. 応募〜メッセージの確認
# ========================================
puts "\n" + "-" * 70
puts "【2. 応募〜メッセージの確認】"
puts "-" * 70

# 求職者: 配慮タグを元に戻す（マッチするように）
JobSeekerAccommodation.destroy_all
[remote_tag, chat_tag].compact.each do |tag|
  JobSeekerAccommodation.create!(
    job_seeker: job_seeker,
    accommodation_tag: tag,
    priority: :required
  )
end

# 求職者: 求人に応募する
puts "\n📌 テスト2-1: 求人に応募"
application = Application.create!(
  job_seeker: job_seeker,
  job: job,
  status: :pending,
  message: "はじめまして。在宅勤務可能な環境に魅力を感じ、応募いたしました。"
)
puts "   ✅ 求職者: 応募完了（ID: #{application.id}）"
results[:application_message][:apply] = { passed: true, application_id: application.id }

# 企業: 応募通知を確認
puts "\n📌 テスト2-2: 企業ダッシュボードで応募確認"
pending_applications = Application.joins(:job).where(jobs: { company_id: company.id }, status: :pending)
if pending_applications.exists?
  puts "   ✅ 企業: 応募通知あり（待機中: #{pending_applications.count} 件）"
  results[:application_message][:notification] = { passed: true, count: pending_applications.count }
else
  puts "   ❌ 企業: 応募通知なし"
  results[:application_message][:notification] = { passed: false }
end

# 企業: 応募者詳細画面からメッセージを送る
puts "\n📌 テスト2-3: 企業からメッセージ送信"
message1 = Message.create!(
  application: application,
  sender: company_user,
  recipient: job_seeker_user,
  content: "ご応募ありがとうございます。ぜひ一度お話しさせてください。"
)
puts "   ✅ 企業: メッセージ送信完了"

# 求職者: メッセージ画面で返信を送る
puts "\n📌 テスト2-4: 求職者からメッセージ返信"
message2 = Message.create!(
  application: application,
  sender: job_seeker_user,
  recipient: company_user,
  content: "お返事ありがとうございます。ぜひよろしくお願いいたします。"
)
puts "   ✅ 求職者: 返信完了"

# スレッド形式で会話が成立しているか確認
messages = application.messages.order(:created_at)
if messages.count >= 2 && messages.first.sender_id != messages.last.sender_id
  puts "   ✅ スレッド形式で会話成立（#{messages.count} 件のメッセージ）"
  messages.each_with_index do |msg, i|
    sender_name = msg.sender.user_type == "company" ? "企業" : "求職者"
    puts "      #{i + 1}. [#{sender_name}] #{msg.content.truncate(30)}"
  end
  results[:application_message][:thread] = { passed: true, message_count: messages.count }
else
  puts "   ❌ スレッド形式の会話が成立していない"
  results[:application_message][:thread] = { passed: false }
end

# ========================================
# 3. 体験実習フローの確認
# ========================================
puts "\n" + "-" * 70
puts "【3. 体験実習フロー（最重要差別化ポイント）の確認】"
puts "-" * 70

# 企業: 応募者詳細から「実習オファー」を送る
puts "\n📌 テスト3-1: 企業から実習オファー送信"
start_date = Date.tomorrow
end_date = start_date + 2.days

internship = Internship.create!(
  application: application,
  start_date: start_date,
  end_date: end_date,
  status: :pending
)
# 応募ステータスを accepted に変更（オファー送信時）
application.update!(status: :accepted)

puts "   ✅ 企業: 実習オファー送信（#{start_date} 〜 #{end_date}、#{internship.duration_days}日間）"
puts "   📋 ステータス: #{internship.status}"
results[:internship][:offer] = { passed: true, internship_id: internship.id }

# 求職者: オファーを確認し、「承諾」する
puts "\n📌 テスト3-2: 求職者がオファーを承諾"
pending_internships = Internship.joins(application: :job_seeker).where(job_seekers: { id: job_seeker.id }, status: :pending)
if pending_internships.exists?
  puts "   ✅ 求職者: オファーを確認（待機中: #{pending_internships.count} 件）"
end

internship.accepted!
puts "   ✅ 求職者: オファーを承諾"
puts "   📋 ステータス: #{internship.reload.status}"
results[:internship][:accept] = { passed: internship.accepted?, status: internship.status }

# ステータス変化の確認
puts "\n📌 テスト3-3: ステータス変化の確認"
if internship.accepted?
  puts "   ✅ ステータスが「pending」から「accepted」に変化"
  results[:internship][:status_change] = { passed: true, from: "pending", to: "accepted" }
else
  puts "   ❌ ステータスが変化していない"
  results[:internship][:status_change] = { passed: false }
end

# 実習開始（企業がステータスを変更）
internship.in_progress!
puts "   ✅ 企業: 実習を開始（in_progress）"

# 日報を投稿（双方）
puts "\n📌 テスト3-4: 日報投稿と相互閲覧"

# 求職者の日報
report_js = DailyReport.create!(
  internship: internship,
  user: job_seeker_user,
  report_date: Date.today,
  content: "本日は入力作業の基本を学びました。丁寧に教えていただき、ありがたいです。"
)
puts "   ✅ 求職者: 日報投稿完了"

# 企業の日報
report_co = DailyReport.create!(
  internship: internship,
  user: company_user,
  report_date: Date.today,
  content: "山田さんは集中力があり、ミスなく作業を進めていました。"
)
puts "   ✅ 企業: 日報投稿完了"

# 相互閲覧できるか
internship_reports = internship.daily_reports.order(:report_date)
if internship_reports.count == 2
  puts "   ✅ 双方の日報が閲覧可能（#{internship_reports.count} 件）"
  internship_reports.each do |r|
    author = r.author_type == :job_seeker ? "求職者" : "企業"
    puts "      - [#{author}] #{r.content.truncate(30)}"
  end
  results[:internship][:daily_reports] = { passed: true, count: internship_reports.count }
else
  puts "   ❌ 日報の相互閲覧ができていない"
  results[:internship][:daily_reports] = { passed: false }
end

# 実習終了 → 本採用
puts "\n📌 テスト3-5: 実習終了 → 本採用決定"
internship.completed!
puts "   ✅ 企業: 実習終了（completed）"

internship.hired!
puts "   ✅ 企業: 本採用決定（hired）"
puts "   📋 最終ステータス: #{internship.reload.status}"

if internship.hired?
  results[:internship][:hired] = { passed: true, status: internship.status }
else
  results[:internship][:hired] = { passed: false }
end

# ========================================
# 4. ダッシュボードの表示確認
# ========================================
puts "\n" + "-" * 70
puts "【4. ダッシュボードの表示確認】"
puts "-" * 70

# 企業ダッシュボード
puts "\n📌 テスト4-1: 企業ダッシュボード"
company_jobs = company.jobs
company_applications = Application.joins(:job).where(jobs: { company_id: company.id })
company_internships = Internship.where(company_id: company.id)

puts "   📊 求人数: #{company_jobs.count}"
puts "   📊 応募数: #{company_applications.count}"
puts "   📊 実習数: #{company_internships.count}"

if company_applications.count > 0
  puts "   ✅ 応募数がカウントされている"
  results[:dashboard][:company_applications] = { passed: true, count: company_applications.count }
else
  puts "   ❌ 応募数がカウントされていない"
  results[:dashboard][:company_applications] = { passed: false }
end

# 求職者ダッシュボード
puts "\n📌 テスト4-2: 求職者ダッシュボード"
seeker_applications = job_seeker.applications
application_statuses = seeker_applications.group(:status).count

puts "   📊 応募中の求人: #{seeker_applications.count} 件"
application_statuses.each do |status, count|
  puts "      - #{status}: #{count} 件"
end

# 応募ステータスの反映確認
application.reload
internship.reload

expected_status = "accepted"
actual_status = application.status

puts "\n   📋 応募ステータス確認:"
puts "      - 応募: #{application.status}"
puts "      - 実習: #{internship.status}"

if application.accepted? && internship.hired?
  puts "   ✅ ステータスが正しく反映されている"
  results[:dashboard][:seeker_status] = { passed: true, application_status: application.status, internship_status: internship.status }
else
  puts "   ⚠️  ステータスを確認してください"
  results[:dashboard][:seeker_status] = { passed: false }
end

# ========================================
# テスト結果サマリー
# ========================================
puts "\n" + "=" * 70
puts "📊 テスト結果サマリー"
puts "=" * 70

total_tests = 0
passed_tests = 0

def count_results(hash)
  passed = 0
  total = 0
  hash.each do |key, value|
    if value.is_a?(Hash) && value.key?(:passed)
      total += 1
      passed += 1 if value[:passed]
    end
  end
  [passed, total]
end

categories = {
  "1. マッチング精度" => results[:matching],
  "2. 応募〜メッセージ" => results[:application_message],
  "3. 体験実習フロー" => results[:internship],
  "4. ダッシュボード" => results[:dashboard]
}

categories.each do |name, hash|
  passed, total = count_results(hash)
  total_tests += total
  passed_tests += passed
  status = passed == total ? "✅" : "❌"
  puts "#{status} #{name}: #{passed}/#{total}"
end

puts "-" * 70
if passed_tests == total_tests
  puts "🎉 全テスト合格！ (#{passed_tests}/#{total_tests})"
else
  puts "⚠️  一部テストが失敗しました (#{passed_tests}/#{total_tests})"
end
puts "=" * 70

# 詳細結果をJSON形式で出力
puts "\n📋 詳細結果（デバッグ用）:"
require 'json'
puts JSON.pretty_generate(results)
