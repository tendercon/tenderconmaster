# config valid only for current version of Capistrano
lock "3.7.2"

set :application, 'tendercon_v1'
set :repo_url, 'git@github.com:tendercon/tenderconmaster.git' # Edit this to match your repository
set :branch, :master
set :deploy_to, '/home/deploy/tendercon_v1'
set :pty, true
set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :keep_releases, 5
set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.2.3' # Edit this if you are using MRI Ruby

set :deploy_via, :remote_cache
set :copy_compression, :bz2
set :git_shallow_clone, 1
set :scm_verbose, true


set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 8]
set :puma_workers, 0
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, false
set :assets_roles, [:web, :app]





# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5





namespace :deploy do
  # task :start, :roles => :app, :except => { :no_release => true } do
  #   # not need to restart nginx every time
  #   # run "service nginx start"
  #   run "cd #{release_path} && touch tmp/restart.txt"
  # end

  # after "deploy:start", "deploy:cleanup"
  # after 'deploy:cleanup', 'deploy:symlink_config'

  # You do not need reload nginx every time, eventhought if you use passenger or unicorn
  # task :stop, :roles => :app, :except => { :no_release => true } do
  #   run "service nginx stop"
  # end

  # task :graceful_stop, :roles => :app, :except => { :no_release => true } do
  #   run "service nginx stop"
  # end

  # task :reload, :roles => :app, :except => { :no_release => true } do
  #   run "cd #{release_path} && touch tmp/restart.txt"
  #   run "service nginx restart"
  # end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{release_path} && touch tmp/restart.txt"
  end

  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end

  # If you enable assets/deploy in Capfile, you do not need this
  # task :pipeline_precompile do
  #   # run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  #   # precompile assets before deploy and upload them to server
  #   # run_locally("RAILS_ENV=#{rails_env} rake assets:clean && RAILS_ENV=#{rails_env} rake assets:precompile")
  #   # top.upload "public/assets", "#{release_path}/public/assets", :via =>:scp, :recursive => true
  # end
end

# you do not need to this, because you already add require 'bundler/capistrano'
# before "deploy:assets:precompile", "bundle:install"
