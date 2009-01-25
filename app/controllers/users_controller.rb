    class UsersController < ApplicationController
      layout 'application'
      before_filter :not_logged_in_required, :only => [:new, :create] 
      before_filter :login_required, :only => [:show, :edit, :update]
      before_filter :check_administrator_role, :only => [:index, :destroy, :enable]
      
      def index
        @users = User.paginate(:page => params[:page], :per_page => 100, :order => 'id DESC')
      end
     
     #This show action only allows users to view their own profile
     def show
       #@user = current_user
	   @user = User.find_by_login(params[:id])
	   @words_submitted = @user.words.paginate(:all,
			:limit => 20, :order => 'words.id DESC', :per_page =>10, :page => params[:page])
#	   @words_voted_on  = @user.words_voted_on.find(:all,
#			:limit => 6, :order => 'votes.id DESC')	   
     end

  def tag_cloud 
	@tags = Word.tag_counts(:limit => 12, :order => 'count desc') # returns all the tags used 
  end
       
     # render new.rhtml
     def new
       @user = User.new
     end

	def create
		@user = User.new(params[:user])
		if verify_recaptcha && @user.errors.empty? && @user.save
			
			flash[:notice] = "Thanks for signing up! Check your email to activate your account."
			redirect_to login_path
		else
			flash[:error] = "There was a problem creating your account."
			render :action => 'new'
		end
	end
  
	
     def edit
       @user = current_user
     end
     
     def update
       @user = current_user
	     @user.photo = params[:user][:photo] 
	     if @user.update_attributes(:name  => params[:user][:name], :location => params[:user][:location], :web => params[:user][:web],
					:bio  => params[:user][:bio])
	       flash[:notice] = "Profile updated"
	       redirect_to :action => 'edit', :id => current_user
	     else
	       render :action => 'edit'
	     end

     end
     
     def destroy
       @user = User.find_by_login(params[:id])
       if @user.update_attribute(:enabled, false)
         flash[:notice] = "User disabled"
       else
         flash[:error] = "There was a problem disabling this user."
       end
       redirect_to :action => 'index'
     end
    
     def enable
       @user = User.find_by_login(params[:id])
       if @user.update_attribute(:enabled, true)
         flash[:notice] = "User enabled"
       else
         flash[:error] = "There was a problem enabling this user."
       end
         redirect_to :action => 'index'
     end
   end
