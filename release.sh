#!/bin/bash

################################################################################
## Feature  : Release to work environment
## Author   : ZhangLue
## Date     : 2017.04.11
################################################################################

echo 
if [[ -z $HH ]] || [[ ! -d $HH ]]; then
    echo 'Base "home" is requried.'
    echo
    exit 1
fi
if [[ -z ${DIR_RC} ]] || [[ ! -d ${DIR_RC} ]]; then
    echo 'RC "home" is requried.'
    echo
    exit 1
fi

cd "$(dirname -- "${BASH_SOURCE-$0}")"

BASH_RC_GIT='bashrc'
ZSH_RC_GIT='zshrc'
VIM_RC_GIT='vimrc'
VIM_GIT='vim'
ZHANGLUE_SCRIPTS_GIT='zhanglueScripts'
GIT_IGNORE='gitignore'

# 1. .bashrc
if [[ -f $BASH_RC_GIT ]]; then
    sourceRcFile=$BASH_RC_GIT 
    rcFile="${DIR_RC}/.bashrc"
    [[ -f $rcFile ]] && cp $rcFile ${rcFile}_bak
    lineNum=`cat $rcFile | grep -n '^# Under GIT control$' | cut -d ':' -f 1`
    if [[ -z $lineNum ]]; then
        echo '# Under GIT control' >> $rcFile
        cat $sourceRcFile >> $rcFile
        echo '# Out of GIT control' >> $rcFile
    else
        tempFile=`mktemp`
        sed -n "1,${lineNum}p" $rcFile > $tempFile
        cat $sourceRcFile >> $tempFile
        lineNum=`cat $rcFile | grep -n '^# Out of GIT control$' | cut -d ':' -f 1`
        if [[ -n $lineNum ]]; then
            sed -n "${lineNum},$ p" $rcFile >> $tempFile
        else
            echo "# Out of GIT control" >> $tempFile
        fi
        mv $tempFile $rcFile
    fi
fi

# 2. .zshrc
if [[ -f $ZSH_RC_GIT ]]; then
    sourceRcFile=$ZSH_RC_GIT
    rcFile="${DIR_RC}/.zshrc"
    [[ -f $rcFile ]] && cp $rcFile ${rcFile}_bak
    lineNum=`cat $rcFile | grep -n '^# Under GIT control$' | cut -d ':' -f 1`
    if [[ -z $lineNum ]]; then
        echo '# Under GIT control' >> $rcFile
        cat $sourceRcFile >> $rcFile
        echo '# Out of GIT control' >> $rcFile
    else
        tempFile=`mktemp`
        sed -n "1,${lineNum}p" $rcFile > $tempFile
        cat $sourceRcFile >> $tempFile
        lineNum=`cat $rcFile | grep -n '^# Out of GIT control$' | cut -d ':' -f 1`
        if [[ -n $lineNum ]]; then
            sed -n "${lineNum},$ p" $rcFile >> $tempFile
        else
            echo '# Out of GIT control' >> $tempFile
        fi
        mv $tempFile $rcFile
    fi
fi

# 3. .vimrc
if [[ -f $VIM_RC_GIT ]]; then
    sourceRcFile=$VIM_RC_GIT
    rcFile="${DIR_RC}/.vimrc"
    [[ -f $rcFile ]] && cp $rcFile ${rcFile}_bak
    lineNum=`cat $rcFile | grep -n '^" Under GIT control$' | cut -d ':' -f 1`
    if [[ -z $lineNum ]]; then
        echo '" Under GIT control' >> $rcFile
        cat $sourceRcFile >> $rcFile
        echo '" Out of GIT control' >> $rcFile
    else
        tempFile=`mktemp`
        sed -n "1,${lineNum}p" $rcFile > $tempFile
        cat $sourceRcFile >> $tempFile
        lineNum=`cat $rcFile | grep -n '^" Out of GIT control$' | cut -d ':' -f 1`
        if [[ -n $lineNum ]]; then
            sed -n "${lineNum},$ p" $rcFile >> $tempFile
        else
            echo '" Out of GIT control' >> $tempFile
        fi
        mv $tempFile $rcFile
    fi
fi

# 4. .vim
rsync -a --delete ${VIM_GIT}/ ~/.vim

# 5. .zhanglueScripts
rsync -a --delete ${ZHANGLUE_SCRIPTS_GIT}/ ${HH}/.zhanglueScripts
if [[ ! -f ~/.gitignore ]]; then
    \cp $GIT_IGNORE ~/.gitignore
    git config --global core.excludesfile ~/.gitignore
else
    \cp $GIT_IGNORE ~/.gitignore
fi

echo 'Done.'
echo
