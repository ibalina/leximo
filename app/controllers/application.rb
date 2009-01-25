# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :tag_cloud

  include AuthenticatedSystem
  # don't show passwords in logs
  filter_parameter_logging 'password'


  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'afe76908822b45fd48062836e82f84bd'

end
