class SitesController < InheritedResources::Base
  def index
    @sites = current_user.sites
  end

  def create
    create! { sites_path }
    @site.user_id = current_user.id
    @site.save!
  end

  def edit
    @site = Site.find(params[:id])
    unless @site.user_id == current_user.id
      redirect_to sites_path
    end
  end

  def update
    update! { sites_path }
    @site.user_id = current_user.id
    @site.save!
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
