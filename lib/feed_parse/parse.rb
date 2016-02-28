module FeedParse

  def parse_rss(site)
    prop = false
    p site.name
    p site.url
    p '######'
    begin
      rss = SimpleRSS.parse open(site.url, "User-Agent" => 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:25.0) Gecko/20100101 Firefox/25.0')
    rescue
      puts "ERR, #{Time.now}, #{site.name}, #{site.url}"
      prop = true
    end
    if !prop
      rss.items.each do |item|
        if find_item(item, site)
          date = Time.now
          p item.title.force_encoding("UTF-8")
          p item.link.force_encoding("UTF-8")
          unless item.description == nil
            title = HTMLEntities.new.decode item.title.force_encoding("UTF-8")
          end
          unless item.description == nil
            description = HTMLEntities.new.decode item.description.force_encoding("UTF-8")
          end
          if item.updated
            date = item.updated
          elsif item.pubDate
            date = item.pubDate
          end
          feed = site.feeds.create! title: title, url: item.link, description: description, date: date
          begin
            go_body(feed)
            go_img(feed)
          rescue
            puts "ERR, #{Time.now}, #{site.name}, #{site.url}, #{item.title}, #{item.url}"
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
        url = i.attributes['src']
      else
        url = image.value
      end
      begin
        save_image = feed.feed_images.create! image: open(url, "User-Agent" => 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:25.0) Gecko/20100101 Firefox/25.0')
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

  def div_search(doc, name)
    length = 0
    body = ""
    div = doc.search name
    div.each do |d|
      if d.to_str.length > length
        body = d
        length = d.to_str.length
      end
    end

    return body
  end

  def delete_script(str)
    n = 0
    while (str=~/<script.*>/) != nil
      n += 1
      str = str.gsub( str[str=~/<script.*>/..(str=~/<\/script>/)+8], '' )
      break if n >= 1000
    end

    return str
  end

  def go_body(feed)
    require 'open-uri'
    require "addressable/uri"
    f = ['article', 'div#content', 'div.content', 'div.yab-article']
    unless feed.body
      feed.body = ''
      uri = Addressable::URI.parse(feed.url).normalize
      doc = open(uri, "User-Agent" => 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:25.0) Gecko/20100101 Firefox/25.0')
      doc = doc.read
      doc.force_encoding('utf-8')
      doc = Nokogiri::HTML doc

      body = div_search(doc, 'article')
      if body.to_s == ""
        body = div_search(doc, 'div')
      end
      body = delete_script(body.to_s)
      feed.body = body.to_s

      feed.save!
    end
  end

  def go_name(favorit)
    doc = open(favorit.url, "User-Agent" => 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:25.0) Gecko/20100101 Firefox/25.0')
    doc = doc.read
    doc.encode('utf-8')
    doc = Nokogiri::HTML doc
    if favorit.name == ''
      favorit.name = doc.css('title').children.to_s
      favorit.save!
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
