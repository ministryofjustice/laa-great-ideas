# frozen_string_literal: true

class IdeasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_idea, only: %i[show edit update destroy submit]

  # GET /ideas
  # GET /ideas.json
  def index
    @ideas = case params[:view]
             when 'assigned'
               Idea.where(assigned_user_id: [current_user.id])
             when 'submitted'
               Idea.where.not(submission_date: [nil, ''])
             else
               Idea.all
             end
  end

  # GET /ideas/1
  # GET /ideas/1.json
  def show
    @idea = Idea.includes(:comments).find(params[:id])
  end

  # GET /ideas/new
  def new
    @idea = Idea.new
  end

  # GET /ideas/1/edit
  def edit; end

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
    old_assigned_user_id = @idea.assigned_user_id
    if @idea.update(idea_params)
      send_assigned_user_email if @idea.assigned_user_id != old_assigned_user_id
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

  # Never trust parameters from the scary internet, only allow the white list through.
  def idea_params
    if current_user.admin?
      params.require(:idea).permit(
        :area_of_interest,
        :business_area,
        :it_system,
        :title,
        :idea,
        :benefits,
        :impact,
        :involvement,
        :assigned_user_id,
        :participation_level,
        :status,
        :review_date
      )
    else
      params.require(:idea).permit(
        :area_of_interest,
        :business_area,
        :it_system,
        :title,
        :idea,
        :benefits,
        :impact,
        :involvement,
        :status
      )
    end
  end

  def send_assigned_user_email
    template = '8c344764-890c-491c-9301-27cbd92a1c26'
    NotifyMailer.idea_email_template(@idea.assigned_user, @idea, template).deliver_now
  end
end
