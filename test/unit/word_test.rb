require 'test_helper'

class WordTest < ActiveSupport::TestCase
  # Replace this with your real tests.
def test_should_not_be_valid_without_word
	s = Word.create(:word => nil, :language => 'english', 
		:definition => 'something', :example => 'example worked')
		assert s.errors.on(:word) 
end
def test_should_not_be_valid_without_language
 	s = Word.create(:word => 'example', :language => nil, 
		:definition => 'something', :example => 'example worked')
		assert s.errors.on(:language) 
end
def test_should_not_be_valid_without_definition
 	s = Word.create(:word => 'example', :language => 'english', 
		:definition => nil, :example => 'example worked')
		assert s.errors.on(:definition) 
end
def test_should_not_be_valid_without_example
 	s = Word.create(:word => 'example', :language => 'english', 
		:definition => 'something', :example => nil)
		assert s.errors.on(:example) 
end
def test_should_create_word
 	s = Word.create(:word => 'example', :language =>'english', 
		:definition => 'something', :example => 'example worked')
		assert s.valid? 
end
def test_should_have_a_votes_association
 assert_equal [ votes(:one), votes(:two) ],
 words(:one).votes
end
def test_should_return_highest_vote_id_first
 assert_equal votes(:two), words(:one).votes.latest.first
end
def test_should_return_3_latest_votes
 10.times { words(:one).votes.create }
 assert_equal 3, words(:one).votes.latest.size
end
end
