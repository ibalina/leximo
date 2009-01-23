require 'test_helper'

class WordsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
	def test_should_show_index
		get :index
		assert_response :success
		assert_template 'index'
		assert_not_nil assigns(:word) 
	end
	def test_should_show_new
		get :new
		assert_response :success
		assert_template 'new'
		assert_not_nil assigns(:word) 
	end
	def test_should_show_new_form
		get :new
		assert_select 'form p', :count => 5 
	end
	def test_should_add_word
		post :create, :word => {
		:word => 'test',
		:language => 'english',
		:definition => 'to check or examine',
		:example => 'they tested my skills'
		
		}
		assert ! assigns(:word).new_record?
		assert_redirected_to words_path
		assert_not_nil flash[:notice] 
	end 
	def test_should_reject_missing_word_attribute
		post :create, :word => { :word => 'word without other attributes' }
		assert assigns(:word).errors.on(:language) 
		assert assigns(:word).errors.on(:definition) 
		assert assigns(:word).errors.on(:example) 		
	end
	def test_should_show_word
		get :show, :id => words(:one)
		assert_response :success
		assert_template 'show'
		assert_equal words(:one), assigns(:word)
	end
	def test_should_show_word_vote_elements
		get :show, :id => words(:one)
		assert_select 'h2 span#vote_score'
		assert_select 'ul#vote_history li', :count => 2
		assert_select 'div#vote_form form'
 end
	
end
