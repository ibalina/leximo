class VotesController < ApplicationController
before_filter :login_required

  def create
	@word = Word.find(params[:word_id])
	@word.votes.create!(:user => @current_user)
	expire_fragment(:controller => 'words', :action => 'index')
	expire_fragment(:controller => 'words', :action => 'recent')
	expire_fragment(:controller => 'words', :action => 'show')
	expire_fragment(:controller => 'words', :action => 'index', :page => 1)
	expire_fragment(:controller => 'words', :action => 'index', :page => 2)

	respond_to do |format| 
		format.html { redirect_to @word } 
		format.js 
	end	

  end

end
