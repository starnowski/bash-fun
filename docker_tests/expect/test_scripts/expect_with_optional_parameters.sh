#!/usr/bin/expect --

package require cmdline

set options {
    {a          "set the atime only"}
    {b          "set the mtime only"}
    {r.arg  ""  "use time from ref_file"}
    {q.arg  -1  "use specified time"}
    {longOption.arg  "someDefaultValue"  "use string value"}
    {longOption2.arg  "someDefaultValue"  "use string value"}
}
set usage ": MyCommandName \[options] filename ...\noptions:"
array set params [::cmdline::getoptions argv $options $usage]


#if {  $params(a) } { set set_atime "true" }
#    set has_t [expr {$params(t) != -1}]
#    set has_r [expr {[string length $params(r)] > 0}]
#if {$has_t && $has_r} {
#    return -code error "Cannot specify both -r and -t"
#} elseif {$has_t} {
#    puts "T option was passed"
#    return 1
#}

if {  $params(a) } { puts "Parameter 'a' was passed" }
if {  $params(b) } {
    puts "Parameter 'b' was passed"
} else {
    puts "Parameter 'b' was not passed"
}
if {  $params(r) } {
    puts "Parameter 'r' was passed with value $params(r)"
} else {
    puts "Parameter 'r' was not passed"
}
if {  $params(q) } {
    puts "Parameter 'q' has value $params(q)"
} else {
    puts "Parameter 'q' was not passed"
}
if {  $params(longOption) != "" } {
    puts "Parameter 'longOption' has value $params(longOption)"
} else {
    puts "Parameter 'longOption' was not passed"
}
if {  $params(longOption2) != "" } {
    puts "Parameter 'longOption2' has value $params(longOption2)"
} else {
    puts "Parameter 'longOption2' was not passed"
}