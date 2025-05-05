#!/bin/bash

set -e
cmd() {
  echo "+ $@"
  eval "$@"
}

cmd "export EXAWIND_MANAGER=${HOME}/exawind/exawind-manager"
cmd "source ${EXAWIND_MANAGER}/start.sh && spack-start"
cmd "spack env activate -d ${EXAWIND_MANAGER}/environments/exawind-dev-cuda"
cmd "spack load exawind"

turbines=("T0" "T1" "T2" "T3")

for dir in blades*/; do
  echo "Entering $dir"
  cd "$dir" || exit 1

  for tx in "${turbines[@]}"; do
    if compgen -G "blades_${tx}.exo.*.*" > /dev/null; then
      if [ ! -f "blades_${tx}.exo" ]; then
        echo "  Running epu on blades_${tx}"
        epu --auto "blades_${tx}.exo"
      else
        echo "  blades_${tx}.exo already exists, skipping epu"
      fi
    fi
  done

  cd ..
done
