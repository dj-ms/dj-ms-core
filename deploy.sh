#!/bin/bash


help()
{
   echo "Usage: deploy.sh [OPTIONS]"
   echo
   echo "Options:"
   echo "-d, --down            Don't build or deploy, just down the stack"
   echo "-n, --no-build        Don't build, just deploy"
   echo "-h, --help            Print this Help."
   echo
}


# Short replacement for long docker compose command
compose () {
  # shellcheck disable=SC2086
  local args=$*; docker compose -f docker-compose.yml -f docker-compose.prod.yml $args
}

sed_alt () {
  local SED=sed args=$*
  if [[ $(uname) == "Darwin" ]] ; then
      SED=gsed
      type $SED >/dev/null 2>&1 || { echo >&2 "$SED it's not installed. Try: brew install gnu-sed"; exit 1; }
  fi
  # shellcheck disable=SC2086
  $SED ${args}
}

build=true
while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--down)
      compose down;
      exit
      ;;
    -n|--no-build)
      build=false;
      shift
      ;;
    -h|--help)
      help
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 2
      ;;
    esac
done

if $build; then
  TAG=$(grep DJ_MS_CORE_VERSION .env | xargs | awk -F "=" '{print $2}')
  if [[ -z "${TAG}" ]]; then
    TAG="latest"
  fi
  . build.sh -t "$TAG" || exit 126
fi

service_scale () {
  local count=$1 scales=""; for i in "${!services[@]}"; do scales+="--scale ${services[i]}=$count "; done
  echo "$scales"
}

get_services () {
  local name; services=()
  while IFS= read -r service || [[ -n "$service" ]]; do if [[ "${service}" == "#"* ]]; then continue; fi
    name=$(echo "$service" | awk '{print $1}'); services+=("$name")
  done < Services
}

rollback () {
  local last service_name
  last=$(compose ps | tail -n +2 | awk '{print $1}' | awk -F- '{print $NF}' | sort -nr | head -n 1)
  service_name=$(grep COMPOSE_PROJECT_NAME .env | xargs | awk -F= '{print $2}')
  compose ps | tail -n +2 | awk '{print $1}' | grep "${service_name}-.*-${last}" | xargs docker rm -f
}


if [ -z "$(docker compose ps -q)" ]; then
  compose up -d || (error_code=$?; compose down; exit $error_code)
else
  get_services
  # shellcheck disable=SC2046
  compose up -d --no-recreate $(echo $(service_scale 2)) || (code=$?; rollback; exit $code)
  # shellcheck disable=SC2046
  compose up -d --no-recreate $(echo $(service_scale 1)) || (code=$?; rollback; exit $code)
  compose exec -it nginx nginx -s reload
fi

DJ_MS_APP_LABEL=$(grep DJ_MS_APP_LABEL .env | xargs | awk -F "=" '{print $2}')
if [[ -z "${DJ_MS_APP_LABEL}" ]]; then
  DJ_MS_APP_LABEL="core"
fi

if [[ ! -f nginx/default.d/${DJ_MS_APP_LABEL}.conf ]]; then
  cp nginx/default.d/app-locations.conf nginx/default.d/"${DJ_MS_APP_LABEL}".conf
  DJANGO_WEB_PORT=$(grep DJANGO_WEB_PORT .env | xargs | awk -F "=" '{print $2}')
  if [[ $DJ_MS_APP_LABEL == 'core' ]]; then
    sed_alt -i "s|DJ_MS_APP_LABEL/||g" nginx/default.d/"${DJ_MS_APP_LABEL}".conf
    sed_alt -i "s|DJANGO_WEB_PORT|$DJANGO_WEB_PORT|g" nginx/default.d/"${DJ_MS_APP_LABEL}".conf
  else
    sed_alt -i "s/DJ_MS_APP_LABEL/$DJ_MS_APP_LABEL/g" nginx/default.d/"${DJ_MS_APP_LABEL}".conf
    sed_alt -i "s/DJANGO_WEB_PORT/$DJANGO_WEB_PORT/g" nginx/default.d/"${DJ_MS_APP_LABEL}".conf
  fi

  echo "
  Created nginx/default.d/${DJ_MS_APP_LABEL}.conf.
  Copy it to /etc/nginx/default.d/ manually and reload Nginx:

  > cp nginx/default.d/${DJ_MS_APP_LABEL}.conf /etc/nginx/default.d/${DJ_MS_APP_LABEL}.conf
  > nginx -s reload

  Tip: If you want to recreate the file, delete it and run this script again:

  > rm nginx/default.d/${DJ_MS_APP_LABEL}.conf
  > ./deploy.sh -n
  "
fi

