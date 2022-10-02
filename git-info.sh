#!/bin/bash

# get current branch in git repo
function create_json {
    branch_info=`get_active_git_branch`
    if [ ! "${branch_info}" == "" ]; then
        branch=`get_branch_name "${branch_info}"`
        sha=`get_sha "${branch_info}"`    
        comment=`get_comment "${branch_info}"`
        tag=`get_tag`
        flags=`get_dirty`
        printf '{"branch": "%s", "sha": "%s", "comment": "%s", "tag": "%s", "flags": [%s]}\n' "$branch" "$sha" "$comment" "$tag" "$flags"        
    else
        echo "{}"
    fi
}

function get_active_git_branch {
    echo "`git branch --no-color --verbose 2>/dev/null | sed '/^[^*]/d'`"
}

function get_tag {
    echo `git describe --tags --exact-match 2>/dev/null`
}

function get_branch_name {
    local branch_info=$1
    echo "`echo -n "${branch_info}" | sed -r 's/\* ([^ ]+).*/\1/'`"
}

function get_sha {
    local branch_info=$1
    echo "`echo -n "${branch_info}" | sed -r 's/\* [^ ]+ ([a-f0-9]+) .*/\1/I'`"
}

function get_comment {
    local branch_info=$1
    echo "`echo -n "${branch_info}" | sed -r -e 's/\* [^ ]+ [a-f0-9]+ (.*)/\1/I' -e 's/"/\\\\"/g'`"
}

# get current status of git repo
function get_dirty {
    status=`git status 2>&1 | tee`
    dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
    bits=''
    if [ "${renamed}" == "0" ]; then
      bits="\"renamed\",${bits}"
    fi
    if [ "${ahead}" == "0" ]; then
        bits="\"ahead\",${bits}"
    fi
    if [ "${newfile}" == "0" ]; then
        bits="\"newfile\",${bits}"
    fi
    if [ "${untracked}" == "0" ]; then
        bits="\"untracked\",${bits}"
    fi
    if [ "${deleted}" == "0" ]; then
        bits="\"deleted\",${bits}"
    fi
    if [ "${dirty}" == "0" ]; then
        bits="\"dirty\",${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
	    echo "${bits::-1}"
    else
	    echo ""
    fi
}

create_json
