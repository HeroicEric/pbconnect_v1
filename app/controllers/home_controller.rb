class HomeController < ApplicationController
  def index
    @users = User.all
    @updates = current_user.updates.new if current_user
  end
end
