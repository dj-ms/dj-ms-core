#!/bin/bash


# Display help
help() {
  echo "Usage: build.sh OPTIONS [docker build args]"
  echo
  echo "Options:"
  echo "-t, --tag string      Tag to build docker image. Default: harleyking/dj-ms-core:latest"
  echo "-h, --help            Print this Help."
  echo
  }

while test $# -gt 0; do
   case "$1" in
      -t|--tag)
         TAG=$2
         shift
         shift;;
      -h|--help)
         help
         exit 0;;
      *)
         break;;
   esac
done

if [[ -z "${TAG}" ]]; then
  TAG="harleyking/dj-ms-core:latest"
fi

CACHE_DATE=$(date "+%Y-%m-%d-%H-%M-%S")
UPCOMING_TAG="${TAG}-${CACHE_DATE}"
OLD_TAG="${TAG}-old-${CACHE_DATE}"

del () {
  local tag=$1
  docker image rm -f "${tag}" 2>/dev/null
}

build () {
  docker build . -t "${UPCOMING_TAG}" --build-arg "CACHE_DATE=${CACHE_DATE}" || exit 1
  docker tag "$TAG" "${OLD_TAG}" 2>/dev/null; del "$TAG"
  docker tag "${UPCOMING_TAG}" "$TAG" 2>/dev/null; del "${UPCOMING_TAG}"
}

build || exit 1;

