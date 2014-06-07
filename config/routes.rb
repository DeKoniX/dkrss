Dkrss::Application.routes.draw do
  devise_for :users
  root 'index#index'
  resources :favorits
  get 'favorit/:sha' => "favorits#get_rss", :defaults => { :format => 'rss' }, as: "favorits_rss"
  get 'feeds/:sha' => "feeds#get_rss", :defaults => { :format => 'rss' }, as: "feeds_rss"
  post "favorit/add" => "feeds#add_favorit"
  resources :sites do
    resources :feeds
    get 'rss/:sha' => "feeds#get_feed_rss", :defaults => { :format => 'rss' }, as: "feed_rss"
  end
  get 'opml/:sha/rss.opml' => "sites#get_opml", :defaults => { :format => 'opml' }, as: 'sites_opml'
end
