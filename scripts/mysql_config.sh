#!/usr/bin/expect

set timeout 20

set cmd [lrange $argv 9 end]
set confirm [lindex $argv 0]
set level [lindex $argv 1]
set newpass [lindex $argv 2]
set confnewpass [lindex $argv 3]
set confirm2 [lindex $argv 4]
set remove [lindex $argv 5]
set remote [lindex $argv 6]
set testdb [lindex $argv 7]
set reload [lindex $argv 8]

eval spawn $cmd
expect "any other key for No"
send "$confirm\r";
expect "Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG"
send "$level\r";
expect "New password"
send "$newpass\r";
expect "Re-enter new password"
send "$confnewpass\r";
expect "Do you wish to continue with the password provided"
send "$confirm2\r";
expect "Remove anonymous users"
send "$remove\r";
expect "Disallow root login remotely"
send "$remote\r";
expect "Remove test database and access to it"
send "$testdb\r";
expect "Reload privilege tables now"
send "$reload\r";
interact
