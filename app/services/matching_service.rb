# マッチングスコア計算サービス
#
# 求職者の必要な配慮と、企業が提供可能な配慮のマッチ度を計算する
#
# 計算式:
#   マッチ度 = (必須配慮のマッチ率 × 70%) + (希望配慮のマッチ率 × 30%)
#
# 特記事項:
#   - 必須配慮が1つでも欠けている場合は、スコアを0にする
#   - 必須配慮がない場合は100%としてカウント
#   - 希望配慮がない場合は100%としてカウント
#
# パフォーマンス:
#   - 求人一覧のように同じ求職者で多数の企業を採点する場合は calculate_scores を使う。
#     求職者のタグ取得を1回だけにし、企業タグは事前ロード済みの関連を使うことで
#     N+1 を避ける（pluck は都度SQLを発行するため map を使う）。
#
class MatchingService
  REQUIRED_WEIGHT = 0.7
  PREFERRED_WEIGHT = 0.3

  # 単一企業の採点
  def self.calculate_score(company, job_seeker)
    new(company, job_seeker).calculate
  end

  # 複数企業をまとめて採点し { company.id => score } を返す。
  # 求職者のタグは全企業で共通なので一度だけ読み込む。
  # company.accommodation_tags は呼び出し側で includes 済みであることを想定。
  def self.calculate_scores(companies, job_seeker)
    required = job_seeker.required_accommodation_tags.to_a
    preferred = job_seeker.preferred_accommodation_tags.to_a

    companies.uniq.each_with_object({}) do |company, scores|
      scores[company.id] = new(
        company, job_seeker,
        required_tags: required, preferred_tags: preferred
      ).calculate
    end
  end

  def initialize(company, job_seeker, required_tags: nil, preferred_tags: nil)
    @company = company
    @job_seeker = job_seeker
    @required_tags = required_tags
    @preferred_tags = preferred_tags
  end

  def calculate
    # 必須タグが1つでも欠けている場合は0を返す。
    # （丸めた割合ではなく件数で厳密に判定する。割合だと必須タグが多いとき
    #   199/200=99.5%→100%に丸まり、1つ欠けても満点扱いになる不具合があった）
    if required_tags.any?
      all_required_met = required_tags.all? { |tag| company_tag_ids.include?(tag.id) }
      return 0 unless all_required_met
    end

    # 重み付けスコアを計算
    (required_score * REQUIRED_WEIGHT + preferred_score * PREFERRED_WEIGHT).round
  end

  private

  def required_tags
    @required_tags ||= @job_seeker.required_accommodation_tags.to_a
  end

  def preferred_tags
    @preferred_tags ||= @job_seeker.preferred_accommodation_tags.to_a
  end

  # 企業の提供配慮ID。includes(company: :accommodation_tags) で事前ロードした関連を
  # 活かすため、都度SQLを発行する pluck ではなくロード済み配列を map する。
  def company_tag_ids
    @company_tag_ids ||= @company.accommodation_tags.map(&:id)
  end

  def required_score
    return 100 if required_tags.empty?

    matched_count = required_tags.count { |tag| company_tag_ids.include?(tag.id) }
    (matched_count.to_f / required_tags.size * 100).round
  end

  def preferred_score
    return 100 if preferred_tags.empty?

    matched_count = preferred_tags.count { |tag| company_tag_ids.include?(tag.id) }
    (matched_count.to_f / preferred_tags.size * 100).round
  end
end
