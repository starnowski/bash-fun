#
# Usage:
# bats -rt .
#

function setup {
  export TIMESTAMP=`date +%s`
  export TEST_FILE_DIR="$BATS_TMPDIR/tests/$TIMESTAMP"
  mkdir -p "$TEST_FILE_DIR"
  docker build -t centos7_tests $BATS_TEST_DIRNAME/../../images/centos7 >&3
}

@test "should ask 'yes' or 'no' question and register 'yes' reply" {

    # when
    run docker run -it --name ansible_server_bats_test -v $BATS_TMPDIR/$TIMESTAMP:/result_dir -v $BATS_TEST_DIRNAME/test_scripts:/test_scripts --rm centos7_tests  /test_scripts/answer_question.sh  /test_scripts/ask.sh y

    # then
    echo "output:-->" >&3
    echo "$output" >&3
    echo "<--:output" >&3
    echo "${lines[0]}"
    [ "$status" -eq "0" ]
    [[ "${lines[0]}" =~ "spawn /test_scripts/ask.sh" ]]
    [[ "${lines[1]}" =~ "Are you sure? [y/N] y" ]]
    [[ "${lines[2]}" =~ "The response was positive: y" ]]
}

@test "should ask 'yes' or 'no' question and register 'no' reply" {

    # when
    run docker run -it --name ansible_server_bats_test -v $BATS_TMPDIR/$TIMESTAMP:/result_dir -v $BATS_TEST_DIRNAME/test_scripts:/test_scripts --rm centos7_tests  /test_scripts/answer_question.sh  /test_scripts/ask.sh n

    # then
    echo "output:-->" >&3
    echo "$output" >&3
    echo "<--:output" >&3
    echo "${lines[0]}"
    [ "$status" -eq "0" ]
    [[ "${lines[0]}" =~ "spawn /test_scripts/ask.sh" ]]
    [[ "${lines[1]}" =~ "Are you sure? [y/N] n" ]]
    [[ "${lines[2]}" =~ "The response was negative: n" ]]
}

@test "should print message about passed parameters, 'a', 'r' and 'longOption'" {
    # when
    run docker run -it --name ansible_server_bats_test -v $BATS_TMPDIR/$TIMESTAMP:/result_dir -v $BATS_TEST_DIRNAME/test_scripts:/test_scripts --rm centos7_tests  /test_scripts/expect_with_optional_parameters.sh  -a -r 33 -longOption "passed_value_${TIMESTAMP}"

    # then
    echo "output:-->" >&3
    echo "$output" >&3
    echo "<--:output" >&3
    [ "$status" -eq "0" ]
    [[ "${lines[0]}" =~ "Parameter 'a' was passed" ]]
    [[ "${lines[1]}" =~ "Parameter 'b' was not passed" ]]
    [[ "${lines[2]}" =~ "Parameter 'r' was passed with value 33" ]]
    [[ "${lines[3]}" =~ "Parameter 'q' was not passed" ]]
    [[ "${lines[4]}" =~ "Parameter 'longOption' was passed with value passed_value_${TIMESTAMP}" ]]
    [[ "${lines[5]}" =~ "Parameter 'longOption2' was not passed" ]]
}

function teardown {
  #Removing tmp directory
  rm -rf "$TEST_FILE_DIR"
  local _container_id=`docker ps -a -q --filter ancestor=centos7_tests --format="{{.ID}}"`
  if [ -n "$_container_id" ]; then
    docker rm $(docker stop $_container_id)
  fi
}