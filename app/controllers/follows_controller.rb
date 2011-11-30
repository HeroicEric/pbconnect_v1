class FollowsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @followers = @user.followers
  end

  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    redirect_to @user, success: "You are now following #{@user.name}."
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.stop_following(@user)
    redirect_to @user, notice: "You are no longer following #{@user.name}."
  end

  def following
    @user = User.find(params[:user_id])
    @following = @user.all_following
  end
end