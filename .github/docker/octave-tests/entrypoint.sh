#!/bin/bash -l

# This script runs the tests with or without covering

echo "Executing entrypoint.sh"

echo argument=$1

# display current folder
pwd
ls -al

git rev-parse HEAD

export ADDPATH_COMMAND=""

export BUILD_BINARIES="make;";
echo "BUILD_BINARIES| $BUILD_BINARIES";

export COVERING=true
export TEST_COMMAND="exit(~run_tests($COVERING,1));";
echo "TEST_COMMAND| $TEST_COMMAND";

# Check GCC version
gcc --version

# Check what octave packages we have installed
octave -q --eval "ver"

# Check if octave can access java
octave --eval "b = javaMethod('valueOf', 'java.math.BigInteger', 2)"

# Remove any cached results files from previous build, if present
rm -f testresults.xml;

# Run tests
if octave -q --eval "$ADDPATH_COMMAND $BUILD_BINARIES $TEST_COMMAND"; then
  # Check where we ended up and what's going on where we are
  pwd
  ls -alh
  ls -alh gem
  if [ $COVERING == true ]; then
    bash <(curl -s https://codecov.io/bash);
  fi
else
  # The tests did not pass
  exit 1
fi
