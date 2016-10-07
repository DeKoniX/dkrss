require './lib/feed_parse/parse'
class GetFavorit
  include Sidekiq::Worker
  include FeedParse

  sidekiq_options queue: 'favorits'
  sidekiq_options retry: false

  def perform(favorit_id)
    favorit = Favorit.find favorit_id
    unless favorit.body
      go_body(favorit)
      go_img(favorit)
      go_name(favorit)
    end
  end
end
