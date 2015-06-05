GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, PROCESS, REFERENCES, INDEX, ALTER, SHOW DATABASES, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER ON *.* TO 'jjs0517dbroot'@'%' IDENTIFIED BY 'vbridalcommonpass' WITH GRANT OPTION ;

GRANT SELECT, LOCK TABLES ON *.* TO 'jjs0517reader'@'%' IDENTIFIED BY 'vbridalcommonpass' ;

GRANT USAGE ON *.* TO 'jjs0517job'@'%' IDENTIFIED BY  'vbridalcommonpass' ;
GRANT SELECT, REFERENCES, SHOW VIEW ON `jjsblog`.* TO 'jjs0517job'@'%' ;
GRANT ALL PRIVILEGES ON `vbridal`.* TO 'jjs0517job'@'%' ;
GRANT SELECT, REFERENCES, LOCK TABLES, SHOW VIEW ON `faucetland`.* TO 'jjs0517job'@'%' ;

GRANT USAGE ON *.* TO 'jjs0517email'@'%' IDENTIFIED BY  'vbridalcommonpass' ;
GRANT ALL PRIVILEGES ON `vbridal`.* TO 'jjs0517email'@'%' ;

GRANT USAGE ON *.* TO 'jjs0517search'@'%' IDENTIFIED BY  'vbridalcommonpass' ;
GRANT ALL PRIVILEGES ON `vbridal`.* TO 'jjs0517search'@'%' ;

GRANT USAGE ON *.* TO 'jjs0517mobile'@'%' IDENTIFIED BY 'vbridalcommonpass';
GRANT ALL PRIVILEGES ON `vbridal`.* TO 'jjs0517mobile'@'%';

GRANT USAGE ON *.* TO 'jjs0517blog'@'%' IDENTIFIED BY  'vbridalcommonpass' ;
GRANT ALL PRIVILEGES ON `jjsblog`.* TO 'jjs0517blog'@'%' ;

GRANT USAGE ON *.* TO 'jjs0517cms'@'%' IDENTIFIED BY  'vbridalcommonpass' ;
GRANT ALL PRIVILEGES ON `vbridal`.* TO 'jjs0517cms'@'%' ;

GRANT USAGE ON *.* TO 'jjs0517editor'@'%' IDENTIFIED BY  'vbridalcommonpass' ;
GRANT ALL PRIVILEGES ON `vbridal`.* TO 'jjs0517editor'@'%' ;

GRANT USAGE ON *.* TO 'jjs0517fe'@'%' IDENTIFIED BY  'vbridalcommonpass' ;
GRANT ALL PRIVILEGES ON `vbridal`.* TO 'jjs0517fe'@'%' ;

GRANT USAGE ON *.* TO 'jjs0517ticket'@'%' IDENTIFIED BY  'vbridalcommonpass' ;
GRANT ALL PRIVILEGES ON `vbridal`.* TO 'jjs0517ticket'@'%' ;

GRANT ALL PRIVILEGES ON `jjshouse_review`.* TO 'jjs0517blog'@'%' ;
GRANT SELECT, REFERENCES, SHOW VIEW ON vbridal.goods TO 'jjs0517blog'@'%' ;
