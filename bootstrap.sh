#!/bin/sh


#update_svn ()
#{
#}

set -x
update_mastercopy () 
{
tar cf $HOME/dotfiles.tar `cat $HOME/.filessvn`
}

deploy_mastercopy ()
{
scp $HOME/dotfiles.tar kevit.info:/var/www/kevit.info
exit
}

update_mastercopy
deploy_mastercopy
