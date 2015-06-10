require './lib/feed_parse/parse'
class GetFavorit

  include Sidekiq::Worker
  include FeedParse

  def perform(favorit_id)
    favorit = Favorit.find favorit_id
    unless favorit.body
      go_body(favorit)
      go_img(favorit)
      go_name(favorit)
    end
  end
end
