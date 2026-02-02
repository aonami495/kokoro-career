ココロキャリア 配慮タグ詳細設計

# 配慮タグ詳細設計書

**ココロキャリア - 精神障害者就労支援マッチングプラットフォーム**  
作成日：2026年2月2日

---

## 目次

1. [配慮タグの全体設計](#配慮タグの全体設計)
2. [30種類の配慮タグリスト](#30種類の配慮タグリスト)
3. [データベース設計](#データベース設計)
4. [求職者側のUI設計](#求職者側のui設計)
5. [企業側のUI設計](#企業側のui設計)
6. [マッチングアルゴリズム](#マッチングアルゴリズム)
7. [実装手順](#実装手順)

---

## 配慮タグの全体設計

### 設計思想

**「抽象的な配慮を、具体的で選びやすいタグに分解する」**

精神障害者の就労支援において、企業と求職者の間で最も大きなギャップとなるのが**「合理的配慮」の内容理解**です。

- 企業：「何をすればいいか分からない」
- 求職者：「どう説明すればいいか分からない」

このギャップを埋めるため、配慮を**4つのカテゴリ × 約30種類のタグ**に標準化します。

---

### 4つのカテゴリ

| カテゴリ               | 英語名          | 説明                                 | タグ数 |
| ---------------------- | --------------- | ------------------------------------ | ------ |
| **作業環境**           | `environment`   | 物理的な職場環境に関する配慮         | 8個    |
| **コミュニケーション** | `communication` | 指示の出し方、報告の方法に関する配慮 | 8個    |
| **勤務時間**           | `schedule`      | 勤務時間、休憩、通院に関する配慮     | 7個    |
| **サポート体制**       | `support`       | 人的サポート、相談体制に関する配慮   | 7個    |

**合計：30種類**

---

## 30種類の配慮タグリスト

### カテゴリ1：作業環境（Environment）

精神障害者にとって、**感覚過敏やストレス軽減**のために物理的環境は非常に重要です。

| #   | タグ名                      | 説明                                   | 対象となる障害・特性               |
| --- | --------------------------- | -------------------------------------- | ---------------------------------- |
| 1   | **静かな個室あり**          | 音に敏感な方向けの個室または防音ブース | 聴覚過敏、集中困難（ADHD、ASD）    |
| 2   | **パーティション席**        | 視覚的な刺激を減らすための間仕切り席   | 視覚過敏、集中困難                 |
| 3   | **在宅勤務可（週3日以上）** | 週の半分以上を在宅で勤務可能           | 対人不安、通勤困難、パニック障害   |
| 4   | **在宅勤務可（週1-2日）**   | 部分的なリモートワーク                 | 柔軟な働き方を希望する方           |
| 5   | **フルリモート可**          | 完全在宅勤務                           | 重度の対人不安、地方在住者         |
| 6   | **照明調整可**              | デスクライトの使用、明るさ調整         | 視覚過敏、片頭痛持ち               |
| 7   | **休憩スペースあり**        | 落ち着ける別室や休憩室                 | 疲労しやすい方、気分転換が必要な方 |
| 8   | **騒音の少ない環境**        | 静かなオフィス、工場の騒音なし         | 聴覚過敏、集中困難                 |

---

### カテゴリ2：コミュニケーション（Communication）

精神障害者は**口頭指示の理解や、曖昧な指示への対応**が苦手な場合があります。

| #   | タグ名                       | 説明                                       | 対象となる障害・特性                           |
| --- | ---------------------------- | ------------------------------------------ | ---------------------------------------------- |
| 9   | **指示は文書で**             | 口頭ではなく、メール・チャットで明確に指示 | ワーキングメモリの弱さ（ADHD）、処理速度の遅さ |
| 10  | **チャットツール使用**       | Slack、Teams等での非同期コミュニケーション | 対人不安、電話が苦手な方                       |
| 11  | **1on1定例あり**             | 週1回または隔週で上司との面談              | 不安が強い方、フィードバックが必要な方         |
| 12  | **報連相のフォーマットあり** | 報告の型が決まっている（テンプレート使用） | 何を報告すべきか分からない方                   |
| 13  | **会議は事前に議題共有**     | アジェンダを事前送付、突然の議題変更なし   | 予測不能な状況が苦手な方（ASD）                |
| 14  | **電話対応なし**             | 電話応対を業務に含まない                   | 電話恐怖症、突発対応が苦手                     |
| 15  | **質問しやすい雰囲気**       | 何度聞いても怒られない、心理的安全性       | 不安が強い方、自己肯定感が低い方               |
| 16  | **ゆっくり話す上司**         | 早口でなく、穏やかな話し方                 | 処理速度が遅い方、聴覚情報の理解が苦手         |

---

### カテゴリ3：勤務時間（Schedule）

精神障害者は**通院や体調の波**があるため、柔軟な勤務時間が重要です。

| #   | タグ名                       | 説明                                    | 対象となる障害・特性               |
| --- | ---------------------------- | --------------------------------------- | ---------------------------------- |
| 17  | **時短勤務可（週20時間～）** | 週4時間×5日、または週5時間×4日など      | 体力に不安がある方、段階的復職     |
| 18  | **時短勤務可（週30時間～）** | 週6時間×5日など、フルタイムに近い時短   | 軽度の疲労感、通院との両立         |
| 19  | **フレックスタイム**         | 始業・終業時刻を自由に調整可能          | 朝が苦手な方、通院スケジュール調整 |
| 20  | **通院配慮あり**             | 月1-2回の通院時に休暇取得または早退可   | 服薬管理が必要な方、定期通院中の方 |
| 21  | **シフト制（希望考慮）**     | シフトを本人の希望に合わせて調整        | 体調の波がある方                   |
| 22  | **休憩時間の柔軟化**         | 疲れたら随時休憩可（トータル1時間など） | 集中力が続かない方（ADHD）         |
| 23  | **残業なし**                 | 定時退社が基本、突発残業なし            | 疲労しやすい方、予定変更が苦手     |

---

### カテゴリ4：サポート体制（Support）

精神障害者の**定着率向上**には、継続的な人的サポートが不可欠です。

| #   | タグ名                   | 説明                                       | 対象となる障害・特性               |
| --- | ------------------------ | ------------------------------------------ | ---------------------------------- |
| 24  | **ジョブコーチ常駐**     | 職場適応援助者が常駐または定期訪問         | 初めての就労、重度の不安           |
| 25  | **メンター制度**         | 先輩社員が業務・生活面をサポート           | 孤立しやすい方、相談相手が必要な方 |
| 26  | **産業医面談あり**       | 月1回または必要時に産業医と面談            | 服薬管理、体調管理が必要な方       |
| 27  | **カウンセリング利用可** | 社内または提携カウンセラーへの相談可       | メンタル不調時のケア               |
| 28  | **定期面談（上司）**     | 週1回または隔週で上司と振り返り            | フィードバックが必要、不安が強い   |
| 29  | **就労支援機関との連携** | 就労移行支援事業所と定期的に情報共有       | 外部支援者のサポートが必要         |
| 30  | **段階的業務増加**       | 最初は簡単な業務から、徐々に難易度を上げる | 復職者、初めての就労               |

---

## データベース設計

### マイグレーションファイル

#### 1. 配慮タグマスタテーブル

class CreateAccommodationTags < ActiveRecord::Migration[7.1]
def change
create_table :accommodation_tags do |t|
t.string :name, null: false
t.string :category, null: false # environment, communication, schedule, support
t.text :description
t.integer :display_order, default: 0

      t.timestamps
    end

    add_index :accommodation_tags, :category

end
end

#### 2. 求職者の必要配慮テーブル

class CreateJobSeekerAccommodations < ActiveRecord::Migration[7.1]
def change
create_table :job_seeker_accommodations do |t|
t.references :job_seeker, null: false, foreign_key: true
t.references :accommodation_tag, null: false, foreign_key: true
t.integer :priority, default: 0 # 0: required, 1: preferred

      t.timestamps
    end

    add_index :job_seeker_accommodations, [:job_seeker_id, :accommodation_tag_id],
              unique: true, name: 'index_js_accommodations_on_js_and_tag'

end
end

#### 3. 企業の提供可能配慮テーブル

class CreateCompanyAccommodations < ActiveRecord::Migration[7.1]
def change
create_table :company_accommodations do |t|
t.references :company, null: false, foreign_key: true
t.references :accommodation_tag, null: false, foreign_key: true
t.text :detail_description # 企業側の補足説明

      t.timestamps
    end

    add_index :company_accommodations, [:company_id, :accommodation_tag_id],
              unique: true, name: 'index_company_accommodations_on_company_and_tag'

end
end

---

### モデル実装

#### AccommodationTag モデル

class AccommodationTag < ApplicationRecord
has_many :job_seeker_accommodations, dependent: :destroy
has_many :company_accommodations, dependent: :destroy
has_many :job_seekers, through: :job_seeker_accommodations
has_many :companies, through: :company_accommodations

validates :name, presence: true, uniqueness: true
validates :category, presence: true, inclusion: {
in: %w[environment communication schedule support]
}

# カテゴリごとにグループ化

scope :environment, -> { where(category: 'environment') }
scope :communication, -> { where(category: 'communication') }
scope :schedule, -> { where(category: 'schedule') }
scope :support, -> { where(category: 'support') }

# 表示順でソート

scope :ordered, -> { order(:display_order, :id) }
end

#### JobSeekerAccommodation モデル

class JobSeekerAccommodation < ApplicationRecord
belongs_to :job_seeker
belongs_to :accommodation_tag

enum priority: { required: 0, preferred: 1 }

validates :job_seeker_id, uniqueness: { scope: :accommodation_tag_id }
end

#### JobSeeker モデルへの追加

class JobSeeker < ApplicationRecord
has_many :job_seeker_accommodations, dependent: :destroy
has_many :accommodation_tags, through: :job_seeker_accommodations

# 必須配慮のみ取得

def required_accommodation_tags
accommodation_tags.merge(JobSeekerAccommodation.required)
end

# 希望配慮のみ取得

def preferred_accommodation_tags
accommodation_tags.merge(JobSeekerAccommodation.preferred)
end
end

#### Company モデルへの追加

class Company < ApplicationRecord
has_many :company_accommodations, dependent: :destroy
has_many :accommodation_tags, through: :company_accommodations

# マッチ度計算（後述のアルゴリズム参照）

def match_score(job_seeker)
MatchingService.calculate_score(self, job_seeker)
end
end

---

## 求職者側のUI設計

### 1. 配慮タグ選択画面（初回登録時）

<!-- app/views/job_seekers/accommodations/new.html.erb -->

<div class="max-w-4xl mx-auto p-8">
  <h1 class="text-3xl font-bold mb-4">あなたに必要な配慮を選んでください</h1>
  <p class="text-gray-600 mb-8">
    働きやすい環境を探すために、必要な配慮を選択してください。<br>
    <strong>「必須」</strong>は絶対に必要な配慮、<strong>「あると嬉しい」</strong>は希望する配慮です。
  </p>

<%= form_with url: job_seeker_accommodations_path, method: :post do |f| %>
<% AccommodationTag.ordered.group_by(&:category).each do |category, tags| %>
<div class="mb-8">
<h2 class="text-2xl font-semibold mb-4 border-b pb-2">
<%= category_name(category) %>
</h2>

        <div class="space-y-3">
          <% tags.each do |tag| %>
            <div class="flex items-center p-4 bg-white rounded-lg shadow">
              <div class="flex-1">
                <label class="font-medium text-gray-800"><%= tag.name %></label>
                <p class="text-sm text-gray-500"><%= tag.description %></p>
              </div>
              <div class="flex space-x-4">
                <label class="flex items-center cursor-pointer">
                  <%= check_box_tag "accommodations[#{tag.id}]", "required", false,
                      class: "mr-2 text-red-600 focus:ring-red-500" %>
                  <span class="text-red-600 font-semibold">必須</span>
                </label>
                <label class="flex items-center cursor-pointer">
                  <%= check_box_tag "accommodations[#{tag.id}]", "preferred", false,
                      class: "mr-2 text-blue-600 focus:ring-blue-500" %>
                  <span class="text-blue-600 font-semibold">あると嬉しい</span>
                </label>
              </div>
            </div>
          <% end %>
        </div>
      </div>
    <% end %>

    <div class="flex justify-end mt-8">
      <%= f.submit "この内容で登録する",
          class: "bg-teal-600 text-white px-8 py-3 rounded-lg hover:bg-teal-700 text-lg" %>
    </div>

<% end %>

</div>

**ヘルパーメソッド（app/helpers/accommodations_helper.rb）**

module AccommodationsHelper
def category_name(category)
{
'environment' => '作業環境',
'communication' => 'コミュニケーション',
'schedule' => '勤務時間',
'support' => 'サポート体制'
}[category]
end
end

---

### 2. マイページでの配慮タグ確認・編集

<!-- app/views/job_seekers/dashboard.html.erb -->

<div class="bg-white rounded-lg shadow p-6 mb-8">
  <div class="flex justify-between items-center mb-4">
    <h2 class="text-2xl font-semibold">あなたが登録した配慮</h2>
    <%= link_to "編集する", edit_job_seeker_accommodations_path, 
        class: "text-teal-600 hover:underline" %>
  </div>

  <div class="space-y-4">
    <div>
      <h3 class="text-lg font-medium text-red-600 mb-2">必須の配慮</h3>
      <div class="flex flex-wrap gap-2">
        <% current_job_seeker.required_accommodation_tags.each do |tag| %>
          <span class="bg-red-100 text-red-800 px-3 py-1 rounded-full text-sm">
            <%= tag.name %>
          </span>
        <% end %>
      </div>
    </div>

    <div>
      <h3 class="text-lg font-medium text-blue-600 mb-2">あると嬉しい配慮</h3>
      <div class="flex flex-wrap gap-2">
        <% current_job_seeker.preferred_accommodation_tags.each do |tag| %>
          <span class="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm">
            <%= tag.name %>
          </span>
        <% end %>
      </div>
    </div>

  </div>
</div>

---

## 企業側のUI設計

### 1. 配慮タグ選択画面（求人登録時）

<!-- app/views/jobs/new.html.erb -->

<div class="max-w-4xl mx-auto p-8">
  <h1 class="text-3xl font-bold mb-4">求人情報を登録</h1>

<%= form_with model: @job, local: true do |f| %>
<!-- 基本情報（省略） -->
<div class="mb-8">
<%= f.label :title, "求人タイトル", class: "block font-semibold mb-2" %>
<%= f.text_field :title, class: "w-full px-4 py-2 border rounded-lg" %>
</div>

    <!-- 配慮タグ選択 -->
    <div class="mb-8">
      <h2 class="text-2xl font-semibold mb-4">提供可能な配慮</h2>
      <p class="text-gray-600 mb-4">
        貴社で提供できる配慮を選択してください。<br>
        求職者がこのタグで検索できるようになります。
      </p>

      <% AccommodationTag.ordered.group_by(&:category).each do |category, tags| %>
        <div class="mb-6 bg-gray-50 p-4 rounded-lg">
          <h3 class="text-xl font-semibold mb-3"><%= category_name(category) %></h3>

          <div class="space-y-2">
            <% tags.each do |tag| %>
              <div class="flex items-start">
                <label class="flex items-start cursor-pointer">
                  <%= check_box_tag "job[accommodation_tag_ids][]", tag.id,
                      @job.accommodation_tags.include?(tag),
                      class: "mt-1 mr-3 text-teal-600 focus:ring-teal-500" %>
                  <div>
                    <span class="font-medium text-gray-800"><%= tag.name %></span>
                    <p class="text-sm text-gray-500"><%= tag.description %></p>
                  </div>
                </label>
              </div>
            <% end %>
          </div>
        </div>
      <% end %>
    </div>

    <div class="flex justify-end mt-8">
      <%= f.submit "求人を登録する",
          class: "bg-teal-600 text-white px-8 py-3 rounded-lg hover:bg-teal-700 text-lg" %>
    </div>

<% end %>

</div>

---

### 2. 求人詳細ページでの配慮タグ表示

<!-- app/views/jobs/show.html.erb -->

<div class="max-w-4xl mx-auto p-8">
  <h1 class="text-3xl font-bold mb-2"><%= @job.title %></h1>
  <p class="text-gray-600 mb-8"><%= @job.company.company_name %></p>

  <!-- 配慮タグの表示 -->
  <div class="bg-teal-50 border border-teal-200 rounded-lg p-6 mb-8">
    <h2 class="text-xl font-semibold text-teal-800 mb-4">
      この企業が提供できる配慮
    </h2>
    
    <% @job.accommodation_tags.group_by(&:category).each do |category, tags| %>
      <div class="mb-4">
        <h3 class="text-lg font-medium text-teal-700 mb-2">
          <%= category_name(category) %>
        </h3>
        <div class="flex flex-wrap gap-2">
          <% tags.each do |tag| %>
            <span class="bg-white border border-teal-300 text-teal-800 px-3 py-1 rounded-full text-sm">
              ✓ <%= tag.name %>
            </span>
          <% end %>
        </div>
      </div>
    <% end %>
  </div>

  <!-- その他の求人情報（省略） -->
</div>

---

## マッチングアルゴリズム

### アルゴリズムの考え方

マッチ度を0～100%で算出します。

**計算式**
マッチ度 = (必須配慮のマッチ数 / 必須配慮の総数) × 70% + (希望配慮のマッチ数 / 希望配慮の総数) × 30%

**重み付けの理由**

- **必須配慮**：70%の重み（最重要、1つでも欠けると大きく減点）
- **希望配慮**：30%の重み（あると嬉しい程度）

---

### 実装コード

#### MatchingService クラス

# app/services/matching_service.rb

class MatchingService
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

    # 必須が1つでも欠けている場合は大幅減点
    return 0 if required_score == 0 && @job_seeker.required_accommodation_tags.any?

    (required_score * 0.7 + preferred_score * 0.3).round

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

---

### マッチング結果の表示

#### 求人検索結果ページ

# app/controllers/jobs_controller.rb

class JobsController < ApplicationController
def index
@jobs = Job.published.includes(:company, :accommodation_tags)

    # マッチ度でソート
    @jobs_with_score = @jobs.map do |job|
      score = job.company.match_score(current_job_seeker)
      { job: job, score: score }
    end.sort_by { |item| -item[:score] } # 降順

end
end

<!-- app/views/jobs/index.html.erb -->

<div class="max-w-6xl mx-auto p-8">
  <h1 class="text-3xl font-bold mb-8">求人検索結果</h1>

  <div class="space-y-6">
    <% @jobs_with_score.each do |item| %>
      <% job = item[:job] %>
      <% score = item[:score] %>

      <div class="bg-white rounded-lg shadow-lg p-6 border-l-4 <%= match_color_class(score) %>">
        <div class="flex justify-between items-start mb-4">
          <div>
            <h2 class="text-2xl font-semibold text-gray-900">
              <%= link_to job.title, job_path(job), class: "hover:text-teal-600" %>
            </h2>
            <p class="text-gray-600"><%= job.company.company_name %></p>
          </div>
          <div class="text-right">
            <span class="text-3xl font-bold <%= match_text_class(score) %>">
              <%= score %>%
            </span>
            <p class="text-sm text-gray-500">マッチ度</p>
          </div>
        </div>

        <!-- 配慮タグ表示（最大5個） -->
        <div class="flex flex-wrap gap-2 mb-4">
          <% job.accommodation_tags.limit(5).each do |tag| %>
            <span class="bg-teal-100 text-teal-800 px-3 py-1 rounded-full text-sm">
              ✓ <%= tag.name %>
            </span>
          <% end %>
          <% if job.accommodation_tags.size > 5 %>
            <span class="text-gray-500 text-sm">他<%= job.accommodation_tags.size - 5 %>件</span>
          <% end %>
        </div>

        <div class="flex justify-between items-center">
          <p class="text-gray-600"><%= job.location %> / <%= job.employment_type %></p>
          <%= link_to "詳細を見る", job_path(job),
              class: "bg-teal-600 text-white px-4 py-2 rounded hover:bg-teal-700" %>
        </div>
      </div>
    <% end %>

  </div>
</div>

**ヘルパーメソッド**

# app/helpers/jobs_helper.rb

module JobsHelper
def match_color_class(score)
case score
when 80..100 then "border-green-500"
when 60..79 then "border-blue-500"
when 40..59 then "border-yellow-500"
else "border-gray-300"
end
end

def match_text_class(score)
case score
when 80..100 then "text-green-600"
when 60..79 then "text-blue-600"
when 40..59 then "text-yellow-600"
else "text-gray-500"
end
end
end

---

## 実装手順

### Week 2-3：配慮タグシステム実装（5日間）

#### Day 1：マイグレーション＋シードデータ

# マイグレーション実行

rails generate migration CreateAccommodationTags
rails generate migration CreateJobSeekerAccommodations
rails generate migration CreateCompanyAccommodations
rails db:migrate

**シードデータ作成（db/seeds.rb）**

# 配慮タグの作成

tags_data = [

# 作業環境

{ name: '静かな個室あり', category: 'environment', description: '音に敏感な方向けの個室または防音ブース', display_order: 1 },
{ name: 'パーティション席', category: 'environment', description: '視覚的な刺激を減らすための間仕切り席', display_order: 2 },
{ name: '在宅勤務可（週3日以上）', category: 'environment', description: '週の半分以上を在宅で勤務可能', display_order: 3 },

# ... 残り27個（省略）

]

tags_data.each do |tag_data|
AccommodationTag.find_or_create_by!(name: tag_data[:name]) do |tag|
tag.category = tag_data[:category]
tag.description = tag_data[:description]
tag.display_order = tag_data[:display_order]
end
end

puts "✅ 配慮タグ #{AccommodationTag.count} 件を作成しました"

rails db:seed

---

#### Day 2-3：モデル・コントローラー実装

**コントローラー作成**

rails generate controller JobSeeker::Accommodations new create edit update

# app/controllers/job_seeker/accommodations_controller.rb

class JobSeeker::AccommodationsController < ApplicationController
before_action :authenticate_user!
before_action :ensure_job_seeker

def new
@tags = AccommodationTag.ordered.group_by(&:category)
end

def create
current_job_seeker.job_seeker_accommodations.destroy_all

    accommodations_params.each do |tag_id, priority|
      current_job_seeker.job_seeker_accommodations.create!(
        accommodation_tag_id: tag_id,
        priority: priority
      )
    end

    redirect_to job_seeker_dashboard_path, notice: '配慮を登録しました'

end

def edit
@tags = AccommodationTag.ordered.group_by(&:category)
@selected_tags = current_job_seeker.job_seeker_accommodations.index_by(&:accommodation_tag_id)
end

def update # create と同じロジック
create
end

private

def accommodations_params
params.require(:accommodations).permit!
end

def ensure_job_seeker
redirect_to root_path unless current_user.job_seeker?
end
end

---

#### Day 4：UI実装（ビュー）

前述の「求職者側のUI設計」のコードを実装。

---

#### Day 5：テスト＋デバッグ

**手動テスト項目**

- [ ] 配慮タグ30種類が正しく表示される
- [ ] 必須/希望の選択が保存される
- [ ] 編集時に既存選択が反映される
- [ ] カテゴリごとにグループ化されている

---

### Week 4-5：マッチング機能実装（5日間）

#### Day 1-2：MatchingService 実装

前述の「マッチングアルゴリズム」のコードを実装。

---

#### Day 3-4：求人検索画面

# app/controllers/jobs_controller.rb

class JobsController < ApplicationController
def index
@jobs = Job.published.includes(:company, :accommodation_tags)

    # 配慮タグでフィルタリング
    if params[:accommodation_tag_ids].present?
      tag_ids = params[:accommodation_tag_ids].reject(&:blank?).map(&:to_i)
      @jobs = @jobs.joins(:accommodation_tags)
                   .where(accommodation_tags: { id: tag_ids })
                   .distinct
    end

    # マッチ度計算＋ソート
    if current_user&.job_seeker?
      @jobs_with_score = @jobs.map do |job|
        { job: job, score: job.company.match_score(current_job_seeker) }
      end.sort_by { |item| -item[:score] }
    else
      @jobs_with_score = @jobs.map { |job| { job: job, score: nil } }
    end

end
end

---

#### Day 5：テスト

**テストケース**

- 必須配慮が全て満たされている → マッチ度 80%以上
- 必須配慮が1つ欠けている → マッチ度 50%以下
- 必須配慮が全て欠けている → マッチ度 0%

---

## まとめ

### 完成する機能

✅ 30種類の配慮タグシステム  
✅ 求職者の配慮選択UI（必須/希望の2段階）  
✅ 企業の配慮選択UI  
✅ マッチングアルゴリズム（0～100%のスコア）  
✅ マッチ度順での求人表示

### 次のステップ

1. **Week 3-4**：求人登録機能の実装
2. **Week 4-5**：求人検索・マッチング機能の実装
3. **Week 5-6**：応募・メッセージ機能の実装

### 懸念点・要検討事項

1. **配慮タグの網羅性**：30種類で十分か？ユーザーテストで検証が必要
2. **マッチングアルゴリズムの調整**：必須70%、希望30%の重み付けは適切か？
3. **カスタムタグ**：企業が独自の配慮を追加できるようにすべきか？（Phase 2検討）

---

**作成者**: AI Assistant  
**最終更新**: 2026年2月2日

# 配慮タグ詳細設計書

**ココロキャリア - 精神障害者就労支援マッチングプラットフォーム**  
作成日：2026年2月2日

---

## 目次

1. [配慮タグの全体設計](#配慮タグの全体設計)
2. [30種類の配慮タグリスト](#30種類の配慮タグリスト)
3. [データベース設計](#データベース設計)
4. [求職者側のUI設計](#求職者側のui設計)
5. [企業側のUI設計](#企業側のui設計)
6. [マッチングアルゴリズム](#マッチングアルゴリズム)
7. [実装手順](#実装手順)

---

## 配慮タグの全体設計

### 設計思想

**「抽象的な配慮を、具体的で選びやすいタグに分解する」**

精神障害者の就労支援において、企業と求職者の間で最も大きなギャップとなるのが**「合理的配慮」の内容理解**です。

- 企業：「何をすればいいか分からない」
- 求職者：「どう説明すればいいか分からない」

このギャップを埋めるため、配慮を**4つのカテゴリ × 約30種類のタグ**に標準化します。

---

### 4つのカテゴリ

| カテゴリ               | 英語名          | 説明                                 | タグ数 |
| ---------------------- | --------------- | ------------------------------------ | ------ |
| **作業環境**           | `environment`   | 物理的な職場環境に関する配慮         | 8個    |
| **コミュニケーション** | `communication` | 指示の出し方、報告の方法に関する配慮 | 8個    |
| **勤務時間**           | `schedule`      | 勤務時間、休憩、通院に関する配慮     | 7個    |
| **サポート体制**       | `support`       | 人的サポート、相談体制に関する配慮   | 7個    |

**合計：30種類**

---

## 30種類の配慮タグリスト

### カテゴリ1：作業環境（Environment）

精神障害者にとって、**感覚過敏やストレス軽減**のために物理的環境は非常に重要です。

| #   | タグ名                      | 説明                                   | 対象となる障害・特性               |
| --- | --------------------------- | -------------------------------------- | ---------------------------------- |
| 1   | **静かな個室あり**          | 音に敏感な方向けの個室または防音ブース | 聴覚過敏、集中困難（ADHD、ASD）    |
| 2   | **パーティション席**        | 視覚的な刺激を減らすための間仕切り席   | 視覚過敏、集中困難                 |
| 3   | **在宅勤務可（週3日以上）** | 週の半分以上を在宅で勤務可能           | 対人不安、通勤困難、パニック障害   |
| 4   | **在宅勤務可（週1-2日）**   | 部分的なリモートワーク                 | 柔軟な働き方を希望する方           |
| 5   | **フルリモート可**          | 完全在宅勤務                           | 重度の対人不安、地方在住者         |
| 6   | **照明調整可**              | デスクライトの使用、明るさ調整         | 視覚過敏、片頭痛持ち               |
| 7   | **休憩スペースあり**        | 落ち着ける別室や休憩室                 | 疲労しやすい方、気分転換が必要な方 |
| 8   | **騒音の少ない環境**        | 静かなオフィス、工場の騒音なし         | 聴覚過敏、集中困難                 |

---

### カテゴリ2：コミュニケーション（Communication）

精神障害者は**口頭指示の理解や、曖昧な指示への対応**が苦手な場合があります。

| #   | タグ名                       | 説明                                       | 対象となる障害・特性                           |
| --- | ---------------------------- | ------------------------------------------ | ---------------------------------------------- |
| 9   | **指示は文書で**             | 口頭ではなく、メール・チャットで明確に指示 | ワーキングメモリの弱さ（ADHD）、処理速度の遅さ |
| 10  | **チャットツール使用**       | Slack、Teams等での非同期コミュニケーション | 対人不安、電話が苦手な方                       |
| 11  | **1on1定例あり**             | 週1回または隔週で上司との面談              | 不安が強い方、フィードバックが必要な方         |
| 12  | **報連相のフォーマットあり** | 報告の型が決まっている（テンプレート使用） | 何を報告すべきか分からない方                   |
| 13  | **会議は事前に議題共有**     | アジェンダを事前送付、突然の議題変更なし   | 予測不能な状況が苦手な方（ASD）                |
| 14  | **電話対応なし**             | 電話応対を業務に含まない                   | 電話恐怖症、突発対応が苦手                     |
| 15  | **質問しやすい雰囲気**       | 何度聞いても怒られない、心理的安全性       | 不安が強い方、自己肯定感が低い方               |
| 16  | **ゆっくり話す上司**         | 早口でなく、穏やかな話し方                 | 処理速度が遅い方、聴覚情報の理解が苦手         |

---

### カテゴリ3：勤務時間（Schedule）

精神障害者は**通院や体調の波**があるため、柔軟な勤務時間が重要です。

| #   | タグ名                       | 説明                                    | 対象となる障害・特性               |
| --- | ---------------------------- | --------------------------------------- | ---------------------------------- |
| 17  | **時短勤務可（週20時間～）** | 週4時間×5日、または週5時間×4日など      | 体力に不安がある方、段階的復職     |
| 18  | **時短勤務可（週30時間～）** | 週6時間×5日など、フルタイムに近い時短   | 軽度の疲労感、通院との両立         |
| 19  | **フレックスタイム**         | 始業・終業時刻を自由に調整可能          | 朝が苦手な方、通院スケジュール調整 |
| 20  | **通院配慮あり**             | 月1-2回の通院時に休暇取得または早退可   | 服薬管理が必要な方、定期通院中の方 |
| 21  | **シフト制（希望考慮）**     | シフトを本人の希望に合わせて調整        | 体調の波がある方                   |
| 22  | **休憩時間の柔軟化**         | 疲れたら随時休憩可（トータル1時間など） | 集中力が続かない方（ADHD）         |
| 23  | **残業なし**                 | 定時退社が基本、突発残業なし            | 疲労しやすい方、予定変更が苦手     |

---

### カテゴリ4：サポート体制（Support）

精神障害者の**定着率向上**には、継続的な人的サポートが不可欠です。

| #   | タグ名                   | 説明                                       | 対象となる障害・特性               |
| --- | ------------------------ | ------------------------------------------ | ---------------------------------- |
| 24  | **ジョブコーチ常駐**     | 職場適応援助者が常駐または定期訪問         | 初めての就労、重度の不安           |
| 25  | **メンター制度**         | 先輩社員が業務・生活面をサポート           | 孤立しやすい方、相談相手が必要な方 |
| 26  | **産業医面談あり**       | 月1回または必要時に産業医と面談            | 服薬管理、体調管理が必要な方       |
| 27  | **カウンセリング利用可** | 社内または提携カウンセラーへの相談可       | メンタル不調時のケア               |
| 28  | **定期面談（上司）**     | 週1回または隔週で上司と振り返り            | フィードバックが必要、不安が強い   |
| 29  | **就労支援機関との連携** | 就労移行支援事業所と定期的に情報共有       | 外部支援者のサポートが必要         |
| 30  | **段階的業務増加**       | 最初は簡単な業務から、徐々に難易度を上げる | 復職者、初めての就労               |

---

## データベース設計

### マイグレーションファイル

#### 1. 配慮タグマスタテーブル

class CreateAccommodationTags < ActiveRecord::Migration[7.1]
def change
create_table :accommodation_tags do |t|
t.string :name, null: false
t.string :category, null: false # environment, communication, schedule, support
t.text :description
t.integer :display_order, default: 0

      t.timestamps
    end

    add_index :accommodation_tags, :category

end
end

#### 2. 求職者の必要配慮テーブル

class CreateJobSeekerAccommodations < ActiveRecord::Migration[7.1]
def change
create_table :job_seeker_accommodations do |t|
t.references :job_seeker, null: false, foreign_key: true
t.references :accommodation_tag, null: false, foreign_key: true
t.integer :priority, default: 0 # 0: required, 1: preferred

      t.timestamps
    end

    add_index :job_seeker_accommodations, [:job_seeker_id, :accommodation_tag_id],
              unique: true, name: 'index_js_accommodations_on_js_and_tag'

end
end

#### 3. 企業の提供可能配慮テーブル

class CreateCompanyAccommodations < ActiveRecord::Migration[7.1]
def change
create_table :company_accommodations do |t|
t.references :company, null: false, foreign_key: true
t.references :accommodation_tag, null: false, foreign_key: true
t.text :detail_description # 企業側の補足説明

      t.timestamps
    end

    add_index :company_accommodations, [:company_id, :accommodation_tag_id],
              unique: true, name: 'index_company_accommodations_on_company_and_tag'

end
end

---

### モデル実装

#### AccommodationTag モデル

class AccommodationTag < ApplicationRecord
has_many :job_seeker_accommodations, dependent: :destroy
has_many :company_accommodations, dependent: :destroy
has_many :job_seekers, through: :job_seeker_accommodations
has_many :companies, through: :company_accommodations

validates :name, presence: true, uniqueness: true
validates :category, presence: true, inclusion: {
in: %w[environment communication schedule support]
}

# カテゴリごとにグループ化

scope :environment, -> { where(category: 'environment') }
scope :communication, -> { where(category: 'communication') }
scope :schedule, -> { where(category: 'schedule') }
scope :support, -> { where(category: 'support') }

# 表示順でソート

scope :ordered, -> { order(:display_order, :id) }
end

#### JobSeekerAccommodation モデル

class JobSeekerAccommodation < ApplicationRecord
belongs_to :job_seeker
belongs_to :accommodation_tag

enum priority: { required: 0, preferred: 1 }

validates :job_seeker_id, uniqueness: { scope: :accommodation_tag_id }
end

#### JobSeeker モデルへの追加

class JobSeeker < ApplicationRecord
has_many :job_seeker_accommodations, dependent: :destroy
has_many :accommodation_tags, through: :job_seeker_accommodations

# 必須配慮のみ取得

def required_accommodation_tags
accommodation_tags.merge(JobSeekerAccommodation.required)
end

# 希望配慮のみ取得

def preferred_accommodation_tags
accommodation_tags.merge(JobSeekerAccommodation.preferred)
end
end

#### Company モデルへの追加

class Company < ApplicationRecord
has_many :company_accommodations, dependent: :destroy
has_many :accommodation_tags, through: :company_accommodations

# マッチ度計算（後述のアルゴリズム参照）

def match_score(job_seeker)
MatchingService.calculate_score(self, job_seeker)
end
end

---

## 求職者側のUI設計

### 1. 配慮タグ選択画面（初回登録時）

<!-- app/views/job_seekers/accommodations/new.html.erb -->

<div class="max-w-4xl mx-auto p-8">
  <h1 class="text-3xl font-bold mb-4">あなたに必要な配慮を選んでください</h1>
  <p class="text-gray-600 mb-8">
    働きやすい環境を探すために、必要な配慮を選択してください。<br>
    <strong>「必須」</strong>は絶対に必要な配慮、<strong>「あると嬉しい」</strong>は希望する配慮です。
  </p>

<%= form_with url: job_seeker_accommodations_path, method: :post do |f| %>
<% AccommodationTag.ordered.group_by(&:category).each do |category, tags| %>
<div class="mb-8">
<h2 class="text-2xl font-semibold mb-4 border-b pb-2">
<%= category_name(category) %>
</h2>

        <div class="space-y-3">
          <% tags.each do |tag| %>
            <div class="flex items-center p-4 bg-white rounded-lg shadow">
              <div class="flex-1">
                <label class="font-medium text-gray-800"><%= tag.name %></label>
                <p class="text-sm text-gray-500"><%= tag.description %></p>
              </div>
              <div class="flex space-x-4">
                <label class="flex items-center cursor-pointer">
                  <%= check_box_tag "accommodations[#{tag.id}]", "required", false,
                      class: "mr-2 text-red-600 focus:ring-red-500" %>
                  <span class="text-red-600 font-semibold">必須</span>
                </label>
                <label class="flex items-center cursor-pointer">
                  <%= check_box_tag "accommodations[#{tag.id}]", "preferred", false,
                      class: "mr-2 text-blue-600 focus:ring-blue-500" %>
                  <span class="text-blue-600 font-semibold">あると嬉しい</span>
                </label>
              </div>
            </div>
          <% end %>
        </div>
      </div>
    <% end %>

    <div class="flex justify-end mt-8">
      <%= f.submit "この内容で登録する",
          class: "bg-teal-600 text-white px-8 py-3 rounded-lg hover:bg-teal-700 text-lg" %>
    </div>

<% end %>

</div>

**ヘルパーメソッド（app/helpers/accommodations_helper.rb）**

module AccommodationsHelper
def category_name(category)
{
'environment' => '作業環境',
'communication' => 'コミュニケーション',
'schedule' => '勤務時間',
'support' => 'サポート体制'
}[category]
end
end

---

### 2. マイページでの配慮タグ確認・編集

<!-- app/views/job_seekers/dashboard.html.erb -->

<div class="bg-white rounded-lg shadow p-6 mb-8">
  <div class="flex justify-between items-center mb-4">
    <h2 class="text-2xl font-semibold">あなたが登録した配慮</h2>
    <%= link_to "編集する", edit_job_seeker_accommodations_path, 
        class: "text-teal-600 hover:underline" %>
  </div>

  <div class="space-y-4">
    <div>
      <h3 class="text-lg font-medium text-red-600 mb-2">必須の配慮</h3>
      <div class="flex flex-wrap gap-2">
        <% current_job_seeker.required_accommodation_tags.each do |tag| %>
          <span class="bg-red-100 text-red-800 px-3 py-1 rounded-full text-sm">
            <%= tag.name %>
          </span>
        <% end %>
      </div>
    </div>

    <div>
      <h3 class="text-lg font-medium text-blue-600 mb-2">あると嬉しい配慮</h3>
      <div class="flex flex-wrap gap-2">
        <% current_job_seeker.preferred_accommodation_tags.each do |tag| %>
          <span class="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm">
            <%= tag.name %>
          </span>
        <% end %>
      </div>
    </div>

  </div>
</div>

---

## 企業側のUI設計

### 1. 配慮タグ選択画面（求人登録時）

<!-- app/views/jobs/new.html.erb -->

<div class="max-w-4xl mx-auto p-8">
  <h1 class="text-3xl font-bold mb-4">求人情報を登録</h1>

<%= form_with model: @job, local: true do |f| %>
<!-- 基本情報（省略） -->
<div class="mb-8">
<%= f.label :title, "求人タイトル", class: "block font-semibold mb-2" %>
<%= f.text_field :title, class: "w-full px-4 py-2 border rounded-lg" %>
</div>

    <!-- 配慮タグ選択 -->
    <div class="mb-8">
      <h2 class="text-2xl font-semibold mb-4">提供可能な配慮</h2>
      <p class="text-gray-600 mb-4">
        貴社で提供できる配慮を選択してください。<br>
        求職者がこのタグで検索できるようになります。
      </p>

      <% AccommodationTag.ordered.group_by(&:category).each do |category, tags| %>
        <div class="mb-6 bg-gray-50 p-4 rounded-lg">
          <h3 class="text-xl font-semibold mb-3"><%= category_name(category) %></h3>

          <div class="space-y-2">
            <% tags.each do |tag| %>
              <div class="flex items-start">
                <label class="flex items-start cursor-pointer">
                  <%= check_box_tag "job[accommodation_tag_ids][]", tag.id,
                      @job.accommodation_tags.include?(tag),
                      class: "mt-1 mr-3 text-teal-600 focus:ring-teal-500" %>
                  <div>
                    <span class="font-medium text-gray-800"><%= tag.name %></span>
                    <p class="text-sm text-gray-500"><%= tag.description %></p>
                  </div>
                </label>
              </div>
            <% end %>
          </div>
        </div>
      <% end %>
    </div>

    <div class="flex justify-end mt-8">
      <%= f.submit "求人を登録する",
          class: "bg-teal-600 text-white px-8 py-3 rounded-lg hover:bg-teal-700 text-lg" %>
    </div>

<% end %>

</div>

---

### 2. 求人詳細ページでの配慮タグ表示

<!-- app/views/jobs/show.html.erb -->

<div class="max-w-4xl mx-auto p-8">
  <h1 class="text-3xl font-bold mb-2"><%= @job.title %></h1>
  <p class="text-gray-600 mb-8"><%= @job.company.company_name %></p>

  <!-- 配慮タグの表示 -->
  <div class="bg-teal-50 border border-teal-200 rounded-lg p-6 mb-8">
    <h2 class="text-xl font-semibold text-teal-800 mb-4">
      この企業が提供できる配慮
    </h2>
    
    <% @job.accommodation_tags.group_by(&:category).each do |category, tags| %>
      <div class="mb-4">
        <h3 class="text-lg font-medium text-teal-700 mb-2">
          <%= category_name(category) %>
        </h3>
        <div class="flex flex-wrap gap-2">
          <% tags.each do |tag| %>
            <span class="bg-white border border-teal-300 text-teal-800 px-3 py-1 rounded-full text-sm">
              ✓ <%= tag.name %>
            </span>
          <% end %>
        </div>
      </div>
    <% end %>
  </div>

  <!-- その他の求人情報（省略） -->
</div>

---

## マッチングアルゴリズム

### アルゴリズムの考え方

マッチ度を0～100%で算出します。

**計算式**
マッチ度 = (必須配慮のマッチ数 / 必須配慮の総数) × 70% + (希望配慮のマッチ数 / 希望配慮の総数) × 30%

**重み付けの理由**

- **必須配慮**：70%の重み（最重要、1つでも欠けると大きく減点）
- **希望配慮**：30%の重み（あると嬉しい程度）

---

### 実装コード

#### MatchingService クラス

# app/services/matching_service.rb

class MatchingService
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

    # 必須が1つでも欠けている場合は大幅減点
    return 0 if required_score == 0 && @job_seeker.required_accommodation_tags.any?

    (required_score * 0.7 + preferred_score * 0.3).round

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

---

### マッチング結果の表示

#### 求人検索結果ページ

# app/controllers/jobs_controller.rb

class JobsController < ApplicationController
def index
@jobs = Job.published.includes(:company, :accommodation_tags)

    # マッチ度でソート
    @jobs_with_score = @jobs.map do |job|
      score = job.company.match_score(current_job_seeker)
      { job: job, score: score }
    end.sort_by { |item| -item[:score] } # 降順

end
end

<!-- app/views/jobs/index.html.erb -->

<div class="max-w-6xl mx-auto p-8">
  <h1 class="text-3xl font-bold mb-8">求人検索結果</h1>

  <div class="space-y-6">
    <% @jobs_with_score.each do |item| %>
      <% job = item[:job] %>
      <% score = item[:score] %>

      <div class="bg-white rounded-lg shadow-lg p-6 border-l-4 <%= match_color_class(score) %>">
        <div class="flex justify-between items-start mb-4">
          <div>
            <h2 class="text-2xl font-semibold text-gray-900">
              <%= link_to job.title, job_path(job), class: "hover:text-teal-600" %>
            </h2>
            <p class="text-gray-600"><%= job.company.company_name %></p>
          </div>
          <div class="text-right">
            <span class="text-3xl font-bold <%= match_text_class(score) %>">
              <%= score %>%
            </span>
            <p class="text-sm text-gray-500">マッチ度</p>
          </div>
        </div>

        <!-- 配慮タグ表示（最大5個） -->
        <div class="flex flex-wrap gap-2 mb-4">
          <% job.accommodation_tags.limit(5).each do |tag| %>
            <span class="bg-teal-100 text-teal-800 px-3 py-1 rounded-full text-sm">
              ✓ <%= tag.name %>
            </span>
          <% end %>
          <% if job.accommodation_tags.size > 5 %>
            <span class="text-gray-500 text-sm">他<%= job.accommodation_tags.size - 5 %>件</span>
          <% end %>
        </div>

        <div class="flex justify-between items-center">
          <p class="text-gray-600"><%= job.location %> / <%= job.employment_type %></p>
          <%= link_to "詳細を見る", job_path(job),
              class: "bg-teal-600 text-white px-4 py-2 rounded hover:bg-teal-700" %>
        </div>
      </div>
    <% end %>

  </div>
</div>

**ヘルパーメソッド**

# app/helpers/jobs_helper.rb

module JobsHelper
def match_color_class(score)
case score
when 80..100 then "border-green-500"
when 60..79 then "border-blue-500"
when 40..59 then "border-yellow-500"
else "border-gray-300"
end
end

def match_text_class(score)
case score
when 80..100 then "text-green-600"
when 60..79 then "text-blue-600"
when 40..59 then "text-yellow-600"
else "text-gray-500"
end
end
end

---

## 実装手順

### Week 2-3：配慮タグシステム実装（5日間）

#### Day 1：マイグレーション＋シードデータ

# マイグレーション実行

rails generate migration CreateAccommodationTags
rails generate migration CreateJobSeekerAccommodations
rails generate migration CreateCompanyAccommodations
rails db:migrate

**シードデータ作成（db/seeds.rb）**

# 配慮タグの作成

tags_data = [

# 作業環境

{ name: '静かな個室あり', category: 'environment', description: '音に敏感な方向けの個室または防音ブース', display_order: 1 },
{ name: 'パーティション席', category: 'environment', description: '視覚的な刺激を減らすための間仕切り席', display_order: 2 },
{ name: '在宅勤務可（週3日以上）', category: 'environment', description: '週の半分以上を在宅で勤務可能', display_order: 3 },

# ... 残り27個（省略）

]

tags_data.each do |tag_data|
AccommodationTag.find_or_create_by!(name: tag_data[:name]) do |tag|
tag.category = tag_data[:category]
tag.description = tag_data[:description]
tag.display_order = tag_data[:display_order]
end
end

puts "✅ 配慮タグ #{AccommodationTag.count} 件を作成しました"

rails db:seed

---

#### Day 2-3：モデル・コントローラー実装

**コントローラー作成**

rails generate controller JobSeeker::Accommodations new create edit update

# app/controllers/job_seeker/accommodations_controller.rb

class JobSeeker::AccommodationsController < ApplicationController
before_action :authenticate_user!
before_action :ensure_job_seeker

def new
@tags = AccommodationTag.ordered.group_by(&:category)
end

def create
current_job_seeker.job_seeker_accommodations.destroy_all

    accommodations_params.each do |tag_id, priority|
      current_job_seeker.job_seeker_accommodations.create!(
        accommodation_tag_id: tag_id,
        priority: priority
      )
    end

    redirect_to job_seeker_dashboard_path, notice: '配慮を登録しました'

end

def edit
@tags = AccommodationTag.ordered.group_by(&:category)
@selected_tags = current_job_seeker.job_seeker_accommodations.index_by(&:accommodation_tag_id)
end

def update # create と同じロジック
create
end

private

def accommodations_params
params.require(:accommodations).permit!
end

def ensure_job_seeker
redirect_to root_path unless current_user.job_seeker?
end
end

---

#### Day 4：UI実装（ビュー）

前述の「求職者側のUI設計」のコードを実装。

---

#### Day 5：テスト＋デバッグ

**手動テスト項目**

- [ ] 配慮タグ30種類が正しく表示される
- [ ] 必須/希望の選択が保存される
- [ ] 編集時に既存選択が反映される
- [ ] カテゴリごとにグループ化されている

---

### Week 4-5：マッチング機能実装（5日間）

#### Day 1-2：MatchingService 実装

前述の「マッチングアルゴリズム」のコードを実装。

---

#### Day 3-4：求人検索画面

# app/controllers/jobs_controller.rb

class JobsController < ApplicationController
def index
@jobs = Job.published.includes(:company, :accommodation_tags)

    # 配慮タグでフィルタリング
    if params[:accommodation_tag_ids].present?
      tag_ids = params[:accommodation_tag_ids].reject(&:blank?).map(&:to_i)
      @jobs = @jobs.joins(:accommodation_tags)
                   .where(accommodation_tags: { id: tag_ids })
                   .distinct
    end

    # マッチ度計算＋ソート
    if current_user&.job_seeker?
      @jobs_with_score = @jobs.map do |job|
        { job: job, score: job.company.match_score(current_job_seeker) }
      end.sort_by { |item| -item[:score] }
    else
      @jobs_with_score = @jobs.map { |job| { job: job, score: nil } }
    end

end
end

---

#### Day 5：テスト

**テストケース**

- 必須配慮が全て満たされている → マッチ度 80%以上
- 必須配慮が1つ欠けている → マッチ度 50%以下
- 必須配慮が全て欠けている → マッチ度 0%

---

## まとめ

### 完成する機能

✅ 30種類の配慮タグシステム  
✅ 求職者の配慮選択UI（必須/希望の2段階）  
✅ 企業の配慮選択UI  
✅ マッチングアルゴリズム（0～100%のスコア）  
✅ マッチ度順での求人表示

### 次のステップ

1. **Week 3-4**：求人登録機能の実装
2. **Week 4-5**：求人検索・マッチング機能の実装
3. **Week 5-6**：応募・メッセージ機能の実装

### 懸念点・要検討事項

1. **配慮タグの網羅性**：30種類で十分か？ユーザーテストで検証が必要
2. **マッチングアルゴリズムの調整**：必須70%、希望30%の重み付けは適切か？
3. **カスタムタグ**：企業が独自の配慮を追加できるようにすべきか？（Phase 2検討）

---

**作成者**: AI Assistant  
**最終更新**: 2026年2月2日
