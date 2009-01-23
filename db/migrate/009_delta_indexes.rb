  class DeltaIndexes < ActiveRecord::Migration
    def self.up
	add_column :words, :delta, :boolean, :default => false 
	Word.reset_column_information    
    end

    def self.down
      remove_column :words, :delta
    end
  end

