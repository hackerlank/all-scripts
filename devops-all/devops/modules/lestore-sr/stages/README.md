# Initialization

## Prepare config_repo
```
lestore-sr
└── config
    └── zz-prod
        ├── img.s3cfg
        ├── sr_rsync.conf
        └── sr_thumb.conf
```

## Deploy lestore-vm

## Deploy lestore-sr

## Start ssh-agent

```bash
sudo bash -c 'ssh-agent > /var/job/ssh-agent.sh'
sudo su
source /var/job/ssh-agent.sh
ssh-add /root/.ssh/aws.cms #syncer@cms
```
