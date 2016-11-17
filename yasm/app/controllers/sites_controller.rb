class SitesController < ApplicationController
  before_action :set_user, except: [:tagged, :home]

  def index
    @sites = @user.sites.all
  end
  
  def new
    @site = Site.new
  end

  def create
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
    top_sites
    @users = User.all.to_a
    top_commetators
    top_medalists
    top_creators
  end
  
  private
  def set_user
    @user = User.find(params[:user_id])
  end
  
  def site_params
    params.require(:site).permit(:title, :description, :logo, :theme, { :tag_list => [] } )
  end

  def top_sites
    @best_sites = @sites.find_all { |x| x.get_upvotes.length != 0 }.sort do |a,b|
      b.weighted_score / b.get_upvotes.length.to_f - a.weighted_score / a.get_upvotes.length.to_f
    end
    @best_sites = @best_sites[0,10]
  end

  def top_commetators
    @commentators = @users.find_all { |x| x.comments.length != 0 }
    @commentators = @commentators.sort { |a,b| b.comments.length - a.comments.length }[0,10]
  end

  def top_medalists
    @medalists = @users.find_all { |x| x.badges.length != 0 }
    @medalists = @medalists.sort { |a,b| b.badges.length - a.badges.length }[0,10]
  end

  def top_creators
    @creators = @users.find_all { |x| x.sites.length != 0 }
    @creators = @creators.sort { |a,b| b.sites.length - a.sites.length }[0,10]
  end
end
