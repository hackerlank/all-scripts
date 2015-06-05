# Initialization

## Prepare config_repo
```
lestore-logman/
└── config
    └── zz-prod
        └── logman_config.sh
```

## Deploy lestore-vm

## Deploy lestore-logman

## Start ssh-agent

```bash
sudo bash -c 'ssh-agent > /var/job/ssh-agent.sh'
sudo su
source /var/job/ssh-agent.sh
ssh-add /home/ec2-user/.awstools/keys/prod_rsa
```

## Tunnel to HZ (Optional)
Please refer to /var/job/forward_romeo.sh, /var/job/forward_hz.sh
Need to add ssh private keys.
