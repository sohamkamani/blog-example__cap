# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'my_app'
set :branch, 'master'
set :user, 'john'
set :repo_url, 'http://github.com/john/myapp.git'
set :deploy_to, "/srv/#{fetch :application}"
set :linked_dirs, %w(node_modules)

namespace :deploy do
  desc 'Install node modules'
  after :updated, :install_node_modules do
    on roles(:app) do
      within release_path do
        execute :npm, 'install', '-s'
      end
    end
  end

  desc 'Restart server'
  after :finished, :restart do
    on roles(:app) do
      within release_path do
        execute 'echo Restarting your service now.'
        execute "cd #{release_path} && APP_NAME=\"#{fetch :application}\" npm run pm2"
        execute 'echo Deployer Successfully deployed this Application'
      end
    end
  end
end
