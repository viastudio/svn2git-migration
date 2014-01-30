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

    if [ ! -f README.md ] ; then
        if [ -f README ] ; then
            echo "renaming README"
            git mv README README.md
        else
            echo "adding README"
            echo $line > README.md
        fi
    fi

    git add --all
    rc=$?

    if [[ $rc != 0 ]] ; then
        echo "nothing to add"
        continue
    fi

    git commit -m "Added README."
    rc=$?

    if [[ $rc != 0 ]] ; then
        echo "could not commit"
        continue
    fi

    git push upstream dev

done < "$1"