module FeedParse
  def parse_rss(site)
    # require 'rss'
    require 'feedjira'
    prop = false
    begin
      # rss = RSS::Parser.parse open(site.url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:25.0) Gecko/20100101 Firefox/25.0')
      # rss = SimpleRSS.parse open(site.url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:25.0) Gecko/20100101 Firefox/25.0')
      rss = Feedjira::Feed.fetch_and_parse site.url
    rescue
      puts "ERR, #{Time.current}, #{site.name}, #{site.url}"
      site.error = true
      site.save!
      prop = true
    end
    unless prop
      if site.error == true
        site.error = false
        site.save!
      end
      rss.entries.each do |item|
        item_url = if item.entry_id.nil?
                     item.url
                   else
                     item.entry_id
                   end
        next unless find_item(item_url, site)
        feed = site.feeds.create!(title: item.title, url: item_url, description: item.summary, date: item.published)
        go_img(feed, false)
        GetFeed.perform_async(feed.id)
      end

      # rss.items.each do |item|
      #   next unless find_item(item, site)
      #   # date = Time.current
      #   # title = HTMLEntities.new.decode item.title.force_encoding('windows-1251')
      #   # unless item.description.nil?
      #   #   item.description = item.description.force_encoding('windows-1251')
      #   #   description = HTMLEntities.new.decode item.description.force_encoding('UTF-8')
      #   # end
      #   # if item.updated
      #   #   date = item.updated
      #   # elsif item.pubDate
      #   #   date = item.pubDate
      #   # end
      #   feed = site.feeds.create! title: item.title, url: item.link, description: item.description, date: item.date
      #   go_img(feed, false)
      #   GetFeed.perform_async(feed.id)
      # end
    end
  end

  def go_img(feed, body = true)
    require 'open-uri'
    doc = if body == true
            Nokogiri::HTML feed.body
          else
            Nokogiri::HTML feed.description
          end
    img = doc.search('img')
    img.each do |i|
      image = i.attributes['data-original']
      url = if image.nil?
              i.attributes['src']
            else
              image.value
            end
      begin
        save_image = feed.feed_images.create! image: open(url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:25.0) Gecko/20100101 Firefox/25.0')
      rescue
      else
        url = URI.join(APP_URL, save_image.image.url).to_s
        i.attributes['src'].value = url
        i.attributes['srcset'].remove if i.attributes['srcset']
      end
    end
    if body == true
      feed.body = doc.to_html
    else
      feed.description = doc.to_html
    end
    feed.save!
  end

  def div_search(doc, name)
    length = 0
    body = ''
    div = doc.search name
    div.each do |d|
      if d.to_str.length > length
        body = d
        length = d.to_str.length
      end
    end

    body
  end

  def delete_script(str)
    n = 0
    until (str =~ /<script.*>/).nil?
      n += 1
      str = str.gsub(str[str =~ /<script.*>/..(str =~ /<\/script>/) + 8], '')
      break if n >= 1000
    end

    str
  end

  def go_body(feed)
    require 'open-uri'
    require 'addressable/uri'
    # f = ['article', 'div#content', 'div.content', 'div.yab-article']
    unless feed.body
      feed.body = ''
      uri = Addressable::URI.parse(feed.url).normalize
      doc = open(uri, 'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:25.0) Gecko/20100101 Firefox/25.0')
      doc = doc.read
      doc.force_encoding('utf-8')
      doc = Nokogiri::HTML doc

      body = div_search(doc, 'article')
      body = div_search(doc, 'div') if body.to_s == ''
      body = delete_script(body.to_s)
      feed.body = body.to_s

      feed.save!
    end
  end

  def go_name(favorit)
    doc = open(favorit.url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:25.0) Gecko/20100101 Firefox/25.0')
    doc = doc.read
    doc.encode('utf-8')
    doc = Nokogiri::HTML doc
    if favorit.name == ''
      favorit.name = doc.css('title').children.to_s
      favorit.save!
    end
  end

  def find_item(url, site)
    return false if site.feeds.find_by url: url

    true
  end
end
