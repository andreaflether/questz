#!/usr/bin/env bash
# exit on error
set -o errexit

sudo apt-get install libldap2-dev
sudo apt-get install libidn11-dev
bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate