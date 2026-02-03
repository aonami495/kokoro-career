class CreateJobSeekers < ActiveRecord::Migration[7.2]
  def change
    create_table :job_seekers do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :disability_type
      t.boolean :disability_certificate
      t.string :preferred_location
      t.string :preferred_job_type
      t.text :bio

      t.timestamps
    end
  end
end
