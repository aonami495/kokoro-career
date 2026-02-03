class CreateAccommodationTags < ActiveRecord::Migration[7.2]
  def change
    create_table :accommodation_tags do |t|
      t.string :name, null: false
      t.string :category, null: false
      t.text :description
      t.integer :display_order, default: 0

      t.timestamps
    end

    add_index :accommodation_tags, :category
    add_index :accommodation_tags, :name, unique: true
  end
end
