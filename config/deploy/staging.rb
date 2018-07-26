set :stage, :staging

server 'vagrant', user: 'vagrant', roles: :app

set :rails_env, :production
set :local_user, 'vagrant'
