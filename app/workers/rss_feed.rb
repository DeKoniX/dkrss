require './lib/feed_parse/parse'
class RssFeed
  include Sidekiq::Worker
  include FeedParse

  sidekiq_options queue: 'rss'

  def perform(sites = nil)
    if sites.nil?
      Site.all.each do |site|
        parse_rss(site)
      end
    else
      sites.each do |site_id|
        site = Site.find site_id
        parse_rss(site)
      end
    end
  end
end
