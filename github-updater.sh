#!/bin/bash

GITHUB_REPO_PATH="$HOME/github"

function checkTcPlayerRepo() {
    tcUrl=$(python get-player-script-url.py)

    if [[ $tcUrl == "" ]]; then
        echo 'no url found'
        exit 0
    fi

    tcMD5=$(curl -s $tcUrl | md5sum | awk '{print $1}')
    tcVer=$(echo $tcUrl | awk -F '-' '{print $2}' | awk -F '.js' '{print $1}')
    githubMD5=$(curl -s https://raw.githubusercontent.com/duxiaofeng-github/TcPlayer/master/TcPlayer.js | md5sum | awk '{print $1}')
    nowWithSecond=$(date +%Y\-%m\-%d\ %H\:%M\:%S)

    if [[ $tcMD5 != $githubMD5 ]]; then
        updateTcPlayerRepo $tcUrl $tcMD5 $tcVer
        updateTcPlayerNpm $tcVer
        newVersion=$(git tag -l | tail -n 1)
        echo "$nowWithSecond old: $githubMD5, new: $tcMD5, tags: $newVersion"
    else
        echo "$nowWithSecond tcplayer not changed"
    fi
}

function updateTcPlayerRepo() {
    TCPLAYER_REPO_PATH="$GITHUB_REPO_PATH/tc-player"

    if [ ! -d $TCPLAYER_REPO_PATH ]; then
        mkdir -p $TCPLAYER_REPO_PATH
        cd $TCPLAYER_REPO_PATH
        git clone -q git@github.com:duxiaofeng-github/TcPlayer.git
    fi

    now=$(date +%Y\-%m\-%d)
    nowWithSecond=$(date +%Y\-%m\-%d\ %H\:%M\:%S)

    cd "$TCPLAYER_REPO_PATH/TcPlayer"
    git fetch -q origin master
    git reset -q --hard origin/master
    wget -q $1 -O TcPlayer.js
    printf "### AUTO UPDATE Tcplayer.js\n* auto update at $nowWithSecond, md5 $2, version: $3\n\n" >> CHANGELOG.md
    README_TEMPLATE=$(cat README_TEMPLATE.md)
    README_TEMPLATE=${README_TEMPLATE//\tcplayerUrlPlaceHolder/$1}
    echo $README_TEMPLATE > README.md
    git add TcPlayer.js CHANGELOG.md
    git commit -q -m "update TcPlayer.js $now"

    git push -q
}

function updateTcPlayerNpm() {
    npm version $1
    npm publish
    git push -q --tags
}

function main() {
    checkTcPlayerRepo
}

main
