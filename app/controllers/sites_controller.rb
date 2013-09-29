class SitesController < InheritedResources::Base
  def create
    create! { sites_path }
  end

  def edit
    edit! { sites_path }
  end

  def permitted_params
      params.permit(:site => [:name, :url])
  end
end
