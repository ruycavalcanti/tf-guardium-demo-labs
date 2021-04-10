#!/usr/bin/expect

set timeout 20

set cmd [lrange $argv 7 end]
set password [lindex $argv 0]
set encrypt [lindex $argv 1]
set scroll [lindex $argv 2]
set license [lindex $argv 3]
set newpass [lindex $argv 4]
set confnewpass [lindex $argv 5]
set fim [lindex $argv 6]

eval spawn $cmd
expect "password:"
send "$password\r";
expect "Do you want to re-encrypt the disk now?"
send "$encrypt\r";
expect "means any of Thales"
send "$scroll";
expect "Do you accept the terms of the above license agreement"
send "$license\r";
expect "Enter new password"
send "$newpass\r";
expect "Enter password again"
send "$confnewpass\r";
expect "0000:dsm"

send "$fim\r";
interact
