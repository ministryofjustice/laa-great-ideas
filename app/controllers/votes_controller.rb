# frozen_string_literal: true

class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vote, only: %i[destroy]
  before_action :set_idea, only: %i[create destroy]

  def create
    redirect_to @idea, notice: 'You can only vote on approved ideas.' unless @idea.approved_by_admin?
    return if performed?

    @vote = @idea.votes.build
    @vote.user = current_user
    @vote.save
    redirect_to @idea
  end

  def destroy
    redirect_to @idea, notice: 'You can only delete your own votes' unless @vote.user_id == current_user.id
    return if performed?

    @vote.destroy
    redirect_to @idea
  end

  def set_vote
    @vote = Vote.find(params[:id] || params[:vote_id])
  end

  def set_idea
    @idea = Idea.find(params[:idea_id])
  end
end
