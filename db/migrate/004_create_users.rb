class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :login,                     :string
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
      t.column :activation_code, :string, :limit => 40
      t.column :activated_at, :datetime
      t.column :password_reset_code, :string, :limit => 40
      t.column :enabled, :boolean, :default => true       
     end
     add_column :words, :user_id, :integer
     add_column :votes, :user_id, :integer
     add_column :users, :name, :string, :limit => 40
     add_column :users, :location, :string, :limit => 40
     add_column :users, :web, :string, :limit => 40
     add_column :users, :bio, :text, :limit => 140
 
  end

  def self.down
    drop_table "users"
    remove_column :words, :user_id
    remove_column :votes, :user_id
    remove_column :users, :name
    remove_column :users, :location
    remove_column :users, :web
    remove_column :users, :bio	
  end
end
