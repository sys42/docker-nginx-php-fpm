#!/bin/sh

## Usage: start.sh [abspath-document-root]

daemonize () {
  docker run -d -p 30000:80 -v "$1":/usr/share/nginx/html $(cat REPO_AND_VERSION)
}

interactive_without_mount () {
  docker run -ti --rm -p 30000:80 $(cat REPO_AND_VERSION) /sbin/my_init -- bash
}

[ $# -ne 0 ] && daemonize "$1" || interactive_without_mount
