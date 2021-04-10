#!/bin/bash
ip=$1

curl --location --request POST 'https://'${ip}'/dsm/v1/domains/1001/keys/symmetric' \
--header 'Authorization: Basic c3VwZXJhZG1pbjpHdWFyZGl1bSMxMjM=' \
--header 'Content-Type: application/json' \
--data-raw '{
    "id" : 1001,
    "description" : "Symmetric LDT Key Created By Terraform",
    "name" : "LDT-AES-256-CTE",
    "algorithm" : "AES256",
    "encryptionMode" : "CBC",
    "kmipAccessible" : false,
    "keyUsageType" : "CACHED_ON_HOST",
    "expirationTime" : "2030-07-31T17:18:37.085Z",
    "keyVersionLifeSpan" : 180
}' --insecure
curl --location --request POST 'https://'${ip}'/dsm/v1/domains/1065/keys/symmetric' \
--header 'Authorization: Basic c3VwZXJhZG1pbjpHdWFyZGl1bSMxMjM=' \
--header 'Content-Type: application/json' \
--data-raw '{
    "id" : 1002,
    "description" : "Symmetric CTS Key Created By Terraform",
    "name" : "CTS-AES-128",
    "algorithm" : "AES128",
    "encryptionMode" : "CBC",
    "kmipAccessible" : false,
    "keyUsageType" : "STORED_ON_SERVER",
    "keyTemplateName" : "Default_SQL_Symmetric_Key_Template"
}' --insecure
curl --location --request PUT 'https://'${ip}'/dsm/v1/domains/1065/keys/symmetric/1129' \
--header 'Authorization: Basic c3VwZXJhZG1pbjpHdWFyZGl1bSMxMjM=' \
--header 'Content-Type: application/json' \
--data-raw '{
"keyUsageType" : "CACHED_ON_HOST"
}' --insecure
curl --location --request POST 'https://'${ip}'/dsm/v1/domains/1001/processsets' \
--header 'Authorization: Basic c3VwZXJhZG1pbjpHdWFyZGl1bSMxMjM=' \
--header 'Content-Type: application/json' \
--data-raw '{
    "id" : 1001,
    "name" : "Mysql_Linux",
    "description" : "Processos Mysql Linux",
    "processes" : [ {
        "directory" : "/usr/bin",
        "baseName" : "mysql*"
    },
    {
        "directory" : "/usr/sbin",
        "baseName" : "mysqld"
    } ]
}' --insecure
curl --location --request POST 'https://'${ip}'/dsm/v1/domains/1001/usersets' \
--header 'Authorization: Basic c3VwZXJhZG1pbjpHdWFyZGl1bSMxMjM=' \
--header 'Content-Type: application/json' \
--data-raw '{
    "id" : 1001,
    "name" : "Linux_Autorizados",
    "description" : "Usuarios Autorizados Linux",
    "users" : [ {
        "uId" : 1000,
        "uName" : "ubuntu"
    } ]
}' --insecure
curl --location --request POST 'https://'${ip}'/dsm/v1/domains/1001/policies/ldt' \
--header 'Authorization: Basic c3VwZXJhZG1pbjpHdWFyZGl1bSMxMjM=' \
--header 'Content-Type: application/json' \
--data-raw '{
    "id" : 1001,
    "name" : "Linux-MySql",
    "description" : "MySql LDT policy for Linux",
    "policyType" : "LDT",
    "learnMode" : true,
    "securityRules" : [{
        "order" : 1,
        "allowBrowsing" : false,
        "effects" : [ "PERMIT", "APPLY_KEY" ],
        "actions" : [ "KEY_OPERATIONS" ]
    },
    {
        "order" : 2,
        "allowBrowsing" : true,
        "processset" : {
            "id" : 1001,
            "exclude" : false
        },
        "effects" : [ "PERMIT", "APPLY_KEY" ],
        "actions" : [ "ALL_OPERATIONS" ]
    },
    {
        "order" : 3,
        "allowBrowsing" : true,
        "effects" : [ "PERMIT" ],
        "actions" : [ "READ_OPERATIONS" ]
    },
    {
        "order" : 4,
        "allowBrowsing" : true,
        "effects" : [ "DENY", "AUDIT", "APPLY_KEY" ],
        "actions" : [ "ALL_OPERATIONS" ]
    } ],
    "keyRules" : [ {
        "order" : 1,
        "keyID" : 1,
        "transformationKeyID" : 1001,
        "exclude" : false
    } ]
}' --insecure
curl --location --request POST 'https://'${ip}'/dsm/v1/domains/1001/policies/ldt' \
--header 'Authorization: Basic c3VwZXJhZG1pbjpHdWFyZGl1bSMxMjM=' \
--header 'Content-Type: application/json' \
--data-raw '{
    "id" : 1002,
    "name" : "Linux-Ransomware",
    "description" : "Ransomware policy for Linux",
    "policyType" : "LDT",
    "learnMode" : false,
    "securityRules" : [{
        "order" : 1,
        "allowBrowsing" : false,
        "effects" : [ "PERMIT", "APPLY_KEY" ],
        "actions" : [ "KEY_OPERATIONS" ]
    },
    {
        "order" : 2,
        "allowBrowsing" : true,
        "effects" : [ "PERMIT" ],
        "actions" : [ "READ_FILE_ATTRIBUTE", "READ_FILE_SECURITY", "READ_DIRECTORY", "READ_DIRECTORY_ATTRIBUTE", "READ_DIRECTORY_SECURITY" ]
    },
    {
        "order" : 3,
        "allowBrowsing" : true,
        "userset" : {
            "id" : 1001,
            "exclude" : false
        },
        "effects" : [ "PERMIT", "APPLY_KEY" ],
        "actions" : [ "ALL_OPERATIONS" ]
    },
    {
        "order" : 4,
        "allowBrowsing" : false,
        "effects" : [ "DENY", "AUDIT" ],
        "actions" : [ "ALL_OPERATIONS" ]
    }],
    "keyRules" : [ {
        "order" : 1,
        "keyID" : 1,
        "transformationKeyID" : 1001,
        "exclude" : false
    } ]
}' --insecure
curl --location --request PUT 'https://'${ip}'/dsm/v1/domains/1001/hosts/1001' \
--header 'Authorization: Basic c3VwZXJhZG1pbjpHdWFyZGl1bSMxMjM=' \
--header 'Content-Type: application/json' \
--data-raw '{
    "hostSettings" : [ {
        "keyword" : "authenticator",
        "processPath" : "/usr/sbin/sshd"
    },
    {
        "keyword" : "authenticator",
        "processPath" : "/usr/sbin/in.rlogind"
    },
    {
        "keyword" : "authenticator",
        "processPath" : "/bin/login"
    },
    {
        "keyword" : "authenticator",
        "processPath" : "/usr/bin/gdm-binary"
    },
    {
        "keyword" : "authenticator",
        "processPath" : "/usr/bin/kdm"
    },
    {
        "keyword" : "authenticator_euid",
        "processPath" : "/usr/sbin/vsftpd"
    },
    {
        "keyword" : "su_root_no_auth",
        "processPath" : "/bin/su"
    }]
}' --insecure
curl --location --request POST 'https://'${ip}'/dsm/v1/domains/1001/hosts/1001/guardpoints' \
--header 'Authorization: Basic c3VwZXJhZG1pbjpHdWFyZGl1bSMxMjM=' \
--header 'Content-Type: application/json' \
--data-raw '{
    "hostId" : 1001,
    "policyId" : 1001,
    "guardPointType" : "AUTO_GUARD_DIRECTORY",
    "guardPath" : "/var/lib/mysql",
    "autoMountEnabled" : false,
    "earlyAccess" : false,
    "efficientStorageDevice" : false,
    "idtCapableDevice" : false
}' --insecure
curl --location --request POST 'https://'${ip}'/dsm/v1/domains/1001/hosts/1001/guardpoints' \
--header 'Authorization: Basic c3VwZXJhZG1pbjpHdWFyZGl1bSMxMjM=' \
--header 'Content-Type: application/json' \
--data-raw '{
    "hostId" : 1001,
    "policyId" : 1065,
    "guardPointType" : "AUTO_GUARD_DIRECTORY",
    "guardPath" : "/home/ubuntu/arquivos_muito_importantes_protegidos",
    "autoMountEnabled" : false,
    "earlyAccess" : false,
    "efficientStorageDevice" : false,
    "idtCapableDevice" : false
}' --insecure
