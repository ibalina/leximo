class CreateRolesUsers < ActiveRecord::Migration
  def self.up
    create_table :roles_users, :id => false do |t|
      t.integer :role_id, :user_id, :null => false
      t.timestamps
    end
    #Then, add default admin user
    #Be sure change the password later or in this migration file
    user = User.new({
      :login => "ian",
      :email => "ian@leximo.org",
      :password => "superman88",
      :password_confirmation => "superman88"
    })
    user.roles << Role.find_by_name('administrator')
    user.save(false)
    user = User.find_by_login('ian')
    user.send(:activate!)
  end
 
  def self.down
    drop_table :roles_users
  end
end
