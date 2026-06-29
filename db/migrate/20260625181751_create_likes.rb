class CreateLikes < ActiveRecord::Migration[8.1]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :likeable, null: false, polymorphic: true

      t.timestamps

      t.index %i[user_id likeable_type likeable_id], unique: true
    end
  end
end
