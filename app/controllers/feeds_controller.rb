class FeedsController < ApplicationController
  belongs_to :site
  def index

    @site = Site.find(params[:site_id])
    #index!
    @feeds = @site.feeds.paginate(:page => params[:page], :order => "created_at DESC", :per_page => 3)
    #@feeds = @site.feeds.order('created_at DESC').page(params[:page])
  end
end
