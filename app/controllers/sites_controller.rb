class SitesController < ApplicationController
  def new
    @site = Site.new
  end

  def create
    @site = Site.create params[:site]
    if @site.valid?
      redirect_to root_url(:host => @site.domain)
    else
      render :new
    end
  end
end
