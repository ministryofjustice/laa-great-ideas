# frozen_string_literal: true

class IdeasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_idea, only: %i[show edit update destroy submit]
  before_action :set_vote, only: %i[show]

  # GET /ideas
  # GET /ideas.json
  def index
    @ideas = Idea.all
  end

  # GET /ideas/1
  # GET /ideas/1.json
  def show
    @idea = Idea.includes(:comments).includes(:user).find(params[:id])
  end

  # GET /ideas/new
  def new
    @idea = Idea.new
  end

  # GET /ideas/1/edit
  def edit
    authorize @idea
  end

  # POST /ideas
  def create
    @idea = current_user.ideas.new(idea_params)
    if @idea.save
      redirect_to @idea, notice: 'Idea was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /ideas/1
  def update
    authorize @idea
    if @idea.update(idea_params)
      redirect_to @idea, notice: 'Idea was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /ideas/1
  def destroy
    @idea.destroy
    redirect_to ideas_url, notice: 'Idea was successfully destroyed.'
  end

  def submit
    @idea.submission_date = Time.now
    @idea.status = Idea.statuses[:awaiting_approval]
    if @idea.save
      redirect_to @idea, notice: 'Idea was successfully submitted.'
    else
      render :edit
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_idea
    @idea = Idea.find(params[:id] || params[:idea_id])
  end

  def set_vote
    @vote = @idea.votes.find_by(user: current_user)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def idea_params
    if current_user.admin?
      params.require(:idea).permit(
        :area_of_interest,
        :business_area,
        :it_system,
        :title,
        :idea,
        { benefit_list: [] },
        :impact,
        :involvement,
        :assigned_user_id,
        :participation_level,
        :status,
        :review_date,
        :review_year, :review_month, :review_day
      )
    else
      params.require(:idea).permit(
        :area_of_interest,
        :business_area,
        :it_system,
        :title,
        :idea,
        { benefit_list: [] },
        :impact,
        :involvement,
        :status
      )
    end
  end
end
