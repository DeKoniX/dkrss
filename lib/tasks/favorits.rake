namespace :favorits do
  desc "Insert table favorit"
  task go: :environment do
    #Favorit.all.each do |favorit|
    Favorit.where("link = ?", false).each do |favorit|
      p favorit.name
      p favorit.url
      p '######'
      unless favorit.body
        go_body(favorit)
        go_img(favorit)
        go_name(favorit)
      end
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

  desc "Return favorits img"
  task return: :environment do
    require './lib/feed_parse/parse'
    include FeedParse

    Favorit.all.each do |favorit|
      begin
        go_body(favorit)
        go_img(favorit)
      rescue
        puts "ERR: #{favorit.id}, #{favorit.name}"
      end
    end
  end

end
