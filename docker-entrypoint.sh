#!/bin/bash -e

# If running the rails server then create or migrate existing database
bundle exec rake db:prepare db:seed

exec "${@}"
