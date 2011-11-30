class HomeController < ApplicationController
  def index
    @users = User.all
    
    if user_signed_in?
      @feed_items = current_user.feed
      @update = Update.new
    end
  end
end
