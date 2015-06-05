-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Host: localhost:3320
-- Generation Time: Jan 25, 2013 at 03:29 PM
-- Server version: 5.1.62-log
-- PHP Version: 5.3.20

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `jenjenhouse`
--

-- --------------------------------------------------------

--
-- Table structure for table `payment_config`
--

DROP TABLE IF EXISTS `payment_config`;
CREATE TABLE IF NOT EXISTS `payment_config` (
  `project_name` varchar(100) NOT NULL DEFAULT '',
  `language_code` varchar(20) NOT NULL DEFAULT '',
  `country_code` varchar(20) NOT NULL DEFAULT '',
  `currency_code` varchar(20) NOT NULL DEFAULT '',
  `payment_list` varchar(254) NOT NULL DEFAULT '',
  `gc_product_ids` varchar(1024) NOT NULL DEFAULT '' COMMENT 'gc:1,2,3,111,114,119,122,125,123;realtimebank:809,836;webmoney:841',
  `ctime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `enabled` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否启用',
  UNIQUE KEY `project_name` (`project_name`,`language_code`,`country_code`,`currency_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='支付配置，按国家语言语言';

--
-- Dumping data for table `payment_config`
--

INSERT INTO `payment_config` (`project_name`, `language_code`, `country_code`, `currency_code`, `payment_list`, `gc_product_ids`, `ctime`, `enabled`) VALUES
('JenJenHouse', '', '', '', 'paypal', 'gc:1,2,3,111,114,119,122,125,123;realtimebank:809,836', '2012-12-17 09:28:23', 1),
('JenJenHouse', '', '', 'CAD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125,123', '2012-12-17 09:29:18', 1),
('JenJenHouse', '', '', 'EUR', 'paypal,gc,realtimebank,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125,123;realtimebank:809,836', '2012-12-17 09:29:18', 1),
('JenJenHouse', '', '', 'GBP', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125,123', '2012-12-17 09:29:18', 1),
('JenJenHouse', '', '', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125;123', '2012-12-17 09:29:18', 1),
('JenJenHouse', '', 'AE', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125,123', '2012-12-17 08:42:17', 1),
('JenJenHouse', '', 'AT', 'EUR', 'gc,paypal,realtimebank,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125;realtimebank:836', '2012-12-17 08:42:15', 1),
('JenJenHouse', '', 'AU', 'AUD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,3,111,114,119,122', '2013-01-04 13:51:36', 1),
('JenJenHouse', '', 'AU', 'USD', 'paypal', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:15', 1),
('JenJenHouse', '', 'BE', 'EUR', 'gc,paypal,realtimebank,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125;realtimebank:836', '2012-12-17 08:42:15', 1),
('JenJenHouse', '', 'BR', 'BRL', 'boleto,paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,3,111,114,119,122;boleto:1503', '2012-12-22 13:58:05', 1),
('JenJenHouse', '', 'BR', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:15', 1),
('JenJenHouse', '', 'CA', 'CAD', 'gc,paypal,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:15', 1),
('JenJenHouse', '', 'CA', 'USD', 'paypal', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:15', 1),
('JenJenHouse', '', 'CH', 'CHF', 'gc,paypal,realtimebank,western_union,wire_transfer_jenjenhouse', 'gc:1,3,111,114,119,122;realtimebank:836', '2013-01-04 13:51:36', 1),
('JenJenHouse', '', 'CH', 'EUR', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:17', 1),
('JenJenHouse', '', 'CH', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:17', 1),
('JenJenHouse', '', 'DE', 'EUR', 'gc,paypal,realtimebank,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125;realtimebank:836', '2012-12-17 08:42:16', 1),
('JenJenHouse', '', 'DE', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JenJenHouse', '', 'DK', 'DKK', 'gc,paypal,western_union', 'gc:1,3,111,114,119,122,123', '2013-01-04 13:51:36', 1),
('JenJenHouse', '', 'DK', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:15', 1),
('JenJenHouse', '', 'ES', 'EUR', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JenJenHouse', '', 'ES', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JenJenHouse', '', 'FI', 'EUR', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JenJenHouse', '', 'FR', 'EUR', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JenJenHouse', '', 'GB', 'GBP', 'gc,paypal,realtimebank,western_union,wire_transfer_jenjenhouse', 'gc:1,3,2,125,122,114,119,111;realtimebank:836', '2012-12-17 08:42:17', 1),
('JenJenHouse', '', 'GB', 'USD', 'gc,paypal,western_union,wire_transfer_jenjenhouse', 'gc:1,3,2,125,122,114,119,111', '2012-12-17 08:42:17', 1),
('JenJenHouse', '', 'IE', 'EUR', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JenJenHouse', '', 'IT', 'EUR', 'gc,paypal,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JenJenHouse', '', 'NL', 'EUR', 'gc,paypal,realtimebank,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125;realtimebank:809,836', '2012-12-17 08:42:16', 1),
('JenJenHouse', '', 'NL', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JenJenHouse', '', 'NO', 'NOK', 'gc,paypal,western_union', 'gc:1,3,111,114,119,122', '2013-01-04 13:51:36', 1),
('JenJenHouse', '', 'NO', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JenJenHouse', '', 'PT', 'EUR', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JenJenHouse', '', 'RU', 'RUB', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:111,114,119,122', '2013-01-04 13:51:36', 1),
('JenJenHouse', '', 'RU', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:17', 1),
('JenJenHouse', '', 'SE', 'SEK', 'gc,paypal,western_union', 'gc:1,3,111,114,119,122', '2013-01-04 13:51:36', 1),
('JenJenHouse', '', 'SE', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:17', 1),
('JenJenHouse', '', 'US', 'USD', 'paypal', 'gc:1,2,3,111,114,119,122,125,123;realtimebank:809,836', '2012-12-17 08:42:17', 1);

INSERT INTO `payment_config` (`project_name`, `language_code`, `country_code`, `currency_code`, `payment_list`, `gc_product_ids`, `ctime`, `enabled`) VALUES
('JJsHouse', '', '', '', 'paypal', 'gc:1,2,3,111,114,119,122,125,123;realtimebank:809,836', '2012-12-17 09:28:23', 1),
('JJsHouse', '', '', 'CAD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125,123', '2012-12-17 09:29:18', 1),
('JJsHouse', '', '', 'EUR', 'paypal,gc,realtimebank,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125,123;realtimebank:809,836', '2012-12-17 09:29:18', 1),
('JJsHouse', '', '', 'GBP', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125,123', '2012-12-17 09:29:18', 1),
('JJsHouse', '', '', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125;123', '2012-12-17 09:29:18', 1),
('JJsHouse', '', 'AE', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125,123', '2012-12-17 08:42:17', 1),
('JJsHouse', '', 'AT', 'EUR', 'gc,paypal,realtimebank,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125;realtimebank:836', '2012-12-17 08:42:15', 1),
('JJsHouse', '', 'AU', 'AUD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,3,111,114,119,122', '2013-01-04 13:51:36', 1),
('JJsHouse', '', 'AU', 'USD', 'paypal', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:15', 1),
('JJsHouse', '', 'BE', 'EUR', 'gc,paypal,realtimebank,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125;realtimebank:836', '2012-12-17 08:42:15', 1),
('JJsHouse', '', 'BR', 'BRL', 'boleto,paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,3,111,114,119,122;boleto:1503', '2012-12-22 13:58:05', 1),
('JJsHouse', '', 'BR', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:15', 1),
('JJsHouse', '', 'CA', 'CAD', 'gc,paypal,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:15', 1),
('JJsHouse', '', 'CA', 'USD', 'paypal', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:15', 1),
('JJsHouse', '', 'CH', 'CHF', 'gc,paypal,realtimebank,western_union,wire_transfer_jenjenhouse', 'gc:1,3,111,114,119,122;realtimebank:836', '2013-01-04 13:51:36', 1),
('JJsHouse', '', 'CH', 'EUR', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:17', 1),
('JJsHouse', '', 'CH', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:17', 1),
('JJsHouse', '', 'DE', 'EUR', 'gc,paypal,realtimebank,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125;realtimebank:836', '2012-12-17 08:42:16', 1),
('JJsHouse', '', 'DE', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JJsHouse', '', 'DK', 'DKK', 'gc,paypal,western_union', 'gc:1,3,111,114,119,122,123', '2013-01-04 13:51:36', 1),
('JJsHouse', '', 'DK', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:15', 1),
('JJsHouse', '', 'ES', 'EUR', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JJsHouse', '', 'ES', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JJsHouse', '', 'FI', 'EUR', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JJsHouse', '', 'FR', 'EUR', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JJsHouse', '', 'GB', 'GBP', 'gc,paypal,realtimebank,western_union,wire_transfer_jenjenhouse', 'gc:1,3,2,125,122,114,119,111;realtimebank:836', '2012-12-17 08:42:17', 1),
('JJsHouse', '', 'GB', 'USD', 'gc,paypal,western_union,wire_transfer_jenjenhouse', 'gc:1,3,2,125,122,114,119,111', '2012-12-17 08:42:17', 1),
('JJsHouse', '', 'IE', 'EUR', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JJsHouse', '', 'IT', 'EUR', 'gc,paypal,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JJsHouse', '', 'NL', 'EUR', 'gc,paypal,realtimebank,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125;realtimebank:809,836', '2012-12-17 08:42:16', 1),
('JJsHouse', '', 'NL', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JJsHouse', '', 'NO', 'NOK', 'gc,paypal,western_union', 'gc:1,3,111,114,119,122', '2013-01-04 13:51:36', 1),
('JJsHouse', '', 'NO', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JJsHouse', '', 'PT', 'EUR', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:16', 1),
('JJsHouse', '', 'RU', 'RUB', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:111,114,119,122', '2013-01-04 13:51:36', 1),
('JJsHouse', '', 'RU', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:17', 1),
('JJsHouse', '', 'SE', 'SEK', 'gc,paypal,western_union', 'gc:1,3,111,114,119,122', '2013-01-04 13:51:36', 1),
('JJsHouse', '', 'SE', 'USD', 'paypal,gc,western_union,wire_transfer_jenjenhouse', 'gc:1,2,3,111,114,119,122,125', '2012-12-17 08:42:17', 1),
('JJsHouse', '', 'US', 'USD', 'paypal', 'gc:1,2,3,111,114,119,122,125,123;realtimebank:809,836', '2012-12-17 08:42:17', 1);
