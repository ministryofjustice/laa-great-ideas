# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: %i[show edit update destroy]
  before_action :set_idea, only: %i[new create show edit update destroy]

  # GET /comments
  def index
    @comments = Comment.where('idea_id = ?', params[:idea_id])
  end

  def show; end

  def new
    if @idea.approved?
      @comment = @idea.comments.build
    else
      redirect_to @idea, notice: 'Comments can only be added to approved ideas.'
    end
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
    if @idea.approved?
      @comment = @idea.comments.build(comment_params)
      @comment.user = current_user
      if @comment.save
        redirect_to idea_comment_path(@comment.idea, @comment), notice: 'Comment created'
      else
        render :new
      end
    else
      redirect_to @idea, notice: 'Comments can only be added to approved ideas.'
    end
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_idea
    @idea = Idea.find(params[:idea_id])
  end

  def comment_params
    params.require(:comment).permit(
      :body
    )
  end
end
