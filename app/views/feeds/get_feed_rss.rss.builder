xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "RSS DK #{@site.name}"
    xml.description "RSS list #{@site.name}"
    xml.link site_feeds_path(@site)

    @feeds.each do |feed|
      xml.item do
        xml.title feed.title
        xml.description feed.description
        xml.pubDate feed.date.to_s(:rfc822)
        xml.link site_feed_url(@site, feed)
      end
    end
  end
end
