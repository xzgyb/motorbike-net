require 'bundler/setup'
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'    # for rvm support. (http://rvm.io)
require 'mina/puma'

set :domain, ENV['DEPLOY_DOMAIN']
set :deploy_to, ENV['DEPLOY_TO']
set :repository, 'https://github.com/xzgyb/motorbike-net.git'
set :branch, 'master'
set :user, ENV['DEPLOY_USER'] 
set :rails_env, 'production'

set :shared_paths, ['config/secrets.yml', 'config/database.yml', 'config/puma.rb', 'log', 'tmp/pids', 'tmp/sockets', 'public/uploads', 'public/docs']

task :environment do
  invoke :'rvm:use[ruby-2.2.3@default]'
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/tmp/sockets")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/sockets")

  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/tmp/pids")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/pids")

  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/public/uploads")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/public/uploads")

  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/public/docs")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/public/docs")

  queue! %[touch "#{deploy_to}/#{shared_path}/config/secrets.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/puma.rb"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml' , 'secrets.yml' and 'puma.rb'."]
end

task :docs => :environment do
  queue! %[cd "#{deploy_to}/current/docs/slate"]
  queue! %[bundle install]
  queue! %[bundle exec middleman build]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      invoke :'puma:restart'
    end
  end
end

