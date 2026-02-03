# ココロキャリア

障がい者と企業をつなぐ、配慮マッチング型求人プラットフォーム

## 概要

ココロキャリアは、障がいを持つ求職者と企業をマッチングする求人サービスです。「配慮タグ」システムにより、求職者が必要とする配慮と企業が提供できる配慮を可視化し、ミスマッチを防ぎます。

### 主な特徴

- **配慮タグによるマッチング**: 求職者の必要な配慮と企業の提供可能な配慮をマッチング
- **マッチ度スコア表示**: 求人一覧・詳細でマッチ度をパーセンテージで表示
- **体験実習機能**: 入社前に1〜2週間の職場体験が可能
- **日報システム**: 実習中の双方向コミュニケーションをサポート

## 技術スタック

- **Ruby**: 3.2.2
- **Rails**: 7.2.3
- **データベース**: PostgreSQL
- **CSS**: Tailwind CSS
- **JavaScript**: Hotwire (Turbo + Stimulus)
- **認証**: Devise

## セットアップ

### 必要条件

- Ruby 3.2.2
- PostgreSQL 14+
- Node.js 18+

### インストール

```bash
# リポジトリをクローン
git clone https://github.com/your-username/kokoro-career.git
cd kokoro-career

# 依存関係をインストール
bundle install

# データベースを作成・マイグレーション
bin/rails db:create
bin/rails db:migrate

# シードデータを投入（配慮タグ）
bin/rails db:seed

# Tailwind CSSをビルド
bin/rails tailwindcss:build

# サーバーを起動
bin/rails server
```

### 開発用アカウント

シードデータ投入後、以下のコマンドで管理者アカウントを作成できます：

```bash
bin/rails runner "User.create!(name: '管理者', email: 'admin@example.com', password: 'password', user_type: :admin)"
```

## 機能一覧

### 求職者向け機能

| 機能 | 説明 |
|------|------|
| 求人検索 | 配慮タグでフィルタリング可能な求人検索 |
| マッチ度表示 | 自分の配慮ニーズとのマッチ度をスコア表示 |
| 応募管理 | 求人への応募とステータス確認 |
| メッセージ | 企業との双方向メッセージング |
| 体験実習 | 実習オファーの承諾・実習中の日報投稿 |
| 配慮タグ設定 | 必要な配慮を「必須」「希望」で登録 |

### 企業向け機能

| 機能 | 説明 |
|------|------|
| 求人管理 | 求人の作成・編集・公開設定 |
| 応募者管理 | 応募者の確認・メッセージ送信 |
| 実習オファー | 応募者への実習オファー送信 |
| 配慮タグ設定 | 提供可能な配慮を登録 |
| 日報確認 | 実習中の求職者の日報を確認 |

### 管理者向け機能

| 機能 | パス |
|------|------|
| ダッシュボード | `/admin/dashboard` |
| ユーザー管理 | `/admin/users` |
| 求人管理 | `/admin/jobs` |
| 配慮タグ管理 | `/admin/accommodation_tags` |
| 通報管理 | `/admin/reports` |

## 配慮タグカテゴリ

| カテゴリ | 例 |
|---------|-----|
| 作業環境 | 静かな個室あり、在宅勤務可、フルリモート可 |
| コミュニケーション | 指示は文書で、チャットツール使用、電話対応なし |
| 勤務時間 | 時短勤務可、フレックスタイム、通院配慮あり |
| サポート体制 | ジョブコーチ常駐、メンター制度、定期面談 |

## マッチングスコア計算

```
マッチ度 = (必須配慮のマッチ率 × 70%) + (希望配慮のマッチ率 × 30%)
```

- 必須配慮が1つでも欠けている場合、スコアは0%
- 必須配慮がすべてマッチしている場合、70%以上が保証

## 実習フロー

```
1. 求職者が応募
2. 企業が実習オファーを送信（日程指定）
3. 求職者がオファーを承諾
4. 実習期間中、双方が日報を投稿
5. 実習終了後、企業が「本採用」または「終了」を選択
```

## ディレクトリ構造

```
app/
├── controllers/
│   ├── admin/           # 管理者用コントローラー
│   ├── company/         # 企業用コントローラー
│   ├── job_seeker/      # 求職者用コントローラー
│   └── ...
├── models/
│   ├── user.rb          # ユーザー（Devise）
│   ├── job.rb           # 求人
│   ├── application.rb   # 応募
│   ├── internship.rb    # 体験実習
│   ├── daily_report.rb  # 日報
│   ├── message.rb       # メッセージ
│   ├── accommodation_tag.rb      # 配慮タグ
│   ├── job_seeker_accommodation.rb  # 求職者の配慮設定
│   ├── company_accommodation.rb     # 企業の配慮設定
│   └── report.rb        # 通報
├── services/
│   └── matching_service.rb  # マッチングスコア計算
└── views/
    ├── admin/           # 管理画面
    ├── company/         # 企業用画面
    ├── job_seeker/      # 求職者用画面
    └── ...
```

## テスト

```bash
# RSpecを実行
bundle exec rspec

# 通しテストスクリプト
bin/rails runner test_scenario.rb
```

## 環境変数

本番環境では以下の環境変数を設定してください：

```
DATABASE_URL=postgres://...
RAILS_MASTER_KEY=...
SECRET_KEY_BASE=...
```

## ライセンス

MIT License

## コントリビューション

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
