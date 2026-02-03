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
class MatchingService
  REQUIRED_WEIGHT = 0.7
  PREFERRED_WEIGHT = 0.3

  def self.calculate_score(company, job_seeker)
    new(company, job_seeker).calculate
  end

  def initialize(company, job_seeker)
    @company = company
    @job_seeker = job_seeker
  end

  def calculate
    required_score = calculate_required_score
    preferred_score = calculate_preferred_score

    # 必須タグが1つでも欠けている場合は0を返す
    required_tags = @job_seeker.required_accommodation_tags
    if required_tags.any? && required_score < 100
      # 必須タグが存在し、100%マッチしていない場合は0
      return 0
    end

    # 重み付けスコアを計算
    (required_score * REQUIRED_WEIGHT + preferred_score * PREFERRED_WEIGHT).round
  end

  private

  def calculate_required_score
    required_tags = @job_seeker.required_accommodation_tags
    return 100 if required_tags.empty?

    company_tag_ids = @company.accommodation_tags.pluck(:id)
    matched_count = required_tags.count { |tag| company_tag_ids.include?(tag.id) }

    (matched_count.to_f / required_tags.size * 100).round
  end

  def calculate_preferred_score
    preferred_tags = @job_seeker.preferred_accommodation_tags
    return 100 if preferred_tags.empty?

    company_tag_ids = @company.accommodation_tags.pluck(:id)
    matched_count = preferred_tags.count { |tag| company_tag_ids.include?(tag.id) }

    (matched_count.to_f / preferred_tags.size * 100).round
  end
end
