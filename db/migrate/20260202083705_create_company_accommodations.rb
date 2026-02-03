class CreateCompanyAccommodations < ActiveRecord::Migration[7.2]
  def change
    create_table :company_accommodations do |t|
      t.references :company, null: false, foreign_key: true
      t.references :accommodation_tag, null: false, foreign_key: true
      t.text :detail_description

      t.timestamps
    end

    add_index :company_accommodations,
              [:company_id, :accommodation_tag_id],
              unique: true,
              name: "index_company_accommodations_on_company_and_tag"
  end
end
