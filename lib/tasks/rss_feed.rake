namespace :rss_feed do
  desc "Insert table rss"
  task go: :environment do
    Site.create! name: 'Lifehacker.ru', url: 'http://lifehacker.ru/feed/'
    ###
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
          go_img(feed)
        end
      end
    end
  end

  def go_img(feed)
    require 'open-uri'
    doc = Nokogiri::HTML feed.body
    img = doc.search('img')
    img.each do |i|
      image = i.attributes['data-original']
      if image == nil
        image = i.attributes['src'].value
      else
        image = image.value
      end
      begin
        save_image = feed.feed_images.create! image: open(image)
      rescue
        p 'ASD'
      else
        image = save_image.image.url
        im = i.attributes['data-original']
        if im == nil
          i.attributes['src'].value = image
        else
          i.attributes['data-original'].value = image
        end
      end
    end
    feed.body = doc.to_html
    feed.save!
  end

  def go_body(feed)
    require 'open-uri'
    f = ['article', 'div#content', 'div.content']
    unless feed.body
      feed.body = ''
      doc = Nokogiri::HTML open(feed.url)
      f.each do |fi|
        d = doc.search(fi)
        if d.to_s != ''
          feed.body = d.to_s
          break
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
