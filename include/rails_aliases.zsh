# vim: set filetype=bash

alias RP="   RAILS_ENV=production"
alias RS="   RAILS_ENV=staging"
alias RT="   RAILS_ENV=test"
alias b="    bundle"
alias rs="   rails s"
alias rc="   rails c"
alias rdc="  DATABASE_HOST=127.0.0.1 DATABASE_USERNAME=postgres DATABASE_PASSWORD=password DATABASE_NAME=light-tracker-api_postgres"
alias rcd="  railsd && rails c"
alias rr="   bake routes"
alias bake=" bundle exec rake"
alias rgm="  rails g migration "
alias rdbm=" rails db:migrate"
alias rdbc=" rails db:create"
alias rdbr=" rails db:rollback"
alias rdbs=" rails db:seed"
alias rdbR=" rails db:drop db:create db:migrate"
alias fixdb="rails db:drop db:create db:migrate db:seed"
alias adubs="bundle exec rspec; rubocop ."
alias cop="  rubocop"

alias saxo_m="bundle exec rake saxotech_importer_engine:install:migrations"

