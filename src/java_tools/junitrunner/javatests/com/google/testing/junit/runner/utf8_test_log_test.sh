#!/bin/bash
#
# Copyright 2015 The Bazel Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Test that JUnit3 logs are written with UTF-8 encoding.
#

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

TESTBED="${PWD}/$1"
SUITE_PARAMETER="$2"
SUITE_FLAG="-D${SUITE_PARAMETER}=com.google.testing.junit.runner.testbed.InternationalCharsTest"
unset TEST_PREMATURE_EXIT_FILE

shift 2
source ${DIR}/testenv.sh || { echo "testenv.sh not found!" >&2; exit 1; }

# Usage: expect_log <literal>
function expect_log() {
  grep -q -F "$1" $TEST_log ||
    fail "Could not find \"$1\" in \"$(cat $TEST_log)\""
}

function test_utf8_log() {
  $TESTBED --jvm_flag=${SUITE_FLAG} > $TEST_log && fail "Expected failure"
  expect_log 'expected:<Test [Japan].> but was:<Test [日本].>'
}

run_suite "utf8_test_log"