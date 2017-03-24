# config valid only for current version of Capistrano
lock "3.8.0"

set :application, 'stagingV1_tendercon'
# production
#set :repo_url, 'git@github.com:tendercon/tenderconmaster.git' # Edit this to match your repository

set :branch, :staging
set :repo_url, 'https://github.com/tendercon/tenderconmaster.git'
# production
#set :branch, :master
# master
#set :branch, :master
#set :deploy_to, '/home/deploy/tendercon_v1'
set :deploy_to, '/home/deploy/stagingV1_tendercon'
set :pty, true
set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :keep_releases, 5
set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.2.3' # Edit this if you are using MRI Ruby

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'staging'))
set :puma_threads, [0, 8]
set :puma_workers, 1
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, false
# for staging


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

#after 'deploy:publishing', 'deploy:seed'
# namespace :deploy do
#   def delayed_job_roles
#     fetch(:delayed_job_server_role, :app)
#   end
#
#   def args
#     fetch(:delayed_job_args, "")
#   end
#
#   desc "Start workers"
#   task :start_workers do
#     run "cd #{release_path} && RAILS_ENV=production script/delayed_job -n 2 start"
#   end
#
#   task :seed do
#     puts "\n=== Seeding Database ===\n"
#     on primary :db do
#       within current_path do
#         with rails_env: fetch(:rails_env) do
#           execute :bundle, :exec, :rake, 'db:seed'
#         end
#       end
#     end
#   end
#
#   task :migrate do
#     puts "\n=== MIGRATE Database ===\n"
#     on primary :db do
#       within current_path do
#         with rails_env: fetch(:rails_env) do
#           execute :bundle, :exec, :rake, 'db:migrate'
#         end
#       end
#     end
#   end
#
#
#   desc 'Start the delayed_job process'
#   task :start do
#     on roles(delayed_job_roles) do
#       within release_path do
#         with rails_env: fetch(:rails_env) do
#           puts "TEST"
#           execute :bundle, :exec, :'bin/delayed_job', args, :start
#         end
#       end
#     end
#   end
# end

Rake::Task["puma:restart"].clear_actions

namespace :puma do
  task :restart do
    on roles(:all) do
      execute "RACK_ENV=#{fetch(:rails_env)} #{fetch(:rvm_binary)} #{fetch(:rvm_ruby_version)} do pumactl -S #{shared_path}/tmp/pids/puma.state restart"
    end
  end
end