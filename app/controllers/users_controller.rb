class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => :show

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @updates = @user.updates
  end

end
