#!/bin/bash

################################################################################
## Feature  : Get an empty file of specified type.
## Author   : ZhangLue 
## Date     : 2017.01.23
################################################################################

################################################################################
##  CHECK THE COMPLETENESS FIRST OF ALL
################################################################################
if [[ -z ${DIR_SCRIPTS} ]] ||
   [[ ! -s "${DIR_SCRIPTS}/common.sh" ]] 
then
    echo
    echo '${DIR_SCRIPTS}/common.sh is not correct.'
    echo
    exit 99
fi

COMMON_FILE="${DIR_SCRIPTS}/common.sh"
. $COMMON_FILE

################################################################################
## FUNCTIONS
################################################################################
_usage()
{
    _echo_usage
    echo ""
    echo "getAnEmptyShell.sh [FILE NAME]"
    echo ""
}

_output_template_bash()
{
    local author=$USER
    if [[ $author == 'zhanglue' ]]; then
        author="ZhangLue"
    fi
    echo "#!/bin/bash

################################################################################
## Feature  : 
## Author   : $author
## Date     : "`date +%Y.%m.%d`"
################################################################################
" > $goalFileName
}

_output_template_python()
{
    echo "#/* encoding=utf-8 */
#/* vim: set expandtab ts=4 sw=4 sts=4 tw=100: */

" > $goalFileName
}

_output_template_c()
{
    echo "#include <stdio.h>

int main()
{

    return 0;
}" > $goalFileName
}

_output_template_cpp()
{
echo "#include <iostream>

using namespace std;

int main()
{

    return 0;
}" > $goalFileName
}

################################################################################
## MAIN
################################################################################

echo ""

if (( $# != 2 )); then
    _usage
    exit 1
fi

goalFileType=$1
goalFileName=$2
needChmod=0

case $goalFileType in
    bash | Bash | BASH)
        goalFileType="bash"
        needChmod=1
        ;;
    python)
        goalFileType="python"
        needChmod=0
        ;;
    c | C)
        goalFileType="c"
        ;;
    cpp | Cpp | CPP)
        goalFileType="cpp"
        ;;
    *)
        _usage
        exit 2
    ;;
esac

if [[ -f $goalFileName ]]; then
    echo -e "${RED_F}${goalFileName}${END_S} is existing already."
    read -p "Override it?"
    if [[ ! $REPLY =~ ^[Yy] ]]; then
        echo ""
        exit 2
    fi
fi

if [[ -d $goalFileName ]]; then
    echo -e "${RED_F}${goalFileName}${END_S}is a existing directory."
    echo ""
    exit 2
fi

_output_template_$goalFileType

if [[ ! -f $goalFileName ]]; then
    echo -e "${RED_F}Failed!${END_S}"
    exit 99
fi

if (( $needChmod )); then
    chmod 744 $goalFileName
fi

echo -e "${GRN_F}${goalFileName}${END_S} has been generated."
echo ""

exit 0
