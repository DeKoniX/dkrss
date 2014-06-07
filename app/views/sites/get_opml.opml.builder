xml.instruct! :xml, :version => "1.0"
xml.opml(:version => 1.1) do
  xml.head do
    xml.title 'OPML TITLE'
  end
  xml.body do
    @sites.each do |site|
      url = site_feed_rss_url(site, @user.rsskey)
      title = site.name
      xml.outline({
        :type => 'rss',
        :version => 'RSS',
        :description => '',
        :title => title,
        :text => title,
        :htmlUrl => url,
        :xmlUrl => url
      })
    end
  end
end
