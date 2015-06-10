every 15.minute do
  runner 'RssFeed.perform_async()'
end

every 1.day, at: '4:30 am' do
  rake 'delete_old:delete'
end
