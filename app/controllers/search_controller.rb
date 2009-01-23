    class SearchController < ApplicationController
      layout 'application'
      before_filter :login_required, :only => :destroy
      before_filter :not_logged_in_required, :only => [:new, :create]
      
      def search
	@words = Word.search params[:search], :per_page => 20, :page => params[:page]
	#@words = Word.search params[:search], :page =>1, :per_page => 20
      end
  end
