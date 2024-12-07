class CreatePhotos < ActiveRecord::Migration[7.1]
  def change
    create_table :photos do |t|
      t.text :caption
      t.string :image
      t.integer :likes_count
      t.integer :comments_count
      t.integer :owner_id

      t.timestamps
    end

    # Post-generation edits:
    add_foreign_key :photos, :users, column: :owner_id
    add_index :photos, :owner_id
  end
end
