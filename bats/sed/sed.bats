#
# Usage:
# bats -rt .
#

function setup {
  export TIMESTAMP=`date +%s`
  mkdir -p $BATS_TMPDIR/$TIMESTAMP
}

@test "the 'prop1.properties' test file should have correct data" {
    # given
    [ -e "$BATS_TEST_DIRNAME/test_files/prop1.properties" ]

    # when
    run cat "$BATS_TEST_DIRNAME/test_files/prop1.properties"

    # then
    echo "output:->" >&3
    echo "$output" >&3
    echo "<-output:" >&3
    [ "$status" -eq 0 ]
    [ "${lines[0]}" == "username=Szymon" ]
    [ "${lines[1]}" == "usernickname=Simon" ]
}

@test "the 'prop2.properties' test file should have correct data" {
    # given
    [ -e "$BATS_TEST_DIRNAME/test_files/prop2.properties" ]

    # when
    run cat "$BATS_TEST_DIRNAME/test_files/prop2.properties"

    # then
    echo "output:->" >&3
    echo "$output" >&3
    echo "<-output:" >&3
    [ "$status" -eq 0 ]
    [ "${lines[0]}" == "username = Szymon" ]
    [ "${lines[1]}" == 'regions    =      ap-southeast-1   , us-west-2 ###' ]
    [ "${lines[2]}" == 'ec2_states  = pending' ]
}

@test "should replace first line" {
    # given
    cp "$BATS_TEST_DIRNAME/test_files/prop1.properties" $BATS_TMPDIR/$TIMESTAMP

    # when
    run sed -i -e 's/username=Szymon/username=Dawid/' "$BATS_TMPDIR/$TIMESTAMP/prop1.properties"

    # then
    echo "output:->" >&3
    echo "$output" >&3
    echo "<-output:" >&3
    [ "$status" -eq 0 ]
    run cat "$BATS_TMPDIR/$TIMESTAMP/prop1.properties"
    echo "output file:->" >&3
    echo "$output" >&3
    echo "<-output file:" >&3
    [ "$status" -eq 0 ]
    [ "${lines[0]}" == "username=Dawid" ]
    [ "${lines[1]}" == "usernickname=Simon" ]
}


@test "should replace line with regex pattern with groups" {
    # given
    cp "$BATS_TEST_DIRNAME/test_files/prop2.properties" $BATS_TMPDIR/$TIMESTAMP

    # when
    run sed -i -E "s/^regions(\\s*)=(\\s*)ap-southeast-1(.*)/regions\1=\2eu-west-1\3/" "$BATS_TMPDIR/$TIMESTAMP/prop2.properties"
    run sed -i -E "s/(<username>.+)name(.+<\/username>)/\1something\2/" "$BATS_TMPDIR/$TIMESTAMP/prop2.properties"

    # then
    echo "output:->" >&3
    echo "$output" >&3
    echo "<-output:" >&3
    [ "$status" -eq 0 ]
    run cat "$BATS_TMPDIR/$TIMESTAMP/prop2.properties"
    echo "output file:->" >&3
    echo "$output" >&3
    echo "<-output file:" >&3
    [ "$status" -eq 0 ]
    [ "${lines[0]}" == "username = Szymon" ]
    [ "${lines[1]}" == 'regions    =      eu-west-1   , us-west-2 ###' ]
    [ "${lines[2]}" == 'ec2_states  = pending' ]
}


function teardown {
    rm -rf $BATS_TMPDIR/$TIMESTAMP
}