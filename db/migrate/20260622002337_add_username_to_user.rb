class AddUsernameToUser < ActiveRecord::Migration[8.1]
  def change
    change_table :users do |t|
      t.string :username, null: false
      t.index :username, unique: true
    end
  end
end
