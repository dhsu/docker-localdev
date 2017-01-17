#!/bin/bash
set -e

DIR=$(cd "$(dirname "$0")" && pwd)
SQS_PORT=4568
BOOTSTRAP_DIR=/bootstrap
BOOTSTRAPPED=$DIR/BOOTSTRAPPED

export SQS_ENDPOINT_URL=http://localhost:$SQS_PORT
export AWS_DEFAULT_REGION=us-east-1
export AWS_ACCESS_KEY_ID=fake
export AWS_SECRET_ACCESS_KEY=fake

echo "Starting fake sqs..."
fake_sqs &
FAKE_SQS_PID=$!

echo "Waiting for fake sqs..."
while ! timeout 1 bash -c "echo > /dev/tcp/localhost/$SQS_PORT" 2> /dev/null; do
  sleep 1
done

if [ ! -f "$BOOTSTRAPPED" ]; then
  echo "Bootstrapping from $BOOTSTRAP_DIR..."
  if [ "$(ls -A $BOOTSTRAP_DIR)" ]; then
    for f in $BOOTSTRAP_DIR/*; do
      case "$f" in
        *.sh)   echo "$0: Running $f"; . "$f" ;;
        *)      echo "$0: Ignoring $f" ;;
      esac
      echo
    done
  else
    echo "$BOOTSTRAP_DIR empty"
  fi
  touch $BOOTSTRAPPED
  echo "Bootstrap complete"
else
  echo "Already bootstrapped. Skipping."
fi

wait $FAKE_SQS_PID