class AddCounterCacheToWords < ActiveRecord::Migration
  def self.up
    add_column :words, :votes_count, :integer, :default => 0 
	Word.find(:all).each do |s|
		s.update_attribute :votes_count, s.votes.length
	end
  end

  def self.down
    remove_column :words, :votes_count
  end
end
