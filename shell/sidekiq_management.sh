#!/bin/sh

cd $RAILS_ROOT

/usr/bin/env kill -0 $( cat /var/www/railsapps/track_status/shared/tmp/pids/sidekiq.pid )
~/.rvm/bin/rvm default do bundle exec sidekiqctl stop /var/www/railsapps/track_status/shared/tmp/pids/sidekiq.pid 10
~/.rvm/bin/rvm default do bundle exec sidekiq --index 0 --pidfile /var/www/railsapps/track_status/shared/tmp/pids/sidekiq.pid --environment production --logfile /var/www/railsapps/track_status/shared/log/sidekiq.log --queue scrapers --queue twitter_channel_posts --daemon
