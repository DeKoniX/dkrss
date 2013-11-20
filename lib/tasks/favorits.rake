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
      end
    end
  end
end
