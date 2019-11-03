#
# Usage:
# bats -rt .
#

function setup {
  export TIMESTAMP=`date +%s`
  export TEST_FILE_DIR="$BATS_TMPDIR/tests/$TIMESTAMP"
  mkdir -p "$TEST_FILE_DIR"
  docker build -t centos7_tests $BATS_TEST_DIRNAME/../../images/centos7
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

function teardown {
  #Removing tmp directory
  rm "$TEST_FILE_DIR"
  local _container_id=`docker ps -a -q --filter ancestor=centos7_tests --format="{{.ID}}"`
  if [ -n "$_container_id" ]; then
    docker rm $(docker stop $_container_id)
  fi
}