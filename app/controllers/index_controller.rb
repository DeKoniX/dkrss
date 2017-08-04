class IndexController < ApplicationController
  def index
    set_meta_tags description: 'RSS client'
    set_meta_tags og: {
      title:    'DKRss',
      description: 'RSS client',
      url:      'https://rss.dekonix.ru'
    }
    if user_signed_in?
      if current_user.rsskey.nil?
        current_user.rsskey = Digest::SHA1.hexdigest "@{Time.now} #{current_user.email}"
        current_user.save!
      end
      if params[:q].nil?
        @feeds = current_user.feeds
      else
        @feeds = current_user.feeds.where('title LIKE ?', "%#{params[:q]}%")
      end
      @feeds = @feeds.paginate(page: params[:page]).order('date DESC')

      redirect_to sites_path if @feeds == []
    end
  end
end
