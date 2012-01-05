class TeamMembershipsController < ApplicationController
  load_and_authorize_resource

  def create
    @team_membership = TeamMembership.new(
      params[:team_membership].merge(role: 'member')
    )

    if @team_membership.save
      redirect_to :back, notice: "#{@team_membership.member.name} was successfully added to the roster!"
    else
      flash[:error] = "#{@team_membership.member.name} could not be added."
      redirect_to :back
    end
  end

  def update
    if @team_membership.update_attributes(params[:team_membership])
      flash[:success] = "Member attributes were successfully updated!"
      redirect_to :back
    else
      flash[:error] = "Something went wrong."
      redirect_to :back
    end
  end

  def destroy
    TeamMembership.find(params[:id]).destroy
    flash[:success] = "User was successfully removed!"
    redirect_to :back
  end

end