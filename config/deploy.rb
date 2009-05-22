require 'mongrel_cluster/recipes'

set :application, "www.leximo.org"
set :user, "ibalina"
# Source code

default_run_options[:pty] = true
set :scm, :git
set :repository, "git@github.com:leximo/leximo.git"
set :branch, "master"
set :repository_cache, "git_cache"
set :ssh_options, { :forward_agent => true }

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

set :port, 30000

set :deploy_to, "/home/leximo/public/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion


role :app, application
role :web, application
role :db, application , :primary => true

set :runner, user
set :rails_env, "production"

# helps keep mongrel pid files clean
set :mongrel_clean, true


set :start_mongrel, "mongrel_rails cluster::start -C  #{current_path}/config/mongrel_cluster.yml"
set :stop_mongrel, "mongrel_rails cluster::stop -C  #{current_path}/config/mongrel_cluster.yml"
set :restart_mongrel, "mongrel_rails cluster::restart -C  #{current_path}/config/mongrel_cluster.yml"


namespace :deploy do

  desc "Stop mongrel"
  task :stop, :roles => :app do
    sudo stop_mongrel
  end

  desc "Restart mongrel"
  task :restart, :roles => :app do
    #sudo restart_mongrel
    stop
    restart_sphinx
    start
  end

  desc "Start mongrel"
  task :start, :roles => :app do
    sudo start_mongrel
  end

  desc "Cleanup older revisions"
  task :after_deploy do
    cleanup
  end

  desc "Re-establish symlinks"
  task :after_symlink do
    run <<-CMD
      rm -rf #{release_path}/db/sphinx && ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx
    CMD
  end

  desc "Stop the sphinx server"
  task :stop_sphinx , :roles => :app do
#    run "cd #{current_path} && rake thinking_sphinx:stop RAILS_ENV=production --trace"
  end

  desc "Restart server"
  task :restart_server, :roles => :app do
      sudo "reboot"
  end

  desc "Start the sphinx server" 
  task :start_sphinx, :roles => :app do
    run "cd #{current_path} && rake thinking_sphinx:start RAILS_ENV=production --trace"
  end

  desc "Restart the sphinx server"
  task :restart_sphinx, :roles => :app do
#    stop_sphinx
#    start_sphinx
  end  

  desc "Reload nginx"
  task :reload_nginx, :roles => :app do
    sudo "/etc/init.d/nginx stop"
    sudo "/etc/init.d/nginx start"
  end  

end

#after "deploy", "deploy:cleanup"
#after "deploy:migrations", "deploy:cleanup" 
after "deploy", "reload_nginx"
after "deploy", "start_sphinx"
after "deploy", "start"
after "deploy", "restart_server"
