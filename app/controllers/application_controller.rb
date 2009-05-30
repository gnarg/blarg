# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  before_filter :get_recent_posts
  before_filter :get_all_tags

protected

  def get_recent_posts
    @recent_posts = Post.all.reverse
  end

  def get_all_tags
    @all_tags = Post.get_all_tags
  end
end
