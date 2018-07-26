set :stage, :production
set :rails_env, :production

server ENV['DEPLOY_SERVER'], user: ENV['DEPLOY_USER'], roles: :app

namespace :deploy do
  desc 'sitemap update and ping'
  task :sitemap do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'sitemap:refresh'
        end
      end
    end
  end

  after  :finishing, :sitemap
end
