class TagsController < ApplicationController
  def index
    tags = ActsAsTaggableOn::Tag.all.to_a
    data = tags.map do |tag|
      { :text => tag.name,
        :weight => tag.taggings_count,
        :link => URI.decode(tag_path(tag)) }
    end
    respond_to do |format|
      format.json { render json: data.to_json }
    end
  end

  def current
    data = { :all_tags => ActsAsTaggableOn::Tag.all.map{ |tag| tag.name } }
    data[:site_tags] = Site.find(params[:site_id]).tag_list if params[:site_id]
    respond_to do |format|
      format.json { render json: data.to_json }
    end
  end

  def show
    @tag_name = ActsAsTaggableOn::Tag.find(params[:id]).name
    @sites = Site.tagged_with @tag_name
  end
end
