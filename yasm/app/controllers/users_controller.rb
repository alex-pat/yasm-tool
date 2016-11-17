class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @sites = @user.sites.all.page(params[:page]).per_page(4)
  end
end
