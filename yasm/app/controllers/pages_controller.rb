# coding: utf-8
require "cgi"

class PagesController < ApplicationController
  before_action :set_user_and_site
  
  def index
    @pages = @site.pages.paginate(:page     => params[:page],
                                  :per_page => 5)
  end

  def new
    @page = @site.pages.new
  end

  def create
    Page.transaction do
      begin
        @page = @site.pages.create(:title => params["page"]["title"])
        @page.update_blocks params["components"], params["layout"]
        @page.update_attributes :layout => params["layout"]
      rescue
        flash[:notice] = "Creating failed"
      else
        flash[:notice] = "Page created successfully"
      end
    end
    redirect_to user_site_pages_path
  end
  
  def edit
    @page = @site.pages.find(params[:id])
    edit_tables
  end

  def update
    @page = @site.pages.find(params[:id])
    Page.transaction do
      begin
        @page.update_blocks params["components"], params["layout"]
        @page.update_attributes(:title => params["page"]["title"], :layout => params["layout"])
      rescue
        flash[:notice] = "Update failed"
      else
        flash[:notice] = "Saved successfully"
      end
    end
  end

  def destroy
    @page = @site.pages.find(params[:id])
    @page.destroy
    if @site.pages.empty?
      @site.destroy
      redirect_to users_path
    else
      redirect_to user_site_pages_path
    end
  end
  
  def show
    @page = @site.pages.find(params[:id])
    @markdown = Redcarpet::Markdown.new Redcarpet::Render::HTML.new
    show_tables
    render layout: "site_appearance"
  end

  private
  def set_user_and_site
    @user = User.find(params[:user_id])
    @site = @user.sites.find(params[:site_id])
  end

end
