class CreateUsersettings < ActiveRecord::Migration[7.0]
  def change
    create_table :usersettings do |t|
      t.references :user,            null: false, foreign_key: true
      t.boolean :configuration_state
      t.integer :countdown_time
      t.timestamps
    end
  end
end
