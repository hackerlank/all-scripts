DROP TABLE IF EXISTS `payment_currency_config`;
CREATE TABLE `payment_currency_config` (
      `payment_id` smallint(8) unsigned NOT NULL DEFAULT '0' COMMENT '付款方式',
      `display_currency_id` int(10) NOT NULL DEFAULT '0' COMMENT '下单的时候用的货币',
      `order_currency_id` int(10) NOT NULL DEFAULT '0' COMMENT '保存到订单付款用的货币',
      `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
      UNIQUE KEY `payment_id` (`payment_id`,`display_currency_id`,`order_currency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='支付方式对应下单货币和显示货币配置';
