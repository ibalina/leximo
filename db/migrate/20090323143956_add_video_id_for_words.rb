class AddVideoIdForWords < ActiveRecord::Migration
  def self.up
    add_column :words , :video_id , :string
  end

  def self.down
    remove_column :words , :video_id 
  end
end
