#!/usr/bin/env bash

WORK_DIR=$(git rev-parse --show-toplevel)

if ls $WORK_DIR/build 1> /dev/null 2>&1; then
    rm -rf $WORK_DIR/build
fi

if [ -d "$WORK_DIR/docker/bundle.zip" ]; then
  rm $WORK_DIR/docker/bundle.zip;
fi