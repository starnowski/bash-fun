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

@test "should print message 'HelloWorld' from custom tcl package" {
    # when
    run docker run -it --name ansible_server_bats_test -v $BATS_TMPDIR/$TIMESTAMP:/result_dir -v $BATS_TEST_DIRNAME/tcl_package:/test_package --rm centos7_tests  /test_package/run_function_from_custom.sh  /test_package

    # then
    echo "output:-->" >&3
    echo "$output" >&3
    echo "<--:output" >&3
    [ "$status" -eq "0" ]
    [[ "${lines[0]}" =~ "HelloWorld" ]]
}

function teardown {
  #Removing tmp directory
  rm -rf "$TEST_FILE_DIR"
  local _container_id=`docker ps -a -q --filter ancestor=centos7_tests --format="{{.ID}}"`
  if [ -n "$_container_id" ]; then
    docker rm $(docker stop $_container_id)
  fi
}