class TeamMembershipsController < ApplicationController

  def create
    @team_membership = TeamMembership.new(
      params[:team_membership].merge(role: 'player')
    )

    if @team_membership.save
      redirect_to :back, notice: "#{@team_membership.member.name} was successfully added to the roster!"
    else
      flash[:error] = "#{@team_membership.member.name} could not be added."
      redirect_to :back
    end
  end

end