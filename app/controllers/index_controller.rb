class IndexController < ApplicationController
  def index
    if user_signed_in?
      @feeds = current_user.feeds.paginate(page: params[:page], order: "date DESC", per_page: 10)
      if @feeds == []
        redirect_to sites_path
      end
    end
  end
end
