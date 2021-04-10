#!/bin/bash
ip=$1
hostname=$2
desc=$3
agent_type=$4
domain=$5

curl --location --request POST 'https://'${ip}'/dsm/v1/domains/'${domain}'/hosts' \
--header 'Authorization: Basic c3VwZXJhZG1pbjpHdWFyZGl1bSMxMjM=' \
--header 'Content-Type: application/json' \
--data-raw '{
    "hostName" : "'${hostname}'",
    "description" : "'"${desc}"'",
    "licenseType" : "TERM",
    "registrableAgents" : [ "'${agent_type}'" ],
    "authentication" : {
        "method" : "CHALLENGE_RESPONSE",
        "regenerate" : true
    },
    "autoAssignsServer" : true,
    "enabled" : true
}' --insecure
