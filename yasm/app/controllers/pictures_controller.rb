class PicturesController < ApplicationController
  before_action :set_user

  def index
    @pictures = @user.pictures.all.to_a
  end

  def create
    @picture = @user.pictures.create(:public_id => params[:public_id])
  end

  def update
    Picture.update(@user, params)
  end

  def destroy
    @picture = @user.pictures.find(params[:id])
    @picture.destroy
    redirect_to user_pictures_path
  end

  private
  def set_user
    @user = User.find(params[:user_id])
  end
end
