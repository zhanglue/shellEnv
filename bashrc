export LANG='en_US.UTF-8'
alias langGbk='export LANG=zh_CN.GBK'
alias langUtfUS='export LANG=en_US.UTF-8'
alias langUtfCN='export LANG=zh_CN.UTF-8'
export DIR_WORK="${HH}/work"
export DIR_SCRIPTS="${DIR_RC}/.zhanglueScripts"
source "${DIR_SCRIPTS}/common.sh"
export PATH="${DIR_SCRIPTS}:${PATH}"
export PS1="[\[\e[0;36m\]\u\[\e[0m\]@\[\e[0;31m\]\h\[\e[0m\] \[\e[0;33m\]\W\[\e[0m\]][\[\e[0;32m\]\#\[\e[0m\]]$ "
export PS2="${BLK_F}${WHT_B}KEEP INPUTING${WHT_F}${BLK_B}${RED_F}>${YEL_F}>${SKY_F}>${END_S} "
export LS_COLORS='no=00:fi=00:di=00;33:ln=04;36:pi=40;33:so=00;35:do=00;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=00;32:*.tar=01;35:*.tgz=01;35:*.arj=01;35:*.taz=01;35:*.zip=01;35:*.z=01;35:*.Z=00;31:*.gz=01;35:*.bz2=01;35:*.deb=00;31:*.rpm=00;31:*.jar=00;31:*.jpg=00;35:*.jpeg=00;35:*.gif=00;35:*.bmp=00;35:*.png=00;35:*.mov=00;35:*.mpg=00;35:*.mpeg=00;35:*.avi=00;35:*.mp3=00;35:*.wav=00;35:*.c=00;31:*.cc=00;31:*.cpp=00;31:*.h=00;35:*.hh=00;35:*.o=01;36:*.py=00;34:*.pyc=01;36:*.hql=01;35:*.sql=01;35:*.go=01;36:*.cs=01;35:*.csproj=01;36'
export HISTCONTROL=ignoreboth

export SHOW_CONTENTS_AFTER_CD=1
function cd()
{
    if [[ "$@" == '-' ]]; then
        builtin cd "$@" && \
            [[ $SHOW_CONTENTS_AFTER_CD != 0 ]] && \
                ls --color
    else
        builtin cd "$@" && \
            [[ $SHOW_CONTENTS_AFTER_CD != 0 ]] && \
                pwd && \
                ls --color
    fi
}

function switchCDMode()
{
    [[ $SHOW_CONTENTS_AFTER_CD == 0 ]] && \
        SHOW_CONTENTS_AFTER_CD=1 || \
        SHOW_CONTENTS_AFTER_CD=0
    echo ""
    echo -e "${GRN_F}SHOW_CONTENTS_AFTER_CD${END_S}=$SHOW_CONTENTS_AFTER_CD"
    echo ""
}

function set_term_title()
{
    if [ -z "$ORIG" ]; then
        ORIG=$PS1
    fi

    TITLE="\[\e]2;$*\a\]"
    PS1=${ORIG}${TITLE}
}

alias st="set_term_title"
alias zz="cd $HH"
alias ls='ls --color'
alias ll='ls -lh'
alias la='ls -A'
alias lla='ls -lhA'
alias df='df -h'
alias du='du -h'
alias tailf='tail -f'
alias h='history | tail -n 20'
alias grep='grep --color'
alias fdh='find ./ -name'
alias fv='findAndVimIt.sh find_and_vim_it'
alias fo='findAndVimIt.sh find_only'
alias fs='findAndVimIt.sh select_to_vim'
alias cat='/usr/local/bin/ccat'
alias ccat='/usr/bin/cat'
alias htop='sudo htop'

alias e="source ${DIR_SCRIPTS}/enterDir.sh -t 1"
alias rt="source ${DIR_SCRIPTS}/enterDir.sh -t 2"
alias v="${DIR_SCRIPTS}/enterDirListChoose.sh --vim"
alias so="searchAndVimIt.sh search"
alias s="searchAndVimIt.sh search_and_save"
alias sd="searchAndVimIt.sh search_and_save --defination-only"
alias st="searchAndVimIt.sh search_and_save --exclude-tests"
alias ss="searchAndVimIt.sh select"
alias gb="gitBranch.sh -ns"
alias gbd="gitBranch.sh -d"
alias getASH='getAnEmptyShell.sh bash'
alias getAPY='getAnEmptyShell.sh python'

alias vim="vim -u ${DIR_RC}/.vimrc"
alias vvim="${DIR_SCRIPTS}/vvim.sh"
alias vimdiff="vimdiff -u ${DIR_RC}/.vimrc"
#alias vim="gvim --remote-tab-silent $@"
alias scp='scp -l 10000 -r'
alias tagsP='ctags -R --extra=+qf --languages=Python'
alias tagsC='ctags -R --extra=+qf --languages=C++'

alias gix='git status'
alias gixs='git status --short'
alias gia='git add'
alias gic='git commit'
alias gid='git difftool'
alias gidc='git difftool --cached'
alias gidh='git difftool HEAD'
alias gipp='git push'
alias gipu='git push origin master'

alias svu='svn up'
alias svx='svn st -u'
alias sva='svn add'
alias svd='svn diff'
alias svc='svn commit'

alias py='python'
alias py3='python3'
alias rmPyc='find ./ -regex ".+\.py[cod]$" -type f -print0 | xargs -0 -l1 -i -t rm -f {}'
alias rmSwp='find ./ -regex ".*\..+\.sw[po]$" -type f -print0 | xargs -0 -l1 -i -t rm -f {}'
alias no='nosetests'
alias nov='nosetests -v'
alias novp='nosetests -v --nocapture'

alias hf='hadoop fs'
alias hls='hadoop fs -ls'
alias hmkdir='hadoop fs -mkdir'
alias hput='hadoop fs -put'
alias hget='hadoop fs -get'
alias hrm='hadoop fs -rm'
alias hrmr='hadoop fs -rmr'
alias hcat='hadoop fs -cat'
alias htail='hadoop fs -tail'
alias hchmod='hadoop fs -chmod'
alias hdu='hadoop fs -du'
alias htest='hadoop fs -test'

alias sgcc="source ${DIR_SCRIPTS}/switchGCC.sh"
alias sgit="source ${DIR_SCRIPTS}/switchGit.sh"

# Docker
alias dia='docker images'
alias di='docker images | grep -v "docker.oa.com:8080"'
alias dpull='docker pull'
alias drmi='docker rmi'
alias dtag='docker tag'
alias dci='docker commit'
alias dps='docker ps -a'
alias drm='docker rm'
alias drun='docker run'
alias dcreate='docker create'
alias dstart='docker start'
alias dstop='docker stop'
alias dstart='docker restart'
alias dattach='docker attach'
alias dexec='docker exec'
alias dcp='docker cp'

alias resourceBashrc="source ${DIR_RC}/.bashrc"

HELLOW_SCREEN='_shenShou'
if [[ -z $PRIVATE_BASH_RC_LOADED ]]; then
    $HELLOW_SCREEN
    export PATH="${DIR_SCRIPTS}:${PATH}"
    export PRIVATE_BASH_RC_LOADED=1
fi

# Out of GIT control
##################################################

## pyenv
pyenv_init(){
    export PYENV_ROOT=/root/.pyenv
    export PATH="${PYENV_ROOT}/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    eval "$(pyenv init --path)"
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
}

export PS1="[\[\e[0;36m\]\u\[\e[0m\]@\[\e[0;31m\]local\[\e[0m\] \[\e[0;33m\]\W\[\e[0m\]][\[\e[0;32m\]\#\[\e[0m\]]$ "

#LDFLAGS=" ${LDFLAGS}"
export LDFLAGS

#CPPFLAGS=" ${CPPFLAGS}"
export CPPFLAGS

#PATH=" :${PATH}"
PATH="/root/.dotnet:${PATH}"
PATH="/root/work/PrivateTools/shell_scripts:${PATH}"
export PATH

builtin cd /root
