require './lib/feed_parse/parse'
class GetFeed
  include Sidekiq::Worker
  include FeedParse

  sidekiq_options queue: 'feeds'

  def perform(feed_id)
    feed = Feed.find feed_id
    # begin
      go_body(feed)
      go_img(feed)
    # rescue
    #   puts "ERR, #{Time.now}, #{feed.title}, #{feed.url}"
    # end
  end
end
