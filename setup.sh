#!/bin/bash

gitdir=$PWD
antigen_gitdir="$gitdir/antigen-git"
antigen_pkgdir="$gitdir/pkg"

#
# Bootstrap antigen
#
function setup_antigen() {
    if [[ ! -e $antigen_gitdir ]];then
        git clone "https://github.com/zsh-users/antigen" $antigen_gitdir
    else
        cd $antigen_gitdir
        git pull origin master
    fi
}
setup_antigen

#
# Set up package directory
#
if [[ ! -e "$antigen_pkgdir" ]];then
    mkdir $antigen_pkgdir
fi

#
# Set up symlinks
#
link_tuples=(
    "$antigen_pkgdir" "$HOME/.antigen"
    "$gitdir/antigenrc" "$HOME/.zshrc.antigen"
)
remove_links=(
    "$HOME/.antigen"
    "$HOME/.antigenrc"
)
# move_tuples=(
#     "$HOME/.antigen" "$antigen_pkgdir"
#     "$HOME/.antigenrc" "$antigen_pkgdir"
# )

# i=0
while [[ "${link_tuples[0]}" ]];do
    local from="${link_tuples[0]}"
    local to="${link_tuples[1]}"
    echo "::INSTALL:: $from -> $to"
    link_tuples=("${link_tuples[@]:2}")
    if [[ -e "$to" || -L "$to" ]];then
        echo -n "$to already exists. "
        if [[ $OPT_INTERACTIVE && $(ask_yes_no "Backup and continue?") = "yes" ]];then
            now=$(date +%s%N)
            mv -vi $to $to.$now
            echo "mv -vi ${to}.${now} ${from}"
        else
            continue
        fi
    fi
    echo "$OPT_INTERACTIVE"
    ln -s "$from" "$to"
    # i=$(( $i + 1))
    # if [[ i -gt 10 ]];then
    #     exit;
    # fi
done
