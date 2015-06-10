every 15.minute do
  runner 'RssFeed.perform_async()'
end
