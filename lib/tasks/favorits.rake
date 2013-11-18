namespace :favorits do
  desc "Insert table favorit"
  task go: :environment do
    Favorit.all.each do |favorit|
      unless favorit.link
        p favorit.name
        p favorit.url
        p '######'
        unless favorit.body
          go_body(favorit)
          go_img(favorit)
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
    feed.description = feed.body[0..253]
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
end
