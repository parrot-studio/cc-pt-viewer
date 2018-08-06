set :stage, :staging

server 'vagrant', user: 'vagrant', roles: :app

set :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :rails_env, :production
set :local_user, 'vagrant'
