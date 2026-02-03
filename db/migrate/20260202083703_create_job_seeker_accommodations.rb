class CreateJobSeekerAccommodations < ActiveRecord::Migration[7.2]
  def change
    create_table :job_seeker_accommodations do |t|
      t.references :job_seeker, null: false, foreign_key: true
      t.references :accommodation_tag, null: false, foreign_key: true
      t.integer :priority, default: 0

      t.timestamps
    end

    add_index :job_seeker_accommodations,
              [:job_seeker_id, :accommodation_tag_id],
              unique: true,
              name: "index_js_accommodations_on_js_and_tag"
  end
end
