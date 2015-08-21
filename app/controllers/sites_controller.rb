# coding: utf-8
class SitesController < InheritedResources::Base
  def index
    @sites = current_user.sites
  end

  def delete
    delete!(:notice => "Удален rss поток #{@site.name}")
  end
  
  def create
    create!{ sites_path }
    @site.user_id = current_user.id
    @site.save!
    GetRss.perform_async(@site.id)
    flash[:notice] = "Добавлен новый rss поток #{@site.name}"
  end

  def edit
    @site = Site.find(params[:id])
    unless @site.user_id == current_user.id
      redirect_to sites_path
    end
  end

  def get_rss
    ids = []
    current_user.sites.each do |site|
      ids << site.id
    end
    RssFeed.perform_async(ids)
    redirect_to :back
  end

  def update
    update! { sites_path }
    @site.user_id = current_user.id
    @site.save!
    flash[:notice] = "Отредактирован rss поток #{@site.name}"
  end

  def get_opml
    @user = User.find_by rsskey: params[:sha]
    @sites = @user.sites

    respond_to do |format|
      format.opml { render :layout => false }
    end
  end

  def permitted_params
      params.permit(:site => [:name, :url])
  end
end
