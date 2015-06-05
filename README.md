# all-scripts
all-scripts/
├── 01-shell
│   └── all-proxy
│       ├── 01-shell
│       │   └── 01-wordpress
│       ├── aws-scripts
│       ├── dg-proxy
│       ├── erp-scripts
│       │   ├── jenkins
│       │   └── sh_51
│       ├── hz-proxy
│       ├── proxy-scripts
│       │   └── haproxy
│       ├── rpms
│       ├── sh-proxy
│       │   ├── keys_proxy
│       │   ├── sh_41_proxy
│       │   ├── sh_49_proxy
│       │   ├── sh_50
│       │   └── sh_51
│       └── sz-proxy
│           ├── sz_15_proxy
│           └── sz_16_proxy
├── 02-python
└── devops-all
    ├── deployer
    │   ├── puppet
    │   │   ├── manifests
    │   │   └── modules
    │   │       └── deployer
    │   │           ├── files
    │   │           └── templates
    │   └── stages
    │       └── common
    ├── devops
    │   └── modules
    │       ├── hz-script
    │       ├── lestore-compiler
    │       │   ├── scripts
    │       │   │   ├── nginx-1.2.6
    │       │   │   └── php-5.3.20
    │       │   └── stages
    │       │       └── common
    │       ├── lestore-db
    │       │   ├── filter
    │       │   ├── puppet
    │       │   │   ├── manifests
    │       │   │   └── modules
    │       │   │       └── testdb
    │       │   │           └── files
    │       │   ├── sql
    │       │   │   └── test.init
    │       │   └── stages
    │       │       └── common
    │       ├── lestore-logman
    │       │   ├── puppet
    │       │   │   ├── manifests
    │       │   │   └── modules
    │       │   │       └── logman
    │       │   │           └── templates
    │       │   │               └── crontabs
    │       │   └── stages
    │       │       ├── common
    │       │       ├── js-prod
    │       │       └── zz-prod
    │       ├── lestore-monitor
    │       │   ├── puppet
    │       │   │   └── manifests
    │       │   └── stages
    │       │       └── common
    │       ├── lestore-ops
    │       │   └── stages
    │       │       └── common
    │       ├── lestore-sr
    │       │   ├── materials
    │       │   ├── puppet
    │       │   │   └── modules
    │       │   │       └── sr
    │       │   │           └── files
    │       │   │               └── s3cmd-1.5.0-beta1
    │       │   │                   └── S3
    │       │   ├── stages
    │       │   │   ├── common
    │       │   │   ├── vb-prod
    │       │   │   └── zz-prod
    │       │   └── watermarks
    │       ├── lestore-ssd
    │       │   ├── puppet
    │       │   │   └── manifests
    │       │   └── stages
    │       │       ├── common
    │       │       └── zz-prod
    │       ├── lestore-stack
    │       │   └── stages
    │       │       ├── am-prod
    │       │       ├── am-search-prod
    │       │       ├── am-search-test
    │       │       ├── aws-init-jjsbak
    │       │       │   └── aws
    │       │       │       ├── config_repo_tmpl
    │       │       │       │   ├── cms
    │       │       │       │   │   └── config
    │       │       │       │   │       └── cms-prod
    │       │       │       │   │           ├── keys
    │       │       │       │   │           └── nginx
    │       │       │       │   │               └── ssl
    │       │       │       │   ├── editor
    │       │       │       │   │   └── config
    │       │       │       │   │       └── editor-prod
    │       │       │       │   │           └── nginx
    │       │       │       │   │               └── ssl
    │       │       │       │   ├── esmeralda-editor
    │       │       │       │   │   └── config
    │       │       │       │   │       └── v5_editor-prod
    │       │       │       │   ├── jjshouse
    │       │       │       │   │   └── config
    │       │       │       │   │       └── js-prod
    │       │       │       │   │           └── nginx
    │       │       │       │   │               └── ssl
    │       │       │       │   ├── lestore-logman
    │       │       │       │   │   └── config
    │       │       │       │   │       └── js-prod
    │       │       │       │   ├── lestore-search
    │       │       │       │   │   └── config
    │       │       │       │   │       └── jjshouse-search-prod
    │       │       │       │   ├── lestore-sr
    │       │       │       │   │   └── config
    │       │       │       │   │       └── js-prod
    │       │       │       │   ├── lestore-ssd
    │       │       │       │   │   └── config
    │       │       │       │   │       └── js-prod
    │       │       │       │   │           └── pem
    │       │       │       │   ├── lestore-stack
    │       │       │       │   │   └── config
    │       │       │       │   │       └── common
    │       │       │       │   ├── lestore-vm
    │       │       │       │   │   └── config
    │       │       │       │   │       └── common
    │       │       │       │   ├── newsletter
    │       │       │       │   │   └── config
    │       │       │       │   │       └── nl-prod
    │       │       │       │   │           └── nginx
    │       │       │       │   │               └── ssl
    │       │       │       │   ├── osticket
    │       │       │       │   │   ├── config
    │       │       │       │   │   │   └── osticket-prod
    │       │       │       │   │   │       └── nginx
    │       │       │       │   │   │           └── ssl
    │       │       │       │   │   └── js-front
    │       │       │       │   ├── search
    │       │       │       │   │   └── config
    │       │       │       │   │       └── jjshouse-search-prod
    │       │       │       │   └── v5
    │       │       │       │       └── config
    │       │       │       │           └── v5-prod
    │       │       │       │               └── jjs
    │       │       │       │                   ├── etc
    │       │       │       │                   └── nginx
    │       │       │       │                       └── ssl
    │       │       │       └── keys
    │       │       ├── aws-init-vb
    │       │       │   └── aws
    │       │       │       ├── config_repo_tmpl
    │       │       │       │   ├── cms
    │       │       │       │   │   └── config
    │       │       │       │   │       └── cms-prod
    │       │       │       │   │           ├── keys
    │       │       │       │   │           └── nginx
    │       │       │       │   │               └── ssl
    │       │       │       │   ├── editor
    │       │       │       │   │   └── config
    │       │       │       │   │       └── editor-prod
    │       │       │       │   │           └── nginx
    │       │       │       │   │               └── ssl
    │       │       │       │   ├── esmeralda-editor
    │       │       │       │   │   └── config
    │       │       │       │   │       └── v5_editor-prod
    │       │       │       │   ├── lestore-logman
    │       │       │       │   │   └── config
    │       │       │       │   │       └── vb-prod
    │       │       │       │   ├── lestore-search
    │       │       │       │   │   └── config
    │       │       │       │   │       └── vbridal-search-prod
    │       │       │       │   ├── lestore-sr
    │       │       │       │   │   └── config
    │       │       │       │   │       └── vb-prod
    │       │       │       │   ├── lestore-ssd
    │       │       │       │   │   └── config
    │       │       │       │   │       └── vb-prod
    │       │       │       │   │           └── pem
    │       │       │       │   ├── lestore-stack
    │       │       │       │   │   └── config
    │       │       │       │   │       └── common
    │       │       │       │   ├── lestore-vm
    │       │       │       │   │   └── config
    │       │       │       │   │       └── common
    │       │       │       │   ├── newsletter
    │       │       │       │   │   └── config
    │       │       │       │   │       └── nl-prod
    │       │       │       │   │           └── nginx
    │       │       │       │   │               └── ssl
    │       │       │       │   ├── osticket
    │       │       │       │   │   ├── config
    │       │       │       │   │   │   └── osticket-prod
    │       │       │       │   │   │       └── nginx
    │       │       │       │   │   │           └── ssl
    │       │       │       │   │   └── js-front
    │       │       │       │   ├── search
    │       │       │       │   │   └── config
    │       │       │       │   │       └── vbridal-search-prod
    │       │       │       │   ├── v5
    │       │       │       │   │   └── config
    │       │       │       │   │       └── v5-prod
    │       │       │       │   │           └── vb
    │       │       │       │   │               ├── etc
    │       │       │       │   │               └── nginx
    │       │       │       │   │                   └── ssl
    │       │       │       │   └── vbridal
    │       │       │       │       └── config
    │       │       │       │           └── vb-prod
    │       │       │       │               └── nginx
    │       │       │       │                   └── ssl
    │       │       │       └── keys
    │       │       ├── azazie-search-prod
    │       │       ├── cms-prod
    │       │       ├── cms-test
    │       │       ├── common
    │       │       ├── common-prod
    │       │       ├── common-test
    │       │       ├── compiler
    │       │       ├── deployer
    │       │       ├── df-prod
    │       │       ├── dresses-search-prod
    │       │       ├── ds-prod
    │       │       ├── editor-test
    │       │       ├── eseditor-prod
    │       │       ├── initaws
    │       │       │   └── aws
    │       │       │       ├── config_repo_tmpl
    │       │       │       │   ├── azazie
    │       │       │       │   │   └── config
    │       │       │       │   │       └── zz-prod
    │       │       │       │   │           └── nginx
    │       │       │       │   │               └── ssl
    │       │       │       │   ├── cms
    │       │       │       │   │   └── config
    │       │       │       │   │       └── zzcms-prod
    │       │       │       │   │           ├── keys
    │       │       │       │   │           └── nginx
    │       │       │       │   │               └── ssl
    │       │       │       │   ├── editor
    │       │       │       │   │   └── config
    │       │       │       │   │       └── zzeditor-prod
    │       │       │       │   │           └── nginx
    │       │       │       │   │               └── ssl
    │       │       │       │   ├── esmeralda-editor
    │       │       │       │   │   └── config
    │       │       │       │   │       └── zzv5_editor-prod
    │       │       │       │   │           └── nginx
    │       │       │       │   │               └── ssl
    │       │       │       │   ├── lestore-logman
    │       │       │       │   │   └── config
    │       │       │       │   │       └── zz-prod
    │       │       │       │   ├── lestore-search
    │       │       │       │   │   └── config
    │       │       │       │   │       └── azazie-search-prod
    │       │       │       │   ├── lestore-sr
    │       │       │       │   │   └── config
    │       │       │       │   │       └── zz-prod
    │       │       │       │   ├── lestore-ssd
    │       │       │       │   │   └── config
    │       │       │       │   │       └── zz-prod
    │       │       │       │   │           └── pem
    │       │       │       │   ├── lestore-stack
    │       │       │       │   │   └── config
    │       │       │       │   │       └── common
    │       │       │       │   ├── lestore-vm
    │       │       │       │   │   └── config
    │       │       │       │   │       └── common
    │       │       │       │   ├── newsletter
    │       │       │       │   │   └── config
    │       │       │       │   │       └── zznl-prod
    │       │       │       │   │           └── nginx
    │       │       │       │   │               └── ssl
    │       │       │       │   ├── osticket
    │       │       │       │   │   ├── config
    │       │       │       │   │   │   └── zzticket-prod
    │       │       │       │   │   │       └── nginx
    │       │       │       │   │   │           └── ssl
    │       │       │       │   │   └── js-front
    │       │       │       │   ├── search-z
    │       │       │       │   │   └── config
    │       │       │       │   │       └── azazie-search-prod
    │       │       │       │   └── v5
    │       │       │       │       └── config
    │       │       │       │           └── v5-prod
    │       │       │       │               └── zz
    │       │       │       │                   ├── etc
    │       │       │       │                   └── nginx
    │       │       │       │                       └── ssl
    │       │       │       └── keys
    │       │       ├── jenjenhouse-search-prod
    │       │       ├── jenjen-prod
    │       │       ├── je-prod
    │       │       ├── jesearch-backup-prod
    │       │       ├── jhshi-db
    │       │       ├── jhshi-search
    │       │       ├── jhshi-test
    │       │       ├── jhshi-testbed
    │       │       ├── jjshouse-search-prod
    │       │       ├── jjs-prod
    │       │       ├── jjs-review-prod
    │       │       ├── js-prod
    │       │       ├── jssearch-backup-prod
    │       │       ├── jsuk-prod
    │       │       ├── logman-prod
    │       │       ├── lp-prod
    │       │       ├── mje-prod
    │       │       ├── mjs-prod
    │       │       ├── monitor
    │       │       ├── mp-prod
    │       │       ├── multi-prod
    │       │       ├── multi-test
    │       │       ├── mvb-prod
    │       │       ├── mzz-prod
    │       │       ├── osticket-prod
    │       │       ├── osticket-test
    │       │       ├── ph-prod
    │       │       ├── proxy
    │       │       ├── search-backup-test
    │       │       ├── sr-prod
    │       │       ├── ssd-prod
    │       │       ├── testbed
    │       │       ├── v5s1-prod
    │       │       ├── v5s1-test
    │       │       ├── vb-prod
    │       │       ├── vbridal-search-prod
    │       │       ├── zabbix-test
    │       │       ├── zbw-testbed
    │       │       └── zz-prod
    │       ├── lestore-vm
    │       │   ├── puppet
    │       │   │   ├── manifests
    │       │   │   └── modules
    │       │   │       └── lebbay
    │       │   │           ├── files
    │       │   │           │   ├── mysql
    │       │   │           │   ├── nginx
    │       │   │           │   │   ├── binaries
    │       │   │           │   │   ├── conf
    │       │   │           │   │   └── webdav
    │       │   │           │   │       └── webserver
    │       │   │           │   │           └── webdav
    │       │   │           │   │               ├── root
    │       │   │           │   │               └── temp
    │       │   │           │   ├── os
    │       │   │           │   │   ├── bin
    │       │   │           │   │   ├── etc
    │       │   │           │   │   ├── user
    │       │   │           │   │   │   ├── cmwu
    │       │   │           │   │   │   ├── hwang
    │       │   │           │   │   │   ├── lchen
    │       │   │           │   │   │   ├── syncer
    │       │   │           │   │   │   ├── ychen
    │       │   │           │   │   │   └── yzhang
    │       │   │           │   │   └── var
    │       │   │           │   │       └── job
    │       │   │           │   ├── php
    │       │   │           │   │   ├── binaries
    │       │   │           │   │   └── etc
    │       │   │           │   │       └── php.d
    │       │   │           │   ├── tomcat
    │       │   │           │   └── zabbix
    │       │   │           │       ├── conf
    │       │   │           │       ├── scripts
    │       │   │           │       └── templates
    │       │   │           ├── manifests
    │       │   │           │   ├── app
    │       │   │           │   ├── middleware
    │       │   │           │   │   ├── nginx
    │       │   │           │   │   ├── php
    │       │   │           │   │   └── tomcat
    │       │   │           │   ├── mysql
    │       │   │           │   ├── os
    │       │   │           │   └── zabbix
    │       │   │           │       └── agent
    │       │   │           ├── spec
    │       │   │           ├── templates
    │       │   │           │   ├── nginx
    │       │   │           │   ├── os
    │       │   │           │   │   └── var
    │       │   │           │   │       └── job
    │       │   │           │   ├── php
    │       │   │           │   └── zabbix
    │       │   │           └── tests
    │       │   └── stages
    │       │       └── common
    │       ├── memcached
    │       │   ├── puppet
    │       │   │   └── manifests
    │       │   └── stages
    │       │       └── common
    │       ├── proxy
    │       │   └── stages
    │       │       ├── common
    │       │       │   └── puppet
    │       │       │       └── modules
    │       │       │           ├── apt
    │       │       │           │   ├── manifests
    │       │       │           │   │   └── debian
    │       │       │           │   ├── spec
    │       │       │           │   │   ├── acceptance
    │       │       │           │   │   │   └── nodesets
    │       │       │           │   │   ├── classes
    │       │       │           │   │   └── defines
    │       │       │           │   ├── templates
    │       │       │           │   └── tests
    │       │       │           │       └── debian
    │       │       │           ├── proxy
    │       │       │           │   ├── files
    │       │       │           │   │   ├── os
    │       │       │           │   │   │   ├── etc
    │       │       │           │   │   │   └── user
    │       │       │           │   │   │       ├── httpproxy
    │       │       │           │   │   │       └── syncer
    │       │       │           │   │   └── pkg
    │       │       │           │   ├── manifests
    │       │       │           │   │   └── os
    │       │       │           │   └── templates
    │       │       │           │       └── etc
    │       │       │           └── stdlib
    │       │       │               ├── lib
    │       │       │               │   ├── facter
    │       │       │               │   │   └── util
    │       │       │               │   └── puppet
    │       │       │               │       ├── parser
    │       │       │               │       │   └── functions
    │       │       │               │       ├── provider
    │       │       │               │       │   └── file_line
    │       │       │               │       └── type
    │       │       │               ├── manifests
    │       │       │               ├── spec
    │       │       │               │   ├── acceptance
    │       │       │               │   │   └── nodesets
    │       │       │               │   ├── classes
    │       │       │               │   ├── fixtures
    │       │       │               │   │   └── dscacheutil
    │       │       │               │   ├── functions
    │       │       │               │   ├── lib
    │       │       │               │   │   └── puppet_spec
    │       │       │               │   ├── monkey_patches
    │       │       │               │   └── unit
    │       │       │               │       ├── facter
    │       │       │               │       │   ├── coverage
    │       │       │               │       │   │   └── assets
    │       │       │               │       │   │       └── 0.8.0
    │       │       │               │       │   │           ├── colorbox
    │       │       │               │       │   │           └── smoothness
    │       │       │               │       │   │               └── images
    │       │       │               │       │   └── util
    │       │       │               │       └── puppet
    │       │       │               │           ├── provider
    │       │       │               │           │   └── file_line
    │       │       │               │           └── type
    │       │       │               └── tests
    │       │       ├── conf
    │       │       ├── shadowsocks
    │       │       │   └── puppet
    │       │       │       └── manifests
    │       │       ├── squid-auth
    │       │       │   └── puppet
    │       │       │       └── manifests
    │       │       └── squid-local
    │       │           └── puppet
    │       │               └── manifests
    │       └── zabbix
    │           └── stages
    │               ├── je
    │               │   └── puppet
    │               │       └── manifests
    │               ├── js
    │               │   └── puppet
    │               │       └── manifests
    │               ├── server
    │               │   └── puppet
    │               │       └── manifests
    │               ├── test
    │               │   └── puppet
    │               │       └── manifests
    │               └── zz
    │                   └── puppet
    │                       └── manifests
    └── jenkins-runner
        ├── keys
        └── stages
            └── ci

495 directories
