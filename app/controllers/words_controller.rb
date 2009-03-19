class WordsController < ApplicationController

  before_filter :login_required, :only => [:new, :create, :update, :destroy]

#  caches_page :index, :show

  cache_sweeper :word_sweeper, :only => [:create, :update, :destroy]

  def index
	  fetch_words 'votes_count >= 2'
  end

  def search
    @words = ThinkingSphinx::Search.search params[:search], :page => params[:page], :per_page => 10, :order => "votes_count DESC", :match_mode => :boolean
  end 

  def new
	  @word = Word.new
  end

  def create
	  @word = @current_user.words.build params[:word]
    if verify_recaptcha && @word.save
		  flash[:notice] = 'Word submission added. Tell the world using the share buttons below.'
		  redirect_to :action => 'show', :id => @word
  #		expire_fragment :action => 'index'
  #		expire_fragment :action => 'show'
	  else
		  render :action => 'new'
	  end
  end

  def update
    @word = Word.find(params[:id])
    if verify_recaptcha && @word.update_attributes(params[:word])
      flash[:notice] = 'Word was successfully updated.'
      redirect_to :action => 'show', :id => @word
    else
		  render :action => 'edit'
    end
  end

  def edit
    @word = Word.find(params[:id])
  end

  def show
	  unless read_fragment({:id => params[:id]})  # Add the id param to the cache naming
		  @word = Word.find(params[:id]) 
	  end
  end
  
  def recent
	  fetch_words 'votes_count < 2'
	  render :action => 'index'
  end

  def tag_cloud 
	  @tags = Word.tag_counts(:limit => 20, :order => 'count desc') # returns all the tags used 
  end
  
  protected
  
  def fetch_words(conditions)
	  unless read_fragment({:page => params[:page] || 1})  # Add the page param to the cache naming
	  	@words= Word.paginate(:page => params[:page], :per_page => 10,
	                          :order => 'id DESC',:conditions => conditions)
    end
  end
  
end
