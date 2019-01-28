#!/usr/bin/env bash

WORK_DIR=$(git rev-parse --show-toplevel)

if ls $WORK_DIR/output/*.zip 1> /dev/null 2>&1; then
    rm $WORK_DIR/output/*.zip
fi