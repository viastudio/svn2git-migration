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

    if [ ! -f .gitignore ] ; then
        echo "creating .gitignore..."
        if [ -d webroot/wp-content/ ] ; then
                cat ../gitignore/Project.gitignore ../gitignore/WordPress.gitignore > .gitignore
                echo "for WordPress"
        elif [ -d cakephp/ ] ; then
            cat ../gitignore/Project.gitignore ../gitignore/CakePHP.gitignore > .gitignore
            echo "for CakePHP"
        else
            cp ../gitignore/Project.gitignore .gitignore
            echo "for general"
        fi
    fi

    git add --all
    rc=$?

    if [[ $rc != 0 ]] ; then
        echo "nothing to add"
        continue
    fi

    git commit -m "Added .gitignore."
    rc=$?

    if [[ $rc != 0 ]] ; then
        echo "could not commit"
        continue
    fi

    git push upstream dev

done < "$1"