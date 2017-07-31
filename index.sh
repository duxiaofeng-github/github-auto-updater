#!/bin/bash

GITHUB_REPO_PATH="$HOME/github"

function checkTcPlayerRepo() {
    tcMD5=$(curl -s http://imgcache.qq.com/open/qcloud/video/vcplayer/TcPlayer.js | md5)
    githubMD5=$(curl -s https://raw.githubusercontent.com/duxiaofeng-github/TcPlayer/master/TcPlayer.js | md5)
    if [[ $tcMD5 != $githubMD5 ]]; then
        updateTcPlayerRepo $tcMD5
        echo "old: $githubMD5, new: $tcMD5, tags: $(git tag -l | tail -n 1)"
    else
        echo "tcplayer not changed"
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
    wget -q http://imgcache.qq.com/open/qcloud/video/vcplayer/TcPlayer.js -O TcPlayer.js
    printf "### AUTO UPDATE Tcplayer.js\n* auto update at $nowWithSecond, md5 $1\n\n" >> CHANGELOG.md
    git add TcPlayer.js CHANGELOG.md
    git commit -q -m "update TcPlayer.js $now"

    git push -q

    tag=$(git tag -l | tail -n 1)
    if [[ $tag == "" ]]; then
        tag="0.0.0"
    fi
    tagArr=(${tag//./ })
    num1=${tagArr[0]}
    num2=${tagArr[1]}
    num3=${tagArr[2]}
    num3=$((num3+1))
    newTag="$num1.$num2.$num3"

    git tag $newTag
    git push -q --tags
}

function main() {
    checkTcPlayerRepo
}

main