# vim: set filetype=bash

alias RP="   RAILS_ENV=production"
alias RS="   RAILS_ENV=staging"
alias RT="   RAILS_ENV=test"
alias b="    bundle"
alias rs="   rails s"
alias rc="   rails c"
alias rr="   bake routes"
alias bake=" bundle exec rake"
alias rgm="  rails g migration "
alias rdbm=" rails db:migrate"
alias rdbc=" rails db:create"
alias rdbr=" rails db:rollback"
alias rdbs=" rails db:seed"
alias fudb=" rails db:drop db:create db:migrate"
alias fixdb="rails db:drop db:create db:migrate db:seed"
alias adubs="bundle exec rspec; rubocop ."
alias cop="  rubocop"

# Newsites
alias JRD=" RAILS_ENV=journal_dev"
alias JRS=" RAILS_ENV=journal_staging"
alias JRP=" RAILS_ENV=journal_production"
alias jrs=" JRD rails s -p 3001 -P 42342"

alias saxo_m="bundle exec rake saxotech_importer_engine:install:migrations"
