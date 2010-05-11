#!/bin/zsh
set -x
autoload zmv
for i in `cat ~/.filessvn`;do cp -R $i /Users/kevit/Projects/kevit-dotfiles/trunk/$i ; done
zmv -WCf '/Users/kevit/Projects/kevit-dotfiles/trunk/.*' '/Users/kevit/Projects/kevit-dotfiles/trunk/*'
mv /Users/kevit/Projects/kevit-dotfiles/trunk/.vim /Users/kevit/Projects/kevit-dotfiles/trunk/vim
mv /Users/kevit/Projects/kevit-dotfiles/trunk/.zsh /Users/kevit/Projects/kevit-dotfiles/trunk/zsh
