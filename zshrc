bindkey -v 
export PAGER=$HOME/bin/vimpager

autoload colors ; colors

function change_PS () {
PS1="%n@%m-%~ "
#screen)
if [[ $TERM = 'screen' ]] then
	PS1=$fg[yellow]screen:$fg[white]$PS1
fi
#ssh)
if [[ -n $SSH_CLIENT || -n $REMOTEHOST ]] then
	PS1="$fg[red]ssh:$fg[white]$PS1"
fi
#sudo)
if [[ -n $SUDO_USER ]] then
	PS1="$PS1$fg[red]# "
fi
#chrooted)

#jailed)

#root)
if [[ $USER = 'root' ]] then
	PS1="$PS1$fg[red]# $fg[white]"
fi

if [[ -d .svn ]]; then
fi

}

#autoattach screen
#if [[ $STY = '' ]] then screen -xR; fi

#%n - user
#%m - hostname
#%~ - path
export LANG="en_EN.UTF8"
function zle-line-init zle-keymap-select {
	RPS1="${${KEYMAP/vicmd/-- NORMAL --}/{main|viins)/-- INSERT --}"
	RPS2=$RPS1
	zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select	

#alias tigertun="ssh -D 9999 86.57.250.204"
alias writelog="osascript ~/bin/JournalLogger162.scpt"
alias worklog=writelog
alias ctags="/opt/local/bin/ctags"
alias ssh="$HOME/bin/ssh-wrapper"
#not work`
#alias -g nocom="grep -v ^# |sed '/^$/d'"
autoload -U compinit
compinit

autoload -U url-quote-magic
zle -N self-insert url-quote-magic

autoload -U colors
colors



alias -g bash="zsh"
alias root="sudo zsh"

case `uname` in
FreeBSD)
alias ls="ls -G"
alias watch="cmdwatch"
lookp() { ( cd /usr/ports; make search key=$1 | grep Path | grep -i $1; ); }
#export PACKAGESITE=""
#LSCOLORS
;;
Linux)
alias ls="ls --color"
alias grep="grep --color=auto"
export LS_COLORS='no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;00:cd=40;33;00:or=40;31;00:ex=00;32:*.tar=00;31:*.tgz=00;31:*.rar=00;31:*.ace=00;31:*.zip=00;31:*.bz2=00;31:*.rpm=00;31:*.gz=00;31:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.png=00;35:*.tga=00;35:*.xpm=00;35:*.mpg=00;37:*.avi=00;37:*.mov=00;37:*.mp3=01;35:*.flac=01;35:*.ogg=01;35:*.mpc=01;35:*.wav=01;35:*.ape=01;35:*.core=00;33'
zstyle ':completion:*' list-colors $LS_COLORS
;;
Darwin)
alias ls="ls -G"
alias grep="grep --color=auto"
export PATH=$PATH:/sw/bin:/sw/sbin:/usr/local/magicwrap/bin:/opt/local/bin:/opt/local/sbin
export MANPATH=$MANPATH:/opt/local/share/man
#LSCOLORS
source $HOME/.zsh/zshrc.Darwin
;;
esac

export PATH=$PATH:~/bin
export PS1='%m%# '

if [ $UID -eq 0 ]; then
fi

editors=(vim vi)
for editor in $editors; do
    if which $editor >& /dev/null; then
        export EDITOR==$editor
        export VISUAL=$EDITOR
        alias e=$EDITOR
	alias ee=$EDITOR
	alias vi=$EDITOR
	alias vim=$EDITOR
        break
    fi
done
[[ -z $EDITOR ]] && echo 'No suitable editor found'




msg () {
    echo "[32;1;5m * [0m$*"
}
die () {
    echo "[31;1;5m * [0m$*"
    exit 1
}

src ()
{
	autoload -U zrecompile
	[ -f ~/.zshrc ] && zrecompile -p ~/.zshrc
	[ -f ~/.zcompdump ] && zrecompile -p ~/.zcompdump
	[ -f ~/.zshrc.zwc.old ] && rm -f ~/.zshrc.zwc.old
	[ -f ~/.zcompdump.zwc.old ] && rm -f ~/.zcompdump.zwc.old
	source ~/.zshrc
}

renew () {
	rm $HOME/.zshrc
}

#pull-dotfiles-from () {
#  [ -z $1 ] \
#    && echo -e "Usage:\n    $FUNCNAME [user@]hostname [ssh-args]" \
#    || ( scp $2 $1:'$HOME/.{zshrc,vimrc,screenrc}' $HOME );
#}

pull-dotfiles () {
	cd $HOME
	rm dotfiles.tar
	wget http://kevit.info/dotfiles.tar
	tar xvf dotfiles.tar
}

push-kevit-to () {
cat ~/bin/init_kevit.sh | ssh $1 'sh -' 
}

push-dotfiles-to () {
  [ -z $1 ] \
    && echo -e "Usage:\n    $FUNCNAME [user@]hostname [ssh-args]" \
    || ( scp $HOME/.{zshrc,vimrc,screenrc,profile} $2 $1:'$HOME' );
}

push-admin-to () {
  [ -z $1 ] \
    && echo -e "Usage:\n    $FUNCNAME [user@]hostname [ssh-args]" \
    || ( scp $HOME/bin/init_admin.sh $2 $1:'$HOME' );
}

helpme()
{
	print "Please wait.. ill think about.."
	for i in 1 2 3; do echo -ne "."; sleep 0.3; done
	if [ $RANDOM -gt $RANDOM ]
	then
		print "Yes\!"
	else
		print "No\!"
	fi
}
runsudo(){
	[ -z $1 ] && echo -e "Usage:\n $FUNCNAME hosts script"||
(for i in `cat $1`;do echo $i;scp $2 $i:/home/kevit;ssh $i sudo sh /home/kevit/$2;done)
}
runsudo_once(){
	[ -z $1 ] && echo -e "Usage:\n $FUNCNAME host script"||
(scp $2 $1:/home/kevit;ssh $1 sudo sh /home/kevit/$2)
}
checkaccess(){
	[ -z $1 ] && echo -e "Usage:\n $FUNCNAME hosts"||
(for i in `cat $1`;do ssh $i sudo w && msg "$i ok"||die "$i no access";done)
}

check_app()
{
  app="$1"
  if ! which $app 2>/dev/null >/dev/null ; then
    die "Can find the command '$app' on your system"
  fi 
}
chpwd()
{
    [[ -t 1 ]] || return 0
    case $TERM in
        *xterm*|rxvt|(dt|k|E)term)
            print -Pn "\e]2;%~\a"
            ;;
    esac
}
function set_window_and_tab_title
{
    local title="$1"
    if [[ -z "$title" ]]; then
        title="root"
    fi

    local tmpdir=~/Library/Caches/${FUNCNAME}_temp
    local cmdfile="$tmpdir/$title"

    # Set window title
    echo -n -e "\e]0;${title}\a"

    # Set tab title
    if [[ -n ${CURRENT_TAB_TITLE_PID:+1} ]]; then
        kill $CURRENT_TAB_TITLE_PID
    fi
    mkdir -p $tmpdir
    ln /bin/sleep "$cmdfile"
    "$cmdfile" 10 &
    CURRENT_TAB_TITLE_PID=$(jobs -x echo %+)
    disown %+
    kill -STOP $CURRENT_TAB_TITLE_PID
    command rm -f "$cmdfile"
}
backup_and_edit()
{
    if [ $# -ne 1 ]; then
        echo 'Not enough arguments'
        return 1
    fi
    [[ -r $1 && -f $1 ]] || {
        echo "${0##*/}: $1: no access to that file." >&2
        return 1
    }
    [ ! -r $1.orig ] && cp $1{,.orig}
    $EDITOR $1
}
vman() { man $* | col -b | view -c 'set ft=man nomod nolist' - }

  readme() {
        local files
        files=(./(#i)*(read*me|lue*m(in|)ut)*(ND))
        if (($#files))
        then $PAGER $files
        else
                print 'No README files.'
        fi
  }
status() {
        print ""
        print "Date..: "$(date "+%Y-%m-%d %H:%M:%S")""
        print "Shell.: Zsh $ZSH_VERSION (PID = $$, $SHLVL nests)"
        print "Term..: $TTY ($TERM), $BAUD bauds, $COLUMNS x $LINES cars"
        print "Login.: $LOGNAME (UID = $EUID) on $HOST"
        print "System: $(cat /etc/[A-Za-z]*[_-][rv]e[lr]*)"
        print "Uptime:$(uptime)"
        print ""
  }
# mkdir && cd
  mcd() { mkdir -p "$@"; cd "$@" }  # mkdir && cd

# cd && ls
  cl() { cd $1 && ls -a }

# Use vim to convert plaintext to HTML
  2html() { vim -u NONE -n -c ':syntax on' -c ':so $VIMRUNTIME/syntax/2html.vim' -c ':wqa' $1 > /dev/null 2> /dev/null }

testwww() {
curl -o /dev/null -s -w %{time_connect}:%{time_starttransfer}:%{time_total} $1
}

function range2cidr () {
    if [[ $# == 3 && $2 == "-" ]]; then
        perl -MNet::CIDR::Lite -le '$cidr = Net::CIDR::Lite->new(@ARGV); print join "\n",$cidr->list' $1-$3
    else
        perl -MNet::CIDR::Lite -le '$cidr = Net::CIDR::Lite->new(@ARGV); print join "\n",$cidr->list' $1
    fi

    return $!
}

function cidr2rande () {
	perl -MNet::CIDR -le 'print Net::CIDR::cidr2range("@ARGV")'
}

#print join("\n", Net::CIDR::cidr2range("192.68.0.0/16")) . "\n";
#print Net::CIDR::addrandmask2cidr("195.149.50.61", "255.255.255.248")."\n";
# 
#   @list = Net::CIDR::addr2cidr("192.68.0.31");
#    print join("\n", @list);


function host2block () {
   local i body="$( whois $1 )"

   local ret=$( print "$body" | awk "/^ +Netblock:/ { print \$2 }" )

   if [[ -n $ret ]]; then
        print $ret
        return
   fi

   for i in ${(f)"$( print "$body" | awk '/^inetnum:/ { print $2,"-",$4 }')"}; do
        range2cidr "$i"
   done

   [[ -n $i ]] && return

   print "$body"

   return
}





# before running command
# preexec() { }

# before showing prompt
precmd() {
change_PS

}

