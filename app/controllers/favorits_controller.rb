class FavoritsController < InheritedResources::Base
  def index
    @favorits = current_user.favorits
  end

  def create
    create! { favorits_path }
    @favorit.user_id = current_user.id
    @favorit.save!
  end

  def permitted_params
      params.permit(:favorit => [:name, :url, :description, :link])
  end
end
