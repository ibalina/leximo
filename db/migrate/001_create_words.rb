class CreateWords < ActiveRecord::Migration
  def self.up
    create_table :words, :force => false do |t|
      t.string :word
      t.string :language
      t.text :definition
      t.string :example

      t.timestamps
    end
  end

  def self.down
    drop_table :words
  end
end
