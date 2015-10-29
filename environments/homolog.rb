##
#
# Server configuration
#
set :domain,            '127.0.0.1'
set :user,              'user'
set :port,              '22'
set :deploy_to,         '/var/www/deploy_to'

##
#
# Prepare environment
#
task :prepare_env do
  # update database
  queue "php app/console doctrine:schema:update --force"
  ###
end

## Before all (run locally)
task :before_hook do
end
## After all (run remote)
task :after_hook do
end
