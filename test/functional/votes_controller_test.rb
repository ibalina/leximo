require 'test_helper'

class VotesControllerTest < ActionController::TestCase
	def test_should_accept_vote
		assert words(:two).votes.empty?
		post :create, :word_id => words(:two)
		assert ! assigns(:word).votes.empty?
	end
	def test_should_render_rjs_after_vote_with_ajax
		xml_http_request :post, :create, :word_id => words(:two)
		assert_response :success
		assert_template 'create'
	end 	
	def test_should_redirect_after_vote_with_http_post
		post :create, :word_id => words(:two)
		assert_redirected_to word_path(words(:two))
	end	
end
