# ER図（ココロキャリア）

Rails のモデル定義と `db/schema.rb` を元に作成した、現在のデータベース構造の ER 図です。
Mermaid をサポートしているビューア（GitHub / VS Code の Markdown Preview Mermaid Support 拡張など）で表示できます。

## 全体図

```mermaid
erDiagram
    users ||--o| companies : "has_one"
    users ||--o| job_seekers : "has_one"
    users ||--o{ daily_reports : "writes"
    users ||--o{ messages : "sends (sender)"
    users ||--o{ messages : "receives (recipient)"
    users ||--o{ reports : "reports (reporter)"

    companies ||--o{ jobs : "posts"
    companies ||--o{ company_accommodations : "has"
    companies ||--o{ internships : "hosts"

    job_seekers ||--o{ applications : "submits"
    job_seekers ||--o{ job_seeker_accommodations : "needs"
    job_seekers ||--o{ internships : "participates"

    jobs ||--o{ applications : "receives"
    jobs ||--o{ internships : "linked"

    applications ||--o| internships : "becomes"
    applications ||--o{ messages : "thread"

    accommodation_tags ||--o{ company_accommodations : "tagged"
    accommodation_tags ||--o{ job_seeker_accommodations : "tagged"

    internships ||--o{ daily_reports : "contains"

    users {
        bigint id PK
        string email UK
        string encrypted_password
        string name
        integer user_type "enum: job_seeker/company"
        string reset_password_token UK
        datetime reset_password_sent_at
        datetime remember_created_at
        datetime created_at
        datetime updated_at
    }

    companies {
        bigint id PK
        bigint user_id FK
        string company_name
        string location
        integer employee_count
        string industry
        string website_url
        text description
        datetime created_at
        datetime updated_at
    }

    job_seekers {
        bigint id PK
        bigint user_id FK
        integer disability_type
        boolean disability_certificate
        string preferred_location
        string preferred_job_type
        text bio
        datetime created_at
        datetime updated_at
    }

    jobs {
        bigint id PK
        bigint company_id FK
        string title
        string job_type
        text description
        string location
        integer salary_min
        integer salary_max
        boolean internship_available
        integer status "enum"
        datetime created_at
        datetime updated_at
    }

    applications {
        bigint id PK
        bigint job_seeker_id FK
        bigint job_id FK
        integer status "enum"
        text message
        datetime created_at
        datetime updated_at
    }

    internships {
        bigint id PK
        bigint application_id FK "unique"
        bigint company_id FK
        bigint job_seeker_id FK
        bigint job_id FK
        date start_date
        date end_date
        integer status "enum"
        text company_feedback
        text job_seeker_feedback
        datetime created_at
        datetime updated_at
    }

    daily_reports {
        bigint id PK
        bigint internship_id FK
        bigint user_id FK
        text content
        date report_date
        datetime created_at
        datetime updated_at
    }

    messages {
        bigint id PK
        bigint application_id FK
        bigint sender_id FK
        bigint recipient_id FK
        text content
        datetime read_at
        datetime created_at
        datetime updated_at
    }

    accommodation_tags {
        bigint id PK
        string name UK
        string category
        text description
        integer display_order
        datetime created_at
        datetime updated_at
    }

    company_accommodations {
        bigint id PK
        bigint company_id FK
        bigint accommodation_tag_id FK
        text detail_description
        datetime created_at
        datetime updated_at
    }

    job_seeker_accommodations {
        bigint id PK
        bigint job_seeker_id FK
        bigint accommodation_tag_id FK
        integer priority
        datetime created_at
        datetime updated_at
    }

    reports {
        bigint id PK
        bigint reporter_id FK "→ users"
        string target_type "polymorphic"
        bigint target_id "polymorphic"
        integer reason "enum"
        integer status "enum"
        text description
        datetime created_at
        datetime updated_at
    }
```

## 関連のポイント

### 1. User を起点としたプロフィール分岐
- `users.user_type`（enum）で「求職者」か「企業」かを区別
- `User` は `Company` もしくは `JobSeeker` を `has_one` で持つ
- 求職者 / 企業のどちらになるかはサインアップ時に決まる

### 2. 応募 → インターン の流れ
```
JobSeeker  ─┐
            ├─► Application ─► Internship ─► DailyReport（毎日の日報）
Job        ─┘      │
                   └─► Message（応募スレッド上のやり取り）
```
- `applications` は `job_seeker_id + job_id` で一意（同じ求人に重複応募不可）
- `internships` は `application_id` が **unique**（1応募につき最大1インターン）
- `messages` は `application` に紐づき、`sender` / `recipient` の両方が `users` を参照

### 3. 配慮事項タグ（Accommodation）
- `AccommodationTag` を中間テーブルで企業・求職者それぞれに紐付け
  - `company_accommodations`: 企業が提供できる配慮
  - `job_seeker_accommodations`: 求職者が必要とする配慮（`priority` 付き）
- 同じ `company_id + accommodation_tag_id` / `job_seeker_id + accommodation_tag_id` の重複は不可

### 4. 通報（Report）はポリモーフィック
- `reports.target_type` + `target_id` で `Job` / `User` など複数のモデルを通報対象にできる
- `reporter_id` は `users` への FK

## 図の見方（Mermaid 記法）

| 記号 | 意味 |
|------|------|
| `\|\|--o\|` | 1 対 0..1 |
| `\|\|--o{` | 1 対 0..多 |
| `}o--o{` | 多 対 多 |
| `PK` | 主キー |
| `FK` | 外部キー |
| `UK` | ユニーク制約 |
