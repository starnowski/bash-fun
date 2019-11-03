#!/usr/bin/expect --

package require cmdline

set options {
    {a          "set the atime only"}
    {m          "set the mtime only"}
    {c          "do not create non-existent files"}
    {r.arg  ""  "use time from ref_file"}
    {t.arg  -1  "use specified time"}
}
set usage ": MyCommandName \[options] filename ...\noptions:"
array set params [::cmdline::getoptions argv $options $usage]


if {  $params(a) } { set set_atime "true" }
    set has_t [expr {$params(t) != -1}]
    set has_r [expr {[string length $params(r)] > 0}]
if {$has_t && $has_r} {
    return -code error "Cannot specify both -r and -t"
} elseif {$has_t} {
    puts "T option was passed"
    return 1
}