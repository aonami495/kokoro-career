# Render へのデプロイ手順

このアプリは [`render.yaml`](../render.yaml)（Blueprint）でWebサービスと PostgreSQL をまとめて定義しています。

## 前提

- GitHub リポジトリ（`aonami495/kokoro-career`）に `render.yaml` がpush済みであること
- 手元に `config/master.key` があること（本番のcredentials復号に必要）

---

## 1. Blueprint からサービスを作成

1. [Render ダッシュボード](https://dashboard.render.com/) にログイン（GitHubでサインアップ可）
2. **「New +」→「Blueprint」** を選択
3. リポジトリ `aonami495/kokoro-career` を接続して選択
4. Render が `render.yaml` を読み込み、以下を作成しようとする：
   - Web サービス `kokoro-career`（Docker / Singapore / Free）
   - PostgreSQL `kokoro-career-db`（Free / Singapore）
5. **`RAILS_MASTER_KEY`** の入力を求められる（`sync: false` のため）。
   手元で次を実行して中身をコピーし、貼り付ける：
   ```bash
   cat config/master.key
   ```
6. **「Apply」** を押すとビルド＆デプロイが始まる（Dockerビルドで数分）

> 起動時に `bin/docker-entrypoint` が `db:prepare` を実行するので、
> マイグレーションと配慮タグの seed（初回のみ）は自動で行われます。

---

## 2. 動作確認

- デプロイ完了後、`https://kokoro-career.onrender.com`（Renderが割り当てるURL）にアクセス
- 求人検索・新規登録（求職者/企業）が動けばOK
- ヘルスチェックは `/up`

---

## 3. 管理者アカウントの作成（任意）

Render の **無料プランはシェル/SSHが使えない**ため、`rails runner` をサーバー上で実行できません。
代わりに、**手元のPCから本番DBに直接つないで** 作成します。

1. Render ダッシュボード → `kokoro-career-db` → **「Connect」→ External Connection** の
   `External Database URL` をコピー
2. 手元で実行（`<EXTERNAL_DB_URL>` を差し替え）：
   ```bash
   RAILS_ENV=production \
   DATABASE_URL="<EXTERNAL_DB_URL>" \
   RAILS_MASTER_KEY="$(cat config/master.key)" \
   bin/rails runner "User.create!(name: '管理者', email: 'admin@example.com', password: '十分に長いパスワード', user_type: :admin)"
   ```
3. 作成したメール/パスワードで `/admin/dashboard` にログイン

> ⚠️ 公開デモでは推測されにくいメール・パスワードにすること（このアプリは障がい/通院などの
> センシティブ情報を扱う設計のため、本番運用時は特に取り扱いに注意）。

---

## 無料プランの注意点

- **スリープ**：15分アクセスがないとWebサービスが停止し、次回アクセスで起動に30〜60秒かかる（コールドスタート）
- **無料DBの期限**：Renderの無料PostgreSQLは作成から一定期間（約30日）で削除される。継続運用するなら有料プランへ。
- **自動デプロイ**：`autoDeployTrigger: commit` により、`main` への push で自動再デプロイされる

---

## トラブルシューティング

| 症状 | 原因/対処 |
|---|---|
| 起動直後に500 / credentials エラー | `RAILS_MASTER_KEY` 未設定 or 値が違う。`config/master.key` の中身を再確認 |
| リダイレクトループ | `config.assume_ssl = true`（設定済み）が効いているか確認 |
| 配慮タグが空 | 初回 `db:prepare` の seed が走ったか確認。手元から `DATABASE_URL=... bin/rails db:seed` で再投入可（冪等） |
| アセットが崩れる | `RAILS_SERVE_STATIC_FILES=true`（設定済み）を確認 |
