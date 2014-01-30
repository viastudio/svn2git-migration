#!/bin/sh

while read line
do
    popd

    if [ ! -d $line ] ; then
        echo "$line does not exist"
        continue
    fi

    pushd $line
    git checkout dev
    git pull upstream dev
    rc=$?

    if [[ $rc != 0 ]] ; then
        echo "could not update repo"
        continue
    fi

    # remove OS files
    find . -type f -name "[Tt]humbs.db" -print0 | xargs -0 rm -f
    find . -type f -name ".DS_Store" -print0 | xargs -0 rm -f
    find . -type f -name "._*" -print0 | xargs -0 rm -f

    # remove SVN related files
    rm checkout.log.txt
    rm update.log.txt
    rm version.txt

    git add --all
    rc=$?

    if [[ $rc != 0 ]] ; then
        echo "nothing to add"
        continue
    fi

    git commit -m "Repository cleanup."
    rc=$?

    if [[ $rc != 0 ]] ; then
        echo "could not commit"
        continue
    fi

    git push upstream dev

done < "$1"