# Require mina GIT module do clone repositories
require 'mina/git'

##
#
# Setting variables
#
set :stage,       ENV['stage']
set :branch,      ENV['branch']

set :term_mode,   :system
set :repository,  'git@github.com:raymonsanches/mina-environments.git'

##
#
# Validate stage variable
#
unless stage
  print 'You MUST specify stage option'
  exit
end

##
#
# Validate branch variable
#
unless branch
  print 'You MUST specify wich branch you want to deploy'
  exit
end

##
#
# Include environment specific file
#
require File.join(File.dirname(__FILE__), 'environments/' + stage)

# prepare enviroment
task :prepare_default do
    queue 'composer update --no-interaction --prefer-dist'
end

##
#
# Additional general configurations
#
#set :shared_paths, ['app/config/parameters.yml']

# Make de deployment
task :deploy => :environment do

  to :before_hook do
    # Run tasks on local directory before SSH connect
    invoke :'before_hook'
  end

  to :after_hook do
    # Execute any command on remote directory after build is finished
    invoke :'after_hook'
  end

  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.

    invoke :'git:clone'
    invoke :'prepare_default'
    invoke :'prepare_env'

    #invoke :'deploy:link_shared_paths'

    queue 'php app/console cache:clear --env=prod'
    queue 'php app/console doctrine:fixtures:load --no-interaction'

    invoke :'deploy:cleanup'
  end

end
