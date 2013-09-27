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
        print find_item(item, site)
        if find_item(item, site)
          p item.title
          p item.link
          title = HTMLEntities.new.decode item.title
          description = HTMLEntities.new.decode item.description
          site.feeds.create! title: title, url: item.link, description: description
        end
      end
    end
  end

  desc "Получение body"
  task body: :environment do
    Feed.all.each do |feed|
      unless feed.body
        p feed.url

      end
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
