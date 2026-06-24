require "rails_helper"

RSpec.describe MatchingService do
  let(:company) { create_company }
  let(:job_seeker) { create_job_seeker }

  let(:quiet_room)  { create_accommodation_tag(name: "静かな個室あり") }
  let(:remote)      { create_accommodation_tag(name: "フルリモート可") }
  let(:flex)        { create_accommodation_tag(name: "フレックスタイム", category: "schedule") }

  def company_provides(*tags)
    tags.each { |t| CompanyAccommodation.create!(company: company, accommodation_tag: t) }
  end

  def seeker_needs(tag, priority:)
    JobSeekerAccommodation.create!(job_seeker: job_seeker, accommodation_tag: tag, priority: priority)
  end

  def score
    described_class.calculate_score(company, job_seeker)
  end

  context "求職者が配慮タグを登録していない" do
    it "100点（必須・希望ともに該当なしは満点扱い）" do
      company_provides(quiet_room)
      expect(score).to eq(100)
    end
  end

  context "必須配慮がすべて満たされている" do
    it "希望がなければ100点" do
      seeker_needs(quiet_room, priority: :required)
      company_provides(quiet_room)
      expect(score).to eq(100)
    end

    it "希望が半分（1/2）満たされていれば85点" do
      seeker_needs(quiet_room, priority: :required)
      seeker_needs(remote, priority: :preferred)
      seeker_needs(flex, priority: :preferred)
      company_provides(quiet_room, remote) # flex は提供なし

      # 必須100% * 0.7 + 希望50% * 0.3 = 85
      expect(score).to eq(85)
    end
  end

  context "必須配慮が1つでも欠けている" do
    it "他がすべて一致していてもスコアは0" do
      seeker_needs(quiet_room, priority: :required)
      seeker_needs(remote, priority: :required)
      seeker_needs(flex, priority: :preferred)
      company_provides(quiet_room, flex) # remote（必須）が欠けている

      expect(score).to eq(0)
    end

    it "必須が部分一致（1/2）でも0" do
      seeker_needs(quiet_room, priority: :required)
      seeker_needs(remote, priority: :required)
      company_provides(quiet_room)

      expect(score).to eq(0)
    end

    # 丸め境界の回帰テスト：必須200件中199件一致＝99.5%→丸めると100%だが、
    # 1件欠けているので0でなければならない（件数での厳密判定）。
    context "必須タグが多く、割合が100%に丸まる境界" do
      let(:tags) { Array.new(200) { |i| create_accommodation_tag(name: "必須タグ#{i}") } }

      it "199/200 一致でも必須が欠けていれば0" do
        tags.each { |t| seeker_needs(t, priority: :required) }
        company_provides(*tags[0...199]) # 1件だけ提供しない

        expect(score).to eq(0)
      end

      it "200/200 一致なら100" do
        tags.each { |t| seeker_needs(t, priority: :required) }
        company_provides(*tags)

        expect(score).to eq(100)
      end
    end
  end
end
