class FavoritsController < InheritedResources::Base
  def index
    @favorits = current_user.favorits.paginate(:page => params[:page], :order => "updated_at DESC", :per_page => 10)
  end

  def create
    create! { favorits_path }
    @favorit.user_id = current_user.id
    @favorit.save!
  end
  
  def get_rss
    @user = User.find_by rsskey: params[:sha]

    @favorits = []
    @user.favorits.all(:order => "created_at DESC", :limit => 30).each do |favorit|
      unless favorit.body.nil?
        @favorits << favorit
      end
    end

    respond_to do |format|
      format.rss { render :layout => false }
    end
  end

  def permitted_params
      params.permit(:favorit => [:name, :url, :description])
  end
end
