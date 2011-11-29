class UpdatesController < ApplicationController
  before_filter :authenticate_user!

  def create
    @update = current_user.updates.build(params[:update])

    if @update.save
      redirect_to root_path, notice: "Update shared successfully!"
    else
      redirect_to :back, error: "Something when wrong."
    end
  end

end
