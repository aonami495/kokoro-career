class CreateCompanies < ActiveRecord::Migration[7.2]
  def change
    create_table :companies do |t|
      t.references :user, null: false, foreign_key: true
      t.string :company_name
      t.string :location
      t.integer :employee_count
      t.string :industry
      t.string :website_url
      t.text :description

      t.timestamps
    end
  end
end
