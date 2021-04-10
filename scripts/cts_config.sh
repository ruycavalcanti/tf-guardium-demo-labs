#!/usr/bin/expect

set timeout 20

set cmd [lrange $argv 18 end]
set continue [lindex $argv 0]
set license [lindex $argv 1]
set main [lindex $argv 2]
set system [lindex $argv 3]
set up [lindex $argv 4]
set vae [lindex $argv 5]
set register [lindex $argv 6]
set up2 [lindex $argv 7]
set cluster [lindex $argv 8]
set addcluster [lindex $argv 9]
set createcluster [lindex $argv 10]
set username [lindex $argv 11]
set password [lindex $argv 12]
set confirmpassword [lindex $argv 13]
set up3 [lindex $argv 14]
set system2 [lindex $argv 15]
set reboot [lindex $argv 16]
set confirmreboot [lindex $argv 17]

eval spawn $cmd
expect "Press any key to continue"
sleep 2
send "$continue";
expect "Do you accept this license agreement"
sleep 2
send "$license\r";
expect "main>"
sleep 2
send "$main\r";
expect "system>"
sleep 2
send "$system\r";
expect "SUCCESS: Setting hostname"
sleep 2
send "$up\r";
expect "main>"
sleep 2
send "$vae\r";
expect "vae>"
sleep 2
send "$register\r";
expect "Node has been registered to DSM"
sleep 2
send "$up2\r";
expect "main>"
sleep 2
send "$cluster\r";
expect "cluster>"
sleep 2
send "$addcluster\r";
expect "registered to this node"
sleep 2
send "$createcluster\r";
expect "Username"
sleep 2
send "$username\r";
expect "Email address"
send "\r";
expect "Password:"
sleep 2
send "$password\r";
expect "Password"
sleep 2
send "$confirmpassword\r";
expect "SUCCESS: Creating cluster"
sleep 2
send "$up3\r";
expect "main>"
sleep 2
send "$system2\r";
expect "system>"
sleep 2
send "$reboot\r";
expect "reboot"
sleep 2
send "$confirmreboot\r";

interact
