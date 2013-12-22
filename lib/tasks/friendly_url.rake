namespace :friendly_url do
  desc "Re seave all, generate friendly url"
  task go: :environment do
    Site.all.each do |s|
      s.save!
    end
    Feed.all.each do |f|
      f.save!
    end
    Favorit.all.each do |f|
      f.save!
    end
  end
end
