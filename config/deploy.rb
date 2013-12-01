require 'capistrano_colors'
require "rvm/capistrano"
require 'capistrano-unicorn'
require 'bundler/capistrano'

load "deploy/assets"

set :application, "rss"
set :rails_env, "production"
set :domain, "ruby@198.199.78.102:2525"
set :deploy_to, "/srv/#{application}"
set :use_sudo, false
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :scm, :git
set :repository,  "https://github.com/DeKoniX/dkrss.git"
set :branch, "master"
set :deploy_via, :remote_cache

set :rvm_ruby_string, 'ruby-2.0.0-p247@rss'

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

before 'deploy:setup', 'rvm:install_rvm', 'rvm:install_ruby'
after 'deploy:update_code', :roles => :app do
  run "rm -rf  #{current_release}/public"
  run "ln -s #{deploy_to}/shared/public/ #{current_release}/public"
  run "rm -f #{current_release}/config/database.yml"
  run "ln -s #{deploy_to}/shared/config/database.yml #{current_release}/config/database.yml"
end

after 'deploy:restart', 'unicorn:reload'    # app IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'   # app preloaded
after 'deploy:restart', 'unicorn:duplicate' # before_fork hook implemented (zero downtime deployments)

#namespace :deploy do
  #task :restart do
    #run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D; fi"
    ##run "sudo /etc/init.d/unicorn_#{application} restart"
  #end
  #task :start do
    #run "bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
    ##run "sudo /etc/init.d/unicorn_#{application} start"
  #end
  #task :stop do
    #run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
    ##run "sudo /etc/init.d/unicorn_#{application} stop"
  #end
#end
