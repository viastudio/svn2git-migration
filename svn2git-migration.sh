#!/bin/sh

while read line
do
    popd

    repo="svn://$line"
    echo "converting $line..."

    svn ls --depth empty $repo
    rc=$?

    if [[ $rc != 0 ]] ; then
        echo "repository does not exists: $repo"
        continue
    fi

    github_remote=`php lib/create-github-repo.php $line`
    rc=$?

    if [[ $rc != 0 ]] ; then
        echo "could not create repository on GitHub"
        continue
    fi

    echo "repository created on GitHub: $github_remote"

    mkdir $line
    pushd $line

    echo "svn2git $line"
    svn2git $repo --authors ../authors-file.txt --notags --notrunk
    rc=$?

    if [[ $rc != 0 ]] ; then
        echo "repository could not be converted"
        continue
    fi

    echo "adding upstream remote"
    git remote add upstream $github_remote
    rc=$?

    if [[ $rc != 0 ]] ; then
        echo "could not add upstream remote"
        continue
    fi

    git checkout dev
    git push upstream dev
    rc=$?

    if [[ $rc != 0 ]] ; then
        echo "could not push dev to upstream"
        continue
    fi

    # create staging and master branches
    git checkout -b staging dev
    git push upstream staging

    git checkout -b master staging
    git push upstream master

done < "$1"
