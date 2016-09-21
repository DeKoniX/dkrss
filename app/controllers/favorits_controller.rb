# coding: utf-8
class FavoritsController < InheritedResources::Base
  skip_before_filter :verify_authenticity_token, :only => [:add_favorit]
  def index
    if user_signed_in?
      @favorits = current_user.favorits.paginate(:page => params[:page]).order("updated_at DESC")
    else
      redirect_to new_user_session_path
    end
  end


  def show
    begin
      @favorit = Favorit.find params[:id]
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, notice: "Такой статьи не существует"
      # ToDO: Error page
    end
  end

  def create
    create!(:notice => "Создание избранной статьи")
    @favorit.user_id = current_user.id
    @favorit.save!
    GetFavorit.perform_async(@favorit.id)
  end

  def get_rss
    @user = User.find_by rsskey: params[:sha]

    @favorits = []
    @user.favorits.all.order("created_at DESC").limit(30).each do |favorit|
      unless favorit.body.nil?
        @favorits << favorit
      end
    end

    respond_to do |format|
      format.rss { render :layout => false }
    end
  end

  def add_favorit
    require 'open-uri'
    if user_signed_in?
      @url = URI::encode params[:url]
      @favorit = current_user.favorits.new url: @url, name: ''
      unless @favorit.save
        redirect_to root_path, notice: "Произошла ошибка при добавлении нового избранного"
      else
        GetFavorit.perform_async(@favorit.id)
      end
      
    else
      
      if params[:api_key]
        @user = User.find_by_rsskey params[:api_key]
        if @user
          @url = URI::encode params[:url]

          @favorit = @user.favorits.new url: @url, name: ''
          GetFavorit.perform_async(@favorit.id) if @favorit.save
          redirect_to root_path #TODO: возращает json ответ
        else
          redirect_to root_path #TODO: возращает json ответ
        end
        
      else
        redirect_to new_user_session_path
      end
    end
  end

  def permitted_params
      params.permit(:favorit => [:name, :url, :description])
  end
end
