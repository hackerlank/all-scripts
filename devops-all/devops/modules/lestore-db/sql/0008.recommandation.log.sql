DROP TABLE IF EXISTS `goods_display_order_recommendation`;
CREATE TABLE `goods_display_order_recommendation` (
  `goods_id` int(11) NOT NULL,
  `cat_id` int(11) NOT NULL DEFAULT '0',
  `project_name` varchar(100) NOT NULL DEFAULT '',
  `display_order` int(11) NOT NULL DEFAULT '0',
  `is_delete` tinyint(2) NOT NULL DEFAULT '0' COMMENT '控制这个排序是否生效',
  PRIMARY KEY (`goods_id`,`cat_id`,`project_name`),
  UNIQUE KEY `main_pk` (`goods_id`,`cat_id`,`project_name`) USING BTREE,
  KEY `goods_id_pk` (`goods_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `goods_display_order_recommendation_log`;
CREATE TABLE `goods_display_order_recommendation_log` (
  `goods_id` int(11) NOT NULL,
  `cat_id` int(11) NOT NULL DEFAULT '0',
  `project_name` varchar(100) NOT NULL DEFAULT '',
  `display_order` int(11) NOT NULL DEFAULT '0',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `create_user_name` varchar(10) NOT NULL DEFAULT '',
  KEY `project_name` (`project_name`,`cat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '商品推荐排序日志';
