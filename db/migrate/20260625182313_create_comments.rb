class CreateComments < ActiveRecord::Migration[8.1]
  def change
    create_table :comments do |t|
      t.references :commentable, null: false, polymorphic: true
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.string :text

      t.timestamps
    end
  end
end
