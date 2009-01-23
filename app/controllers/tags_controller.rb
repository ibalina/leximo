class TagsController < ApplicationController

  def index
      @tags = Photo.tag_counts( :order => "name" )
  end

  def show
	@words = Word.paginate_tagged_with(params[:id], :per_page =>10, :page => params[:page] )
  end

end
