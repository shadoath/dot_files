# vim: set filetype=bash

#capistrano
alias csd=" cap staging deploy"
alias cpd=" date && cap production deploy && date"
alias cpdl="date && cap production deploy launch=true && date"
alias cpdL="cap production deploy:symlink:launch_release resque:stop deploy:restart_nginx deploy:cleanup"

# The-Journal
alias jcsd=" cap journal_staging deploy"
alias jcpd=" date && cap journal_production deploy && date"
alias jcpdl="date && cap journal_production deploy launch=true && date"
alias jcpdL="cap journal_production deploy:symlink:launch_release resque:stop deploy:restart_nginx deploy:cleanup"

