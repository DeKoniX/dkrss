namespace :rss_feed do
  desc "Заполнение базы"
  task go: :environment do
    require 'open-uri'
    Site.all.each do |site|
      p site.name
      p site.url
      p '######'
      rss = SimpleRSS.parse open(site.url)
      rss.items.each do |item|
        if find_item(item, site)
          p item.title
          p item.link
          title = HTMLEntities.new.decode item.title
          description = HTMLEntities.new.decode item.description
          feed = site.feeds.create! title: title, url: item.link, description: description
          go_body(feed)
        end
      end
    end
  end

  def go_body(feed)
    require 'open-uri'
    unless feed.body
      feed.body = ''
      doc = Nokogiri::HTML open(feed.url)
      doc.search('div p').each do |p|
        if p.search('script').to_s == ''
          feed.body = feed.body + p.to_s
        end
      end
      feed.save!
    end
  end

  def find_item(item, site)
    site.feeds.all.each do |feed|
      if item.link == feed.url
        return false
      end
    end
    return true
  end
end
