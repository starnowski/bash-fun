#
# Usage:
# bats -rt .
#

function setup {
  export TIMESTAMP=`date +%s`
  #List of commands which execute "echo" function
  export COMMANDS_WITH_ECHO="echo \"This is test\";echo this is only tests Script;echo timestamp is $TIMESTAMP"

  export TEST_FILE="$BATS_TMPDIR/test_$TIMESTAMP.sh"
  export TEST_SCRIPT_PATH="$BATS_TEST_DIRNAME/../../wrapCommandsIntoShellScript/wrapCommandsIntoShellScript.sh"
}

@test "Should create wrapped script for list of 'echo' commands" {

  #when
  run "$TEST_SCRIPT_PATH" "$TEST_FILE" "$COMMANDS_WITH_ECHO" >&3

  #then
  echo "output is --> $output <--"  >&3
  [ "$status" -eq 0 ]
  [ -e "$TEST_FILE" ]
  #assert file content
  run cat "$TEST_FILE"
  [ "${lines[0]}" = '#!/bin/bash' ]
  [ "${lines[1]}" = 'echo "This is test";echo this is only tests Script;echo timestamp is $TIMESTAMP' ]
}

function teardown {
  #Removing tmp file
  rm "$TEST_FILE"
}