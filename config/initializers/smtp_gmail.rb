require "smtp_tls"

ActionMailer::Base.smtp_settings = {
	:address => "smtp.gmail.com",
	:port => 587,
	:user_name => "info@leximo.org",
	:password => "leximo88",
	:authentication => :plain
}
