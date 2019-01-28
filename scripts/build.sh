#!/usr/bin/env bash
REPO_WORK_DIR="$(git rev-parse --show-toplevel)/"

docker build -t tech.form3/terraform-bundle $REPO_WORK_DIR/terraform-bundle

docker run \
    --volume $REPO_WORK_DIR/output:/output \
    --env-file $REPO_WORK_DIR/.env \
    tech.form3/terraform-bundle
