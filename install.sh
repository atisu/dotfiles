#!/bin/bash
set -eu

#TEST=:
TEST=
DOTFILES=`ls -1a | grep ^\\\. | grep -v .swp`
BINFILES=`ls -1a bin/`
DATESTR=`date +"%m-%e-%Y_%H-%M-%S"`
MOVEDIR="${HOME}/.dotfiles-moved/${DATESTR}/"


if [ "$PWD" != "$HOME/.dotfiles" ]; then
    echo "ERROR: This script should be run from $HOME/.dotfiles directory!!!"
    exit 254
fi

echo -e "\nArchive directory is: ${MOVEDIR}\n"

for i in ${DOTFILES}; do
    if [ $i == ".." ] || [ $i == "." ] || [ $i == ".git" ]; then
        continue
    fi
    if [ -e "${HOME}/$i" ]; then 
       echo -n "Installing ${HOME}/$i... "
       if [ ! -d "${MOVEDIR}" ]; then
           ${TEST} mkdir -p "${MOVEDIR}"
       fi
       ${TEST} mv "${HOME}/$i" "${MOVEDIR}"
       echo -n "<archived old> "
    fi
    ${TEST} ln -s "${HOME}/.dotfiles/$i" "${HOME}/"
    echo "[OK]"
done

for i in ${BINFILES}; do
    if [ -e "${HOME}/bin/$i" ]; then 
        if [ $i == ".." ] || [ $i == "." ] || [ $i == ".git" ]; then
            continue
        fi
       echo -n "Installing ${HOME}/bin/$i... "
       if [ ! -d "${MOVEDIR}/bin" ]; then
           ${TEST} mkdir -p "${MOVEDIR}/bin"
       fi
       ${TEST} mv "${HOME}/bin/$i" "${MOVEDIR}/bin/"
       echo -n "<archived old> "
    fi
    ${TEST} ln -s "${HOME}/.dotfiles/bin/$i" "${HOME}/bin/"
    echo "[OK]"
done


echo -e "\nDONE!\n"
