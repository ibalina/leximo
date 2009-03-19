class SessionsController < ApplicationController
  layout 'application'
  before_filter :login_required, :only => :destroy
  before_filter :not_logged_in_required, :only => [:new, :create]
      
  # render new.rhtml
  def new
  end
     
  def create
    if using_open_id?
      open_id_authentication(params[:openid_url])
    else  
      password_authentication(params[:login], params[:password])
    end  
  end

  def tag_cloud 
	  @tags = Word.tag_counts(:limit => 20, :order => 'id desc') # returns all the tags used 
  end
    
  def destroy
    self.current_user.forget_me if logged_in?
	    cookies.delete :auth_token
	    reset_session
	    expire_fragment(:controller => 'words', :action => 'index')
	    expire_fragment(:controller => 'words', :action => 'recent')
	    expire_fragment(:controller => 'words',:action => 'show')
	    flash[:notice] = "You have been logged out."
	    redirect_to login_path
	    #redirect_back_or_default('/')
   end
     
   protected
   
   def open_id_authentication(openid_url)
     authenticate_with_open_id(openid_url, :required => [:nickname, :email]) do |result, identity_url, registration|
     if result.successful?
       @user = User.find_or_initialize_by_identity_url(identity_url)
       if @user.new_record?
		     @user.login = registration['nickname']  unless registration['nickname'].blank?
         @user.email = registration['email'] unless registration['email'].blank?
  	     if @user.login && @user.email
			    create_open_id_user(@user)
         else
			     flash[:error] = "Your OpenID identity was verified, but it doesn't include all the information
           this site needs. Please fill in the blanks and we'll finish creating your account."
		       render :template => 'users/new'
         end
       else
         if @user.activated_at.blank?  
           failed_login("Your account is not active, please check your email for the activation code.")
         elsif @user.enabled == false
           failed_login("Your account has been disabled.")
         else
           self.current_user = @user
           successful_login
         end        
       end
       else
         failed_login result.message
       end
     end
   end
     
   def create_open_id_user(user)
     begin
       user.save!
       flash[:notice] = "Thanks for signing up! Please check your email to activate your account before logging in."
       redirect_to login_path
     rescue ActiveRecord::RecordInvalid
       flash[:error] = "Someone has signed up with that nickname or email address. Please create
                                another persona for Leximo."
       render :action => 'new'
     end  
   end    
    
   def password_authentication(login, password)
     user = User.authenticate(login, password)
     if user == nil
       failed_login("Your username or password is incorrect.")
     elsif user.activated_at.blank?  
       failed_login("Your account is not active, please check your email for the activation code.")
     elsif user.enabled == false
       failed_login("Your account has been disabled.")
     else
       self.current_user = user
       successful_login
     end
   end
     
   private
     
   def failed_login(message)
     flash.now[:error] = message
     render :action => 'new'
   end
     
   def successful_login
     if params[:remember_me] == "1"
       self.current_user.remember_me
       cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
     end
     flash[:notice] = "Logged in successfully"
     return_to = session[:return_to]
     if return_to.nil?
       redirect_to new_word_path #user_path(self.current_user)
     else
       redirect_to return_to
     end
     expire_fragment(:controller => 'words', :action => 'index')
     expire_fragment(:controller => 'words', :action => 'recent')
  	 expire_fragment(:controller => 'words')
   end
   
end
