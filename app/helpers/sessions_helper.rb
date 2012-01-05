module SessionsHelper
  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signup_path, :notice => "You must be logged in to do that"
  end

  def store_location
    puts session[:return_to] = request.fullpath
  end

  def clear_return_to
    session[:return_to] = nil
  end

  def redirect_back_or(default)
    if session[:return_to]
      redirect_to session[:return_to]
    else
      redirect_to default
    end

    clear_return_to
  end

  def authenticate_admin
    redirect_to root_path unless current_user && current_user.admin?
  end

  def approved_user
    redirect_to user_path(current_user) if current_user.id.to_s != params[:id] && !current_user.admin?
  end

  def correct_user
    redirect_to current_user User.find_by_id(params[:id]) == current_user
  end

  def current_user
    @current_user || user_from_remember_token
  end

  def signed_in?
    !current_user.nil?
  end
  alias :logged_in? :signed_in?

  def not_logged_in
    redirect_to user_path(current_user) unless !logged_in?
  end

  def sign_in user
    session[:remember_token_id] = user.id
    session[:remember_token_salt] = user.salt
    self.current_user = user
  end

  def sign_out
    session[:remember_token_id], session[:remember_token_salt] = nil
  end

  def current_user= (user)
    @current_user = user
  end

  def current_user?(user)
    user == current_user
  end

  private

    def user_from_remember_token
      user = User.authenticate_with_salt(*remember_token)
      current_user = user
    end

    def remember_token
      [(session[:remember_token_id] || nil),(session[:remember_token_salt] || nil)]
    end
end

