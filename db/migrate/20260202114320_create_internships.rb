class CreateInternships < ActiveRecord::Migration[7.2]
  def change
    create_table :internships do |t|
      t.references :application, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :status, default: 0, null: false
      t.text :company_feedback
      t.text :job_seeker_feedback

      t.timestamps
    end

    # referencesが作成したインデックスを削除して、ユニーク制約付きで再作成
    remove_index :internships, :application_id
    add_index :internships, :application_id, unique: true
  end
end
