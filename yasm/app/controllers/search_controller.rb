require "cgi"

class SearchController < ApplicationController

  HIGHLIGHTS = {
    "Site" => [:title, :description],
    "Page" => [:title, :text],
    "Comment" => :comment
  }

  def search
    params["classes"] ||= ["Site", "Page", "Comment"]
    set_params
    @search = Sunspot.search @classes do
      fulltext params[:query] do
        highlight *@highlights
      end        
    end
    @markdown = Redcarpet::Markdown.new Redcarpet::Render::HTML.new
    respond_to do |format|
      format.js
      format.html
    end
  end

  def set_params
    @classes = params["classes"].map { |name| Object.const_get name }.compact
    @highlights = params["classes"].map { |name| HIGHLIGHTS[name] }.flatten.uniq
  end
end
