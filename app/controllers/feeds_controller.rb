class FeedsController < InheritedResources::Base
  belongs_to :site
  def index
    @site = Site.find(params[:site_id])
    #index!
    @feeds = @site.feeds.paginate(:page => params[:page], :order => "date DESC", :per_page => 10)
    #@feeds = @site.feeds.order('created_at DESC').page(params[:page])
  end
  def add_favorit
    @feed = Feed.find(params[:feed_id])
    @favorit = current_user.favorits.create! url: @feed.url, name: @feed.title, body: @feed.body, description: @feed.description
    redirect_to favorits_path
  end
  def show
    show!
    @site = Site.find(@feed.site_id)
  end
  def get_rss
    @user = User.find_by rsskey: params[:sha]

    @feeds = @user.feeds.all(:order => "created_at DESC", :limit => 60)

    respond_to do |format|
      format.rss { render :layout => false }
    end
  end
end
