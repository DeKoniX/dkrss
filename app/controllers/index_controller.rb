class IndexController < ApplicationController
  def index
    @feeds = Feed.paginate(page: params[:page], order: "date DESC", per_page: 10)
  end
end
