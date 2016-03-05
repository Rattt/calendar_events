class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :full_name
      t.string :email, limit: 120, unique: true, null: false
      t.string :password_digest, null: false
      t.string :remember_token, null: false, index: true

      t.timestamps null: false
    end
  end
  def self.down
    drop_table :users
  end
end
