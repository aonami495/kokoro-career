# kokoro-career — プロジェクト規約

- **目的**: 障がい者と企業を「必要な配慮／提供できる配慮」でマッチングする求人プラットフォーム（ココロキャリア）。
- **スタック**: Rails 7.2 + PostgreSQL + Hotwire + Devise。
- **本番**: Render に本番デプロイ済み・ライブ稼働（https://kokoro-career.onrender.com ／無料枠／`render.yaml` Blueprint）。
- **⚠️ デプロイ特性（最重要）**: `render.yaml: autoDeployTrigger: commit` ＝ **`main` へのコミットが即・本番デプロイ**。ブランチ隔離が無いので、**main へのコミット＝本番反映GO（Sena承認事項 A1）**。起動時に `db:prepare` が走るため、migration の取り込み＝本番影響。
- **テスト**: RSpec（request spec 等。2026-06-24 時点で 73本・0fail）。

## 固有の死守ライン（盲点由来・`~/アプリ開発/INCIDENTS.md` 参照）
- **認可は必ずポリシー層でテスト**（許可/拒否の両方）。新規の入力受理は許可リスト方式。認可変更そのものは人間レビュー必須（INC-1 権限昇格バグ）。
- **GETに副作用を作らない／二重render させない**（INC-2 日報二重render・非冪等GET 残課題）。
- **一覧・関連ロードに N+1 を残さない**（eager load／INC-3 求人一覧N+1）。
- **テストは雛形でなく実動作を検証**（INC-4）。

---

## 擬似開発会社・運用OS（2026-06-30 設置）

- **現フェーズ（状態の正本）**: `phase: P6`（運用・グロース。本番ライブ）
- チーム開発・リリース判断のときは、組織OSの正本 **`~/アプリ開発/AGENT_TEAM.md`**（3層編成・承認3区分・コミット前QAゲート §8.2・モデルティア）と盲点台帳 **`~/アプリ開発/INCIDENTS.md`** を読むこと。
- このリポはライブ本番なので、PdM のセッション開始ルーチンは**フル6点**（日付→対象リポ→AGENTS.md→`git status`/ブランチ→main commit＝本番である自覚→Sena見落とし確認）。
- **VCS**: git有り（`main`）。`push --force`・履歴の恒久改変は固い禁止。破壊的migration・本番DB操作は Sena 承認（A2/A3）。
