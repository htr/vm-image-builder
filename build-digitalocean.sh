#!/usr/bin/env bash

exec docker run --rm -ti --privileged -e USERID=$(id -u) -e GROUPID=$(id -g) -v $(pwd)/artifacts:/artifacts:ro -v $(pwd)/output:/output nixos/nix /artifacts/build.sh -s 10 -d
