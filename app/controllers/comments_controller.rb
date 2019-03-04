# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: %i[show edit update destroy]
  before_action :set_idea, only: %i[new create show edit update destroy]

  # GET /comments
  def index
    @comments = Comment.includes(:user).where('idea_id = ?', params[:idea_id])
  end

  def show; end

  def new
    authorize @idea, policy_class: CommentPolicy
    @comment = @idea.comments.build
  end

  def edit; end

  def update
    authorize @comment

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
    authorize @idea, policy_class: CommentPolicy

    create_comment
    return if performed?

    redirect_to idea_comment_path(@comment.idea, @comment), notice: 'Comment created'
  end

  private

  def create_comment
    @comment = @idea.comments.build(comment_params)
    @comment.status_at_comment_time = Comment.status_at_comment_times[@idea.status.to_sym]
    @comment.user = current_user
    render :new unless @comment.save
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
