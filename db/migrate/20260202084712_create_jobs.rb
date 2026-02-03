class CreateJobs < ActiveRecord::Migration[7.2]
  def change
    create_table :jobs do |t|
      t.references :company, null: false, foreign_key: true
      t.string :title, null: false
      t.string :job_type
      t.text :description
      t.string :location
      t.integer :salary_min
      t.integer :salary_max
      t.boolean :internship_available, default: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :jobs, :status
    add_index :jobs, :internship_available
  end
end
