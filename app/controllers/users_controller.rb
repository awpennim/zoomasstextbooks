class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :show]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :approved_user, :only => [:show, :destroy, :show]
  before_filter :authenticate_admin, :only => [:index]
  before_filter :not_logged_in, :only => [:new, :create]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find_by_id(params[:id])
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      sign_in @user
      redirect_to @user, :notice => 'User was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      sign_in @user
      redirect_to @user, :notice => 'Settings Updated!'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user.admin?
      redirect_to @user, :notice => "You can't delete an administrator!"
      return
    end

    id = @user.id
    @user.destroy

    if current_user.admin?
      redirect_to users_url, :notice => "You successfully destroyed the user, #{@user.username}, with ID: #{id}"
    else  
      sign_out
      redirect_to root_path, :notice => "#{@user.username}, you have successfully destroyed your account"
    end
  end

  def admin?
    admin
  end

  private

end
