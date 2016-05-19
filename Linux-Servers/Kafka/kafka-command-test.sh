
kafka-topics.sh --zookeeper 172.28.25.37:2181 --list

kafka-topics.sh --zookeeper 172.28.25.38:2181 --create --topic myToic --partitions 2 --replication-factor 2

kafka-topics.sh --zookeeper 172.28.25.38:2181 --delete --topic myToic

kafka-topics.sh --zookeeper 172.28.25.37:2181 --alter --topic trade3 --partitions 3

kafka-topics.sh --zookeeper 172.28.25.38:2181 --describe
