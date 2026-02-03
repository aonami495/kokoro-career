class CreateReports < ActiveRecord::Migration[7.2]
  def change
    create_table :reports do |t|
      t.references :reporter, null: false, foreign_key: { to_table: :users }
      t.references :target, polymorphic: true, null: false
      t.integer :reason, null: false, default: 0
      t.text :description
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :reports, [:target_type, :target_id]
    add_index :reports, :status
  end
end
