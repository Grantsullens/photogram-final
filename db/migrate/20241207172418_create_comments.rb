class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :author_id
      t.integer :photo_id

      t.timestamps
    end

    # Post-generation edits:
    add_foreign_key :comments, :users, column: :author_id
    add_index :comments, :author_id

    add_foreign_key :comments, :photos, column: :photo_id
    add_index :comments, :photo_id
  end
end
