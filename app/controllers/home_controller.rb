class HomeController < ApplicationController
  def index
    @users = User.all

    if user_signed_in?
      @feed_items = current_user.feed.page(params[:page]).per(10)
      @update = Update.new
    end
  end
end
