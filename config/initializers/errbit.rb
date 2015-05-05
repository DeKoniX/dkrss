Airbrake.configure do |config|
  config.api_key = '33807282a306a229f7d9a1bffa9d7faa'
  config.host    = 'errbit.whitedoggy.ru'
  config.port    = 80
  config.secure  = config.port == 443
end
