#!/bin/sh

default_directory() {
  local dirpath=""

  if [ -n "${XDG_DATA_HOME}" ]
  then
    dirpath="${XDG_DATA_HOME}/vim-dev_go2go"
  else
    dirpath="${HOME}/.local/share/vim-dev_go2go"
  fi

  echo "${dirpath}"
}

update_all() {
  local target_dir="${1}"

  if [ -z "${target_dir}"]
  then
    target_dir="$(default_directory)"
  fi

  mkdir -p "${target_dir}"
  if [ $? -ne 0 ]
  then
    echo "failed to mkdir: ${target_dir}" 1>&2
    return 1
  fi

  if [ ! -d "${target_dir}/.git" ]
  then
    git clone --depth 1 --branch dev.go2go --single-branch https://github.com/golang/go.git "${target_dir}"
  fi

  cd "${target_dir}/src"
  if [ $? -ne 0 ]
  then
    echo "failed to chdir: ${target_dir}/src" 1>&2
    return 1
  fi

  git pull

  ./make.bash
  if [ $? -ne 0 ]
  then
    echo 'failed to run make.bash' 1>&2
    return 1
  fi

  cd ..

  export GOROOT="$(pwd)"
  export GOBIN="${GOROOT}/bin"
  export GO111MODULE=on
  export PATH="${GOBIN}:${PATH}"

  cd src/cmd/go2go
  if [ $? -ne 0 ]
  then
    echo 'failed to chdir: src/cmd/go2go' 1>&2
    return 1
  fi

  go build
  go clean -modcache

  if [ -e 'go2go' ]
  then
    mv go2go "${GOBIN}"
  else
    echo 'failed to build: go2go' 1>&2
    return 1
  fi

  cd "${GOBIN}"
  go get golang.org/x/tools/gopls@dev.go2go golang.org/x/tools@dev.go2go
  go clean -modcache

  if [ ! -e 'gopls' ]
  then
    echo 'failed to build: gopls' 1>&2
    return 1
  fi
}

print_usage() {
  cat << EOM
Usage: $(basename "${0}") all [directory]

[directory]
	default: ~/.local/share/vim-dev_go2go
EOM
}

main() {
  case $1 in
    all )
      shift
      update_all "${@}"
      exit $?
      ;;
    help )
      print_usage
      exit 1
      ;;
    * )
      if [ -z "${1}" ]
      then
        print_usage
        exit 1
      fi
      echo "unknown command: ${1}" 1>&2
      exit 1
  esac
}

[ "$(basename "${0}")" = 'dev_go2go.sh' ] && main "${@}"
