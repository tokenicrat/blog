#!/bin/bash

set -e

VERSION="0.152.2"

echo "Build for Cloudflare Workers..."

echo "-> Get Hugo v${VERSION}"
curl \
    -sSL "https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_extended_${VERSION}_linux-amd64.tar.gz" \
    -o "hugo.tar.gz"

echo "-> Unarchive"
tar -xf ./hugo.tar.gz

echo "-> Build site"
./hugo build

echo "Success"
