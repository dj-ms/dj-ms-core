#!/bin/bash


# Display help
help()
{
   echo "Usage: build.sh OPTIONS [docker build args]"
   echo
   echo "Options:"
   echo "-t, --tag string      Tag to build docker image. Default: latest"
   echo "-h, --help            Print this Help."
   echo
}

while test $# -gt 0; do
   case "$1" in
      -t|--tag)
         TAG=$2
         shift
         shift
         ;;
      -h|--help)
         help
         exit 0
         ;;
      *)
         break
         ;;
   esac
done


if [[ -z "${TAG}" ]]; then
  TAG="latest"
fi

# Some unique string to invalidate cache
CACHE_DATE=$(date "+%Y-%m-%d:%H:%M:%S")

# Set current directory as project name
IMAGE_NAME=harleyking/$(basename "$(pwd)")

del () {
  local tag=$1
  docker image rm -f "${IMAGE_NAME}":"${tag}" 2>/dev/null
}

tag () {
  local from=$1 to=$2
  docker tag "${IMAGE_NAME}":"${from}" "${IMAGE_NAME}":"${to}" 2>/dev/null
}

build () {
  # shellcheck disable=SC2048
  # shellcheck disable=SC2086
  docker build . -t "${IMAGE_NAME}:upcoming" --build-arg "CACHE_DATE=${CACHE_DATE}" $* && success=true || success=false
}

build_image () {
  local on_new on_old
  on_new="$(docker ps -q -f ancestor="${IMAGE_NAME}":"$TAG" 2>/dev/null)"
  on_old="$(docker ps -q -f ancestor="${IMAGE_NAME}":old 2>/dev/null)"

  del upcoming
  if [[ -n ${on_new} ]] && [[ -n ${on_old} ]] && [[ ! "${on_new}" == "${on_old}" ]]; then
    echo "Cannot build if there is containers running on both \"$TAG\" and \"old\" image. Sorry..."
    exit 1
  fi
  if [[ -z "${on_old}" ]]; then (tag old pre_delete && del old && pre_delete=true); else pre_delete=false; fi
  # shellcheck disable=SC2086
  build ${DOCKER_ADDITIONAL_ARGS}
  if $success; then
    del pre_delete
    ${pre_delete} && tag "$TAG" old;
    del "$TAG"
    tag upcoming "$TAG"
    del upcoming
  else
    ${pre_delete} && tag pre_delete old
    del pre_delete
    return 1
  fi
}

build_image || exit 126;

