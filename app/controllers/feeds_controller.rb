# coding: utf-8
class FeedsController < InheritedResources::Base
  belongs_to :site
  def index
    @site = Site.find(params[:site_id])
    @feeds = @site.feeds.paginate(:page => params[:page]).order("date DESC")
  end
  def add_favorit
    @feed = Feed.find(params[:feed_id])
    @favorit = current_user.favorits.create! url: @feed.url, name: @feed.title, body: @feed.body, description: @feed.description
    redirect_to :back, notice: "В избранное добавлена статья: #{@feed.title}"
    #TODO Сделать ссылку на статью
  end
  def show
    begin
      @feed = Feed.find params[:id]
      @site = Site.find(@feed.site_id)
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, notice: "Такой статьи не существует"
     end
  end
  def get_rss
    @user = User.find_by rsskey: params[:sha]

    @feeds = @user.feeds.all.order("created_at DESC").limit(60)

    respond_to do |format|
      format.rss { render :layout => false }
    end
  end
  def get_feed_rss
    @user = User.find_by rsskey: params[:sha]
    @site = Site.find(params[:site_id])

    @feeds = @site.feeds.all.order("created_at DESC").limit(60)

    respond_to do |format|
      format.rss { render layout: false }
    end
  end
end
