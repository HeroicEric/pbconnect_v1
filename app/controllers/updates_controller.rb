class UpdatesController < ApplicationController
  before_filter :authenticate_user!

  def create
    @update = current_user.updates.build(params[:update])

    if @update.save
      redirect_to root_path, notice: "Update shared successfully!"
    else
      @feed_items = []
      flash[:error] = "Something was wrong with your update."
      redirect_to root_path
    end
  end

end
