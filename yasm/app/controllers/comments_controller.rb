class CommentsController < ApplicationController
  before_action :set_user_and_site

  def create
    @comment = @site.comments.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      current_user.try_add_comment_achievement
      respond_to do |format|
        format.js
      end
    else
      redirect_to "/error.html"
    end
  end

  def destroy
    @comment = @site.comments.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.js
    end
  end

  private
  def set_user_and_site
    @user = User.find(params[:user_id])
    @site = Site.find(params[:site_id])
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
