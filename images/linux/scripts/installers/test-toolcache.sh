#!/bin/bash
################################################################################
##  File:  test-toolcache.sh
##  Team:  CI-Platform
##  Desc:  Test Python and Ruby versions in tools cache
################################################################################

# Must be procecessed after tool cache setup(hosted-tool-cache.sh).

# Fail out if any tests fail
set -e

AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache

# Python test
if [ -d "$AGENT_TOOLSDIRECTORY/Python" ]; then
   cd $AGENT_TOOLSDIRECTORY/Python
   python_dirs=($(ls -d */))
   echo "Python versions folders: ${python_dirs[@]}"
   echo "------------------------------------------"
   for version_dir in "${python_dirs[@]}"
   do
      echo "Test $AGENT_TOOLSDIRECTORY/Python/$version_dir:"
      expected_ver=$(echo $version_dir | egrep -o '[0-9]+\.[0-9]+')
      actual_ver=$($AGENT_TOOLSDIRECTORY/Python/$version_dir/x64/python -c 'import sys;print(sys.version)'| head -1 | egrep -o '[0-9]+\.[0-9]+')

      if [ "$expected_ver" = "$actual_ver" ]; then
            echo "Passed!"
      else
            echo "Expected: $expected_ver; Actual: $actual_ver"
            exit 1
      fi
   done
else
   echo "$AGENT_TOOLSDIRECTORY/Python does not exist"
   exit 1
fi

# Ruby test
if [ -d "$AGENT_TOOLSDIRECTORY/Ruby" ]; then
   cd $AGENT_TOOLSDIRECTORY/Ruby
   ruby_dirs=($(ls -d */))
   echo "Ruby versions folders: ${ruby_dirs[@]}"
   echo "--------------------------------------"
   for version_dir in "${ruby_dirs[@]}"
   do
      echo "Test $AGENT_TOOLSDIRECTORY/Ruby/$version_dir:"
      expected_ver=$(echo $version_dir | egrep -o '[0-9]+\.[0-9]+')
      actual_ver=$($AGENT_TOOLSDIRECTORY/Ruby/$version_dir/x64/bin/ruby -e "puts RUBY_VERSION" | egrep -o '[0-9]+\.[0-9]+')

      if [ "$expected_ver" = "$actual_ver" ]; then
         echo "Passed!"
      else
         echo "Expected: $expected_ver; Actual: $actual_ver"
         exit 1
      fi
   done
else
   echo "$AGENT_TOOLSDIRECTORY/Ruby does not exist"
   # exit 1 It's temporary mock until Ruby added to toolcache
fi
