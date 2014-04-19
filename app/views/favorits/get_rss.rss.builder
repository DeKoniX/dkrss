xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "RSS DK Agr"
    xml.description "Your rss list"
    xml.link root_path

    for favorit in @favorits
      xml.item do
        xml.title favorit.name
        xml.description favorit.description
        xml.pubDate favorit.created_at.to_s(:rfc822)
        xml.link favorit_path(favorit)
      end
    end
  end
end
