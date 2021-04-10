#!/usr/bin/expect

set timeout 20

set cmd [lrange $argv 9 end]
set password [lindex $argv 0]
set maint [lindex $argv 1]
set timezone [lindex $argv 2]
set up [lindex $argv 3]
set system [lindex $argv 4]
set setinfo [lindex $argv 5]
set sign [lindex $argv 6]
set cont [lindex $argv 7]
set fim [lindex $argv 8]

eval spawn $cmd
expect "password:"
send "$password\r";
expect "0000:dsm"
send "$maint\r";
expect "0001:maintenance"
send "$timezone\r";
expect "0002:maintenance"
send "$up\r";
expect "0003:dsm"
send "$system\r";
expect "0004:system"
send "$setinfo\r";
expect "0005:system"
send "$sign\r";
expect "Continue"
send "$cont\r";
expect "This Security Server host name"
send "\r";
expect "What is the name of your organizational unit"
send "\r";
expect "What is the name of your organization"
send "\r";
expect "What is the name of your City or Locality"
send "\r";
expect "What is the name of your State or Province"
send "\r";
expect "What is your two-letter country code"
send "\r";
expect "What is your email address"
send "\r";
expect "What is the validity period of the generated certificate"
send "\r";
expect "0006:system"
send "$fim\r";
interact
