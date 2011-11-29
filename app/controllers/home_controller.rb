class HomeController < ApplicationController
  def index
    @users = User.all
    @update = current_user.updates.new
  end
end
