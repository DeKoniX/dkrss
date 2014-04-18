xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "RSS DK Agr"
    xml.description "Your rss list"
    xml.link root_path

    for feed in @feeds
      site = Site.find feed.site_id
      xml.item do
        xml.title feed.title
        xml.description feed.description
        xml.pubDate feed.date.to_s(:rfc822)
        xml.link site_feed_url(site, feed)
      end
    end
  end
end
