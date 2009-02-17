class TagsController < ApplicationController

  def index
      @tags = Photo.tag_counts( :order => "name" )
  end

  def tag_cloud 
	@tags = Word.tag_counts(:limit => 20, :order => 'id desc') # returns all the tags used 
  end

  def show
	@words = Word.paginate_tagged_with(params[:id], :per_page =>10, :page => params[:page] )
  end

end
