class UserMailer < ActionMailer::Base
  default :from => "no_reply@tradecampusbooks.com"

  def verify_notification(user, token)
    @user = user
    @token = token
    mail(:to => user.email, :subject => "Please activate your Trade Campus Books account")
  end

  def forgot_password_notification(user,token)
    @user = user
    @token = token
    mail(:to => user.email, :subject => "#{user.username}, Your New Password")
  end
end
