require 'test_helper'

class VoteTest < ActiveSupport::TestCase
	def test_word_association
		assert_equal words(:one), votes(:one).word
	end
end
