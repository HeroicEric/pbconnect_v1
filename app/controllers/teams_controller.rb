class TeamsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  def index
    @teams = Team.all
  end

  def show
    @team = Team.find(params[:id])
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(params[:team])

    if @team.save
      RosterAddition.new(team: @team, member: current_user, role: "admin")
      redirect_to team_path(@team), notice: "Team #{@team.name} was created successfully!"
    else
      flash[:error] = "Something was wrong with your proposed team."
      redirect_to new_team_path
    end
  end

  def edit

  end

end