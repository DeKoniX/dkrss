class IndexController < ApplicationController
  def index
    if user_signed_in?
      if current_user.rsskey.nil?
        current_user.rsskey = Digest::SHA1.hexdigest "@{Time.now} #{current_user.email}"
        current_user.save!
      end
      @feeds = current_user.feeds.paginate(page: params[:page], order: "date DESC", per_page: 10)
      if @feeds == []
        redirect_to sites_path
      end
    end
  end
end
