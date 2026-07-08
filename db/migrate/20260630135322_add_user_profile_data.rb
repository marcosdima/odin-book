class AddUserProfileData < ActiveRecord::Migration[8.1]
  def change
    change_table :users do |t|
      t.string :avatar_url
      t.string :bio
      t.string :location
      t.string :first_name
      t.string :last_name
      t.string :timezone
    end
  end
end
