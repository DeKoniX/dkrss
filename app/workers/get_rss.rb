require './lib/feed_parse/parse'
class GetRss
  include Sidekiq::Worker
  include FeedParse

  sidekiq_options queue: 'rss'
  sidekiq_options retry: false

  def perform(site_id)
    site = Site.find site_id
    parse_rss(site)
  end
end
