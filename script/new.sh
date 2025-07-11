#!/bin/bash

ID="$(openssl rand -hex 5)"
COLOR_RED="\e[31m"
COLOR_GREEN="\e[32m"
COLOR_NONE="\e[0m"

case "$1" in
    "s") (mkdir "src/content/${ID}"; touch "src/content/${ID}/_index.md") \
        || echo -e "${COLOR_RED}ERROR${COLOR_NONE} Failed to create section src/content/${ID}" \
        && echo -e "${COLOR_GREEN}SUCCESS${COLOR_NONE} Created section src/content/${ID}";;
    "p") (cd "src"; hugo new --kind post "content/$2/${ID}.md"; mkdir "static/img/${ID}"; rm ".hugo_build.lock") \
        || echo -e "${COLOR_RED}ERROR${COLOR_NONE} Failed to create post src/content/$2/${ID}" \
        && echo -e "${COLOR_GREEN}SUCCESS${COLOR_NONE} Created post src/content/$2/${ID}";;
    *) echo "${COLOR_RED}ERROR${COLOR_NONE} Unknown verb: $1"
esac
