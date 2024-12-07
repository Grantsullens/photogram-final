class CreateLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :likes do |t|
      t.integer :fan_id
      t.integer :photo_id

      t.timestamps
    end

    # Post-generation edits:
    add_foreign_key :likes, :users, column: :fan_id
    add_index :likes, :fan_id

    add_foreign_key :likes, :photos, column: :photo_id
    add_index :likes, :photo_id
  end
end
