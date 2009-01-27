class RolesController < ApplicationController
  layout 'application'
  before_filter :check_administrator_role

  def index
    @user = User.find_by_login(params[:user_id])
    @all_roles = Role.find(:all)
  end

  def tag_cloud 
	@tags = Word.tag_counts(:limit => 20, :order => 'count desc') # returns all the tags used 
  end

  def update
    @user = User.find(params[:user_id])
    @role = Role.find(params[:id])
    unless @user.has_role?(@role.name)
      @user.roles << @role
    end
    redirect_to user_roles_path(@user)
  end

  def destroy
    @user = User.find(params[:user_id])
    @role = Role.find(params[:id])
    if @user.has_role?(@role.name)
      @user.roles.delete(@role)
    end
    if @user == current_user
      redirect_to user_path(@user)
    else
      redirect_to user_roles_path(@user)
    end
  end

end
