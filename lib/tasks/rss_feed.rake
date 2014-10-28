namespace :rss_feed do
  desc "Insert table rss"
  task go: :environment do
    #Site.create! name: 'Lifehacker.ru', url: 'http://lifehacker.ru/feed/'
    ####
    require 'open-uri'
    puts "#{Time.now}"
    Site.all.each do |site|
      prop = false
      p site.name
      p site.url
      p '######'
      begin
        rss = SimpleRSS.parse open(site.url)
      rescue
        puts "ERR, #{Time.now}, #{site.name}, #{site.url}"
        prop = true
      end
      if !prop
        rss.items.each do |item|
          if find_item(item, site)
            p item.title.force_encoding("UTF-8")
            p item.link.force_encoding("UTF-8")
            title = HTMLEntities.new.decode item.title.force_encoding("UTF-8")
            description = HTMLEntities.new.decode item.description.force_encoding("UTF-8")
            if item.updated
              date = item.updated
            elsif item.pubDate
              date = item.pubDate
            end
            p date
            feed = site.feeds.create! title: title, url: item.link, description: description, date: date
            go_body(feed)
            go_img(feed)
          end
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
        url = i.attributes['src'].value
      else
        url = image.value
      end
      begin
        save_image = feed.feed_images.create! image: open(url)
      rescue
        p 'ASD'
      else
        url = save_image.image.url
        i.attributes['src'].value = url
      end
    end
    feed.body = doc.to_html
    feed.save!
  end

  def go_body(feed)
    require 'open-uri'
    f = ['article', 'div#content', 'div.content', 'div.yab-article']
    unless feed.body
      feed.body = ''
      doc = open(feed.url, "User-Agent" => 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:25.0) Gecko/20100101 Firefox/25.0')
      doc = doc.read
      doc.encode('utf-8')
      doc = Nokogiri::HTML doc
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
