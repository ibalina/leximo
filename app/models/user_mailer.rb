class UserMailer < ActionMailer::Base

  NUMBER_OF_ACCOUNTS = 200
  START = 1

  ActionMailer::Base.smtp_settings = {
	:address => "smtp.gmail.com",
	:port => 587,
	:user_name => "info@leximo.org",
	:password => "leximo88",
	:authentication => :login
  }

  def set_defaults(email_address, sent_at=Time.now)
    set_smtp_settings
    @from    = %{"Leximo Support" <#{ActionMailer::Base.smtp_settings[:user_name]}>}
    @sent_on = sent_at
    @headers = {}
    @recipients = email_address
  end

  def set_smtp_settings(email_type)
    number = rand(NUMBER_OF_ACCOUNTS + 1).floor + START
    ActionMailer::Base.smtp_settings[:user_name] = "leximo-mailer#{number}@leximo.org"
    ActionMailer::Base.smtp_settings[:password]  = password_algorithm || password[:hash]
  end

  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your account'
  
    @body[:url]  = "http://leximo.org/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://leximo.org/"
  end
  
  def forgot_password(user)
    setup_email(user)
    @subject    += 'You have requested to change your Leximo password'
    @body[:url]  = "http://leximo.org/reset_password/#{user.password_reset_code}"
  end
  
  def reset_password(user)
    setup_email(user)
    @subject    += 'Your password has been reset.'
  end

  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = %{"Leximo Support" <#{ActionMailer::Base.smtp_settings[:user_name]}>}
      @subject     = "Leximo - "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
