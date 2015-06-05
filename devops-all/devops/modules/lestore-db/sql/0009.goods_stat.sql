DROP TABLE IF EXISTS `goods_stat_project`;
CREATE TABLE `goods_stat_project` (
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `project_name` varchar(60) NOT NULL DEFAULT '' COMMENT '项目名',
  `comment_count` int(11) NOT NULL DEFAULT '0' COMMENT '评论数',
  `question_count` int(11) NOT NULL DEFAULT '0' COMMENT '问题数',
  `comment_avg_rating` decimal(3,2) NOT NULL DEFAULT '5.00' COMMENT '评论平均得分',
  `fb_like_count` int(11) NOT NULL DEFAULT '0' COMMENT 'facebook like 数',
  UNIQUE KEY `goods_id` (`goods_id`,`project_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='按项目商品统计数据表';
