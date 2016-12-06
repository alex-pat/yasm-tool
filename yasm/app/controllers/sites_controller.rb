class SitesController < ApplicationController
  before_action :set_user, except: [:tagged, :home]

  def index
    @sites = @user.sites.all
  end
  
  def new
    @site = Site.new
  end

  def create
    if params[:site][:title] == ""
      redirect_to new_user_site_path(@user.id)
      return 
    end
    @site = @user.sites.new(site_params)
    Component.transaction do
        @site.save
        @user.try_add_site_achievement
        @page = @site.pages.create
    end
    redirect_to edit_user_site_page_path(@user.id, @site.id, @page)
  end

  def edit
    @site = @user.sites.find(params[:id]) 
  end

  def update
    @site = @user.sites.find(params[:id])
    Component.transaction do
      begin
        @site.update_attributes(site_params)
      rescue
        flash[:notice] = "Updating failed"
      else
        flash[:notice] = "Page updated succesfully"
      end
    end
    redirect_to user_site_path
  end

  def destroy
    @site = @user.sites.find(params[:id])
    @site.destroy
    redirect_to user_sites_path
  end

  def show
    @site = @user.sites.find(params[:id])
  end

  def rate
    @site = @user.sites.find(params[:site_id])
    @site.vote_by :voter => current_user, :vote_weight => params[:stars] unless current_user.voted_for? @site
    respond_to do |format|
      format.json { render json: (@site.weighted_score / @site.get_upvotes.size.to_f).round(1).to_json }
    end
  end

  def home
    @sites = Site.all.to_a
    @best_sites = get_top @sites, "rating"
    @users = User.all.to_a
    @commentators = get_top @users, "commentators_rating"
    @medalists = get_top @users, "medalists_rating"
    @creators = get_top @users, "creators_rating"
  end
  
  private
  def set_user
    @user = User.find(params[:user_id])
  end
  
  def site_params
    params.require(:site).permit(:title, :description, :logo, :theme, { :tag_list => [] } )
  end

  def get_top(toppers, criterion)
    top = toppers.find_all do |x|
      x.send(criterion).nonzero? && x.send(criterion).to_f.finite?
    end
    top = top.sort { |a,b| b.send(criterion) - a.send(criterion) }[0,10]
  end
end
