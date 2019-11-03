#!/usr/bin/expect -f

set timeout 5

set test_script_path [lindex $argv 0];
set test_script_answer [lindex $argv 1];

spawn "$test_script_path"

expect "Are you sure? \[y/N\]"

send -- "$test_script_answer\r"

expect eof