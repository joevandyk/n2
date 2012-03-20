$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'deploy', 'recipes')

set :default_stage, "example_site"
set (:stages) { Dir.glob(File.join(File.dirname(__FILE__), "deploy", "*.rb")).map {|s| File.basename(s, ".rb") }.select {|s| not s =~ /sample/} }

require 'capistrano/ext/multistage'

Dir.glob(File.join(File.dirname(__FILE__), "deploy", "recipes", "*.rb")).sort.map {|s| File.basename(s, ".rb") }.each {|f| require f }

# :bundle_without must be above require 'bundler/capistrano'
set :bundle_without, [:development, :test, :cucumber]
require 'bundler/capistrano'

begin
  require 'new_relic/recipes'
rescue Exception => e
  # puts "Error could not load new_relic notifier: #{e}"
end

# Other default settings in config/deploy/recipes/application.rb
set (:deploy_to) { "/data/sites/#{application}" }
set :template_dir, "config/deploy/templates"
set :skin_dir, "/data/config/n2_sites"

after("deploy:symlink") do
  # setup shared files
  %w{/tmp/sockets /config/database.yml /config/unicorn.conf.rb
    /config/facebooker.yml /config/application_settings.yml /config/providers.yml
    /config/application.god /config/newrelic.yml /config/s3.yml
    /config/smtp.yml /config/resque_schedule.yml /config/menu.yml}.each do |file|
      run "ln -nfs #{shared_path}#{file} #{release_path}#{file}"
  end

  deploy.restore_previous_sitemap
  deploy.cleanup
end

before("deploy") do
  deploy.god.stop
end

before("deploy:stop") do
  deploy.god.stop
end

before("deploy:migrations") do
  deploy.god.stop
end

after("deploy") do
  deploy.god.start
end

after("deploy:migrations") do
  deploy.god.start
end

after("deploy:update_code") do
  unless exists?(:skip_post_deploy) and skip_post_deploy
    deploy.load_skin
    #deploy.server_post_deploy
    set :rake_post_path, release_path
    deploy.rake_post_deploy
  end
end

before("deploy:web:disable") do
  deploy.god.stop
end

after("deploy:web:enable") do
  deploy.god.start
end

after("deploy:setup") do
=begin
  if stage.to_s[0,3] == "n2_"
  	puts "Setting up default config files"
    run "mkdir -p #{shared_path}/config"
    #run "mkdir -p #{shared_path}/tmp/sockets"
    run "cp /data/defaults/config/* #{shared_path}/config/"
  end
=end
  run "mkdir -p #{shared_path}/tmp/sockets"
end

namespace :deploy do
  
  namespace :god do
    desc "Stop god monitoring"
    task :stop, :roles => [:app, :workers], :on_error => :continue do
      next if find_servers_for_task(current_task).empty?
      #run "god unmonitor #{application}"
      run "god unmonitor #{application}_workers"
    end

    desc "Start god monitoring"
    task :start, :roles => [:app, :workers] do
      next if find_servers_for_task(current_task).empty?
      run "god load #{current_path}/config/application.god"
      run "god monitor #{application}_workers"
    end

    desc "Status of god monitoring"
    task :status, :roles => [:app, :workers] do
      next if find_servers_for_task(current_task).empty?
      run "god status"
    end

    desc "Initialize god monitoring"
    task :init, :roles => [:app, :workers] do
      next if find_servers_for_task(current_task).empty?
      run "god"
    end
  end

  namespace :resque do
    desc "Restart Resque workers"
    task :restart_workers, :roles => :workers do
      run "cd #{release_path} && bundle exec rake n2:queue:stop_workers RAILS_ENV=#{rails_env}"
      run "cd #{release_path} && bundle exec rake n2:queue:stop_scheduler APP_NAME=#{application} RAILS_ENV=#{rails_env}"
    end

    desc "Stop Resque workers"
    task :stop_workers, :roles => :workers do
      # TODO:: switch this to god.stop_workers
      deploy.god.stop
      run "cd #{release_path} && bundle exec rake n2:queue:stop_workers RAILS_ENV=#{rails_env}"
      run "cd #{release_path} && bundle exec rake n2:queue:stop_scheduler APP_NAME=#{application} RAILS_ENV=#{rails_env}"
    end

    desc "Start Resque workers"
    task :start_workers, :roles => :workers do
      # TODO:: switch this to god.start_workers
      deploy.god.start
    end

    desc "Run the resque-web script for a given stage"
    task :resque_web, :roles => :app do
      run "cd #{current_path} && bundle exec resque-web -F -e #{rails_env} #{current_path}/config/initializers/resque.rb"
    end
  end

  desc "Restart application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    #run "cat #{current_path}/tmp/pids/unicorn.pid | xargs kill -USR2"
    #run "touch #{current_path}/tmp/restart.txt"
    deploy.stop
    deploy.start
  end

  desc "Start application"
  task :start, :roles => :app do
    #run "cd #{current_path} && bundle exec unicorn_rails -c #{current_path}/config/unicorn.conf.rb -E #{rails_env} -D"
    run "cd #{current_path} && bundle exec passenger start -d -e production -S #{current_path}/tmp/sockets/passenger.sock --pid-file #{current_path}/tmp/pids/passenger.pid"
    deploy.god.start
  end

  desc "Stop application"
  task :stop, :roles => :app do
    deploy.god.stop
    #run "cat #{current_path}/tmp/pids/unicorn.pid | xargs kill -QUIT"
    run "cd #{current_path} && bundle exec passenger stop --pid-file #{current_path}/tmp/pids/passenger.pid"
    run "cd #{current_path} && bundle exec rake n2:queue:stop_workers RAILS_ENV=#{rails_env}"
    run "cd #{current_path} && bundle exec rake n2:queue:stop_scheduler APP_NAME=#{application} RAILS_ENV=#{rails_env}"
  end

  desc "Cold bootstrap initial app, setup database and start server"
  task :cold_bootstrap do
    set :skip_post_deploy, true
    update
    run_mysql_locales_table_hack
    setup_app_server
    setup_worker_server
    deploy.god.init
    start
  end

  # This hack bootstraps the mysql database with the development schema
  # We have to do this right now because the locales plugin expects
  # there to be a locales table when rails loads, even if you're running
  # db:create. We run this to get around the chicken and egg problem.
  desc "Run mysql locales table hack (requried for initial bootstrap)"
  task :run_mysql_locales_table_hack, :roles => :app do
    run "cd #{current_path} && mysql -u #{db_user} -p#{db_password} #{db_name} < db/development_structure.sql"
  end

  desc "Fresh deploy and start (like cold but skip setup_db)"
  task :fresh do
    set :skip_post_deploy, true
    update
    deploy.god.init
    start
  end


  desc "Setup app server"
  task :setup_app_server, :roles => :app do
    run_rake "n2:setup"
  end

  desc "Setup worker server"
  task :setup_worker_server, :roles => :worker do
    #run_rake "n2:setup"
  end

  desc "Run rake after deploy tasks"
  task :rake_post_deploy, :roles => :app do
    path = rake_post_path || release_path
    #run "cd #{path} && bundle exec rake n2:deploy:after RAILS_ENV=#{rails_env}"
    run "cd #{path} && bundle exec rake assets:precompile"
  end

  desc "Run rake post upgrade after upgrade_newscloud"
  task :rake_post_upgrade, :roles => :app do
    path = rake_post_path || release_path
    run "cd #{path} && bundle exec rake n2:deploy:post_upgrade RAILS_ENV=#{rails_env}"
    run "cd #{path} && bundle exec rake i18n:populate:update_from_rails RAILS_ENV=#{rails_env}"
  end

  desc "Run server post deploy tasks to restart workers and reload god"
  task :server_post_deploy, :roles => :app do
    if roles[:workers].any?
      resque.restart_workers
    else
      run "cd #{release_path} && bundle exec rake n2:queue:restart_workers RAILS_ENV=#{rails_env}"
      run "cd #{release_path} && bundle exec rake n2:queue:restart_scheduler APP_NAME=#{application} RAILS_ENV=#{rails_env}"
    end
    deploy.god.start
    newrelic.notice_deployment
  end

  desc "Load the app skin if it exists"
  task :load_skin, :roles => :app do
    if skin_dir_exists? and skin_file_exists?
    	run "ln -nfs /data/config/n2_sites/#{application}/app/stylesheets/skin.sass #{release_path}/app/assets/stylesheets/skin.sass"
    	run "rm -r #{release_path}/app/assets/images/skin"
    	run "ln -nfs /data/config/n2_sites/#{application}/public/images/skin #{release_path}/app/assets/images/skin"
    end
  end

  desc "restore sitemap files in public after deploy"
  task :restore_previous_sitemap do
      run "if [ -e #{current_path}/public/sitemap_index.xml.gz ]; then cp #{current_path}/public/sitemap* #{release_path}/public/; fi"
  end

  desc "Upgrade to the latest stable version of newscloud"
  task :upgrade_newscloud do
    deploy.migrations
    deploy.rake_post_upgrade
    deploy.restart
  end

end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'vendor_bundle')
    release_dir = File.join(current_release, 'vendor', 'bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end
 
  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && bundle install --deployment --without test --without development --without cucumber"
  end
end

=begin
  Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
    $: << File.join(vendored_notifier, 'lib')
  end

  require 'hoptoad_notifier/capistrano'
rescue Exception => e
  # puts "Error could not load hoptoad notifier: #{e}"
=end
