require 'bundler/setup'
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/puma'
require 'mina/chruby'

set :application_name, 'motorbike-net'
set :chruby_path, '/usr/local/share/chruby/chruby.sh'
set :domain, 'chemeilai.cn'
set :deploy_to, '/home/sunqp/motorbike-net'
set :repository, 'https://github.com/xzgyb/motorbike-net.git'
set :branch, 'master'
set :user, 'sunqp'
set :rails_env, 'production'

set :shared_dirs, fetch(:shared_dirs, []).push('log', 'tmp/pids', 'tmp/sockets', 'public/uploads', 'storage', 'public/docs')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/master.key', 'config/credentials.yml.enc', 'config/puma.rb')

task :remote_environment do
  invoke :chruby, 'ruby-2.7.1'
end

task :setup do
  run(:local) do
    command "scp config/database.deploy.yml #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:shared_path)}/config/database.yml"
    command "scp config/puma.deploy.rb #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:shared_path)}/config/puma.rb"
    command "scp config/master.key #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:shared_path)}/config/master.key"
    command "scp config/credentials.yml.enc #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:shared_path)}/config/credentials.yml.enc"
    command "scp config/application.yml #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:shared_path)}/config/application.yml"
  end
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    comment "Deploying #{fetch(:application_name)} to #{fetch(:domain)}:#{fetch(:deploy_to)}"
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      invoke :'puma:phased_restart'
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

task :docs => :environment do
  command "cd #{fetch(:deploy_to)}/current/docs"
  command 'bundle install'
  command 'bundle exec middleman build'
end
