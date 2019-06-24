# config valid for current version and patch releases of Capistrano
lock '~> 3.11.0'

set :application, 'ccpts'
set :repo_url, -> { ENV['REPO_URL'] }

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/www/ccpts'

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true
set :use_sudo, false

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'node_modules', 'public'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
set :local_user, -> { ENV['DEPLOY_USER'] }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# puma
set :puma_threads,    [1, 5]
set :puma_workers,    0
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log,  "#{release_path}/log/puma.error.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

# rbenv
set :rbenv_type, :system
set :rbenv_path, -> { "/home/#{fetch(:local_user)}/.rbenv" }
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, -> { "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec" }
set :rbenv_map_bins, %w[rake gem bundle ruby rails]

# rails
set :migration_role, :app
set :assets_roles, :app

# yarn
set :yarn_roles, :app
set :yarn_flags, '--prefer-offline --silent --no-progress --production'

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end
  before :start, :make_dirs
end

namespace :deploy do
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  namespace :arcana do
    desc 'Master import'
    task :import do
      on roles(:app) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, 'arcana:import'
          end
        end
      end
    end
  end

  desc 'Upload public files'
  task :upload_files do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute "mkdir #{shared_path}/public/images -p"
          public_path = "#{shared_path}/public"

          Dir.glob('./public/images/*').each do |f|
            upload! f, "#{public_path}/images"
          end
          Dir.glob('./public/*.{html,ico,txt}').each do |f|
            upload! f, public_path
          end
        end
      end
    end
  end

  after  :migrate, 'arcana:import'
end
