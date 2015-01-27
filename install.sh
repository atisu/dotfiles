#!/bin/bash
set -eu

#TEST=:
TEST=
DATESTR=`date +"%m-%e-%Y_%H-%M-%S"`
MOVEDIR="${HOME}/.dotfiles-moved/${DATESTR}/"


if [ "$PWD" != "$HOME/.dotfiles" ]; then
    echo "ERROR: This script should be run from $HOME/.dotfiles directory!"
    exit 254
fi

echo -e "\nArchive directory is: ${MOVEDIR}\n"

moveFiles ()
{
    if [ -z "$1" ]; then
        return 1
    fi
    FILES="$1"
    PATHSUFFIX="$2"

    if [ ! -z "${PATHSUFFIX}" ] && [ ! -e "${HOME}/${PATHSUFFIX}" ]; then
        mkdir -p "${HOME}/${PATHSUFFIX}"
    fi
    if [ ! -z "${PATHSUFFIX}" ] && [ ! -d "${HOME}/${PATHSUFFIX}" ]; then
        echo "ERROR: ${HOME}/${PATHSUFFIX} exists and is not a directory!"
        return 2
    fi

    for i in ${FILES}; do
        if [ $i == ".." ] || [ $i == "." ] || [ $i == ".git" ] || [ $i == ".gitmodules" ]; then
            continue
        fi
        echo -n "Installing ${HOME}/${PATHSUFFIX}/$i... "
        if [ -e "${HOME}/${PATHSUFFIX}/$i" ]; then 
           if [ ! -d "${MOVEDIR}/${PATHSUFFIX}" ]; then
               ${TEST} mkdir -p "${MOVEDIR}/${PATHSUFFIX}"
           fi
           ${TEST} mv "${HOME}/${PATHSUFFIX}/$i" "${MOVEDIR}/${PATHSUFFIX}/"
           echo -n "<archived old> "
        fi
        ${TEST} ln -s "${HOME}/.dotfiles/${PATHSUFFIX}/$i" "${HOME}/${PATHSUFFIX}/"
        echo "[OK]"
    done
    return 0
}

DOTFILES=`ls -1a | grep ^\\\. | grep -v .swp`
moveFiles "${DOTFILES}" ""

if [ `uname -s` == "Darwin" ]; then
    BINFILES=`ls -1a bin/`
else
    # bin/*vim* files are for MacVim.app
    BINFILES=`ls -1a bin/ | grep -v vim`
fi
moveFiles "${BINFILES}" "bin"

echo -e "\nDONE!\n"

