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
    docker run --name ansible_server_bats_test -v $BATS_TMPDIR/$TIMESTAMP:/result_dir -v $BATS_TEST_DIRNAME/test_scripts:/test_scripts --rm centos7_tests  /test_scripts/ask.sh

    # then
    echo "output:-->" >&3
    echo "$output" >&3
    echo "<--:output" >&3
    [ "$status" -eq 0 ]
}

function teardown {
  #Removing tmp directory
  rm "$TEST_FILE_DIR"
  docker rm $(docker stop $(docker ps -a -q --filter ancestor=centos7_tests --format="{{.ID}}"))
}