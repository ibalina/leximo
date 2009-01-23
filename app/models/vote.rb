class Vote < ActiveRecord::Base
	belongs_to :word, :counter_cache => true
	belongs_to :user
	validates_uniqueness_of :user_id, :scope => :word_id
end
