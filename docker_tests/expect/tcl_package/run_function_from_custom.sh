#!/usr/bin/expect -f

set package_path [lindex $argv 0];
lappend auto_path "$package_path"
package require HelloWorld 1.0
puts [HelloWorld::MyProcedure]