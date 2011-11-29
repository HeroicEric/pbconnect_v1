class HomeController < ApplicationController
  def index
    @users = User.all
    @updates = current_user.updates.new if user_signed_in?
  end
end
