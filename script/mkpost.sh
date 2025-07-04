#!/bin/bash

SECTION="$1"
FILE_NAME="$(openssl rand -hex 5)"
COLOR_RED="\e[31m"
COLOR_GREEN="\e[32m"
COLOR_NONE="\e[0m"


if [[ "$(basename \"$PWD\")" != "src" ]]; then
    cd "./src" || (printf "${COLOR_RED}ERROR${COLOR_NONE} \`src\` directory not found\n" && exit 1)
fi


# Create the post in the given folder
(hugo new --kind post "content/${SECTION}/${FILE_NAME}.md" && \
  mkdir -p "static/img/${FILE_NAME}") && \
  printf "${COLOR_GREEN}SUCCESS${COLOR_NONE} Article created\n" || \
  printf "${COLOR_RED}ERROR${COLOR_NONE} Something went wrong\n"
