class CreateApplications < ActiveRecord::Migration[7.2]
  def change
    create_table :applications do |t|
      t.references :job_seeker, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true
      t.integer :status, default: 0, null: false
      t.text :message

      t.timestamps
    end

    # ユニーク制約: 同じ求人に二重応募できないように
    add_index :applications, [:job_seeker_id, :job_id], unique: true
  end
end
