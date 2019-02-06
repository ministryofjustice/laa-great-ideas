# frozen_string_literal: true

class CommentsController < ApplicationController
  include CommentsHelper
  before_action :authenticate_user!
  before_action :set_comment, only: %i[show edit update destroy]
  before_action :set_idea, only: %i[new create show edit update destroy]

  # GET /comments
  def index
    @comments = Comment.includes(:user).where('idea_id = ?', params[:idea_id])
  end

  def show; end

  def new
    redirect_to @idea, notice: 'You cannot create a comment on this idea' unless user_can_comment?(@idea, current_user)
    return if performed?

    @comment = @idea.comments.build
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to idea_comment_path(@comment.idea, @comment), notice: 'Comment was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to ideas_url, notice: 'Comment was successfully destroyed.'
  end

  def create
    redirect_to @idea, notice: 'You cannot create a comment on this idea' unless user_can_comment?(@idea, current_user)
    return if performed?

    @comment = @idea.comments.build(comment_params)
    @comment.user = current_user
    render :new unless @comment.save
    return if performed?

    redirect_to idea_comment_path(@comment.idea, @comment), notice: 'Comment created'
  end

  def set_comment
    @comment = Comment.includes(:user).find(params[:id])
  end

  def set_idea
    @idea = Idea.includes(:votes).find(params[:idea_id])
  end

  def comment_params
    params.require(:comment).permit(
      :body
    )
  end
end
