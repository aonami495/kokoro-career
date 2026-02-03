class CreateDailyReports < ActiveRecord::Migration[7.2]
  def change
    create_table :daily_reports do |t|
      t.references :internship, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :content, null: false
      t.date :report_date, null: false

      t.timestamps
    end

    # 同じ日に同じユーザーが複数の日報を作成できないように
    add_index :daily_reports, [:internship_id, :user_id, :report_date], unique: true, name: "index_daily_reports_uniqueness"
  end
end
