# Initialization

## Prepare config repo
```
lestore-ssd/
└── config
    └── zz-prod
        ├── mail_pswd.conf
        ├── ssd_cert.pem
        ├── ssd_db.conf
        └── ssd.s3cfg
```

### mail_pswd.conf sample
```
check_gmail_space.py:foldertransfer@jjshouse.com:<pwd>
check_qqmail_space.zip:uebcc@dressfirst.com:<pwd>
```

### ssd_cert.pem
SSL key used to encode DB dumps

## Ensure DB user
```sql
GRANT USAGE, EXECUTE, SELECT, LOCK TABLES ON *.* TO 'jjs0611ssd'@'%' IDENTIFIED BY  '' ;
GRANT DELETE ON azazie.goods_display_order_batch TO 'jjs0611ssd'@'%' IDENTIFIED BY  '' ;
```

## Deploy lestore-vm

## Deploy lestore-ssd

