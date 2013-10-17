class SitesController < InheritedResources::Base
  http_basic_authenticate_with name: "admin", password: "qaz12345", except: :index

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
