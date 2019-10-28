#
# Usage:
# bats -rt .
#

function setup {
  export TIMESTAMP=`date +%s`
}

@test "should export environment variables to execution of 'bash -lc'" {
    # given
    export TEST_VALUE="This is test value"

    # when
    run bash -lc "echo $TEST_VALUE"

    # then
    echo "output:->" >&3
    echo "$output" >&3
    echo "<-output:" >&3
    [ "$status" -eq 0 ]
    [ "${lines[0]}" == "$TEST_VALUE" ]
}