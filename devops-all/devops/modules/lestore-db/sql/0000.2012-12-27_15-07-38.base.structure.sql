-- MySQL dump 10.13  Distrib 5.1.66, for redhat-linux-gnu (i386)
--
-- Host: jjshousedb.cmyicoxavsy8.us-east-1.rds.amazonaws.com    Database: jjshouse
-- ------------------------------------------------------
-- Server version	5.1.62-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin_user`
--

DROP TABLE IF EXISTS `admin_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_user` (
  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `party_id` mediumint(5) unsigned NOT NULL DEFAULT '0',
  `facility_id` text NOT NULL COMMENT '仓库id列表',
  `roles` varchar(60) NOT NULL DEFAULT '' COMMENT '用户角色',
  `user_name` varchar(60) NOT NULL DEFAULT '',
  `nick_name` varchar(100) NOT NULL DEFAULT '' COMMENT '显示在前台的用户名称',
  `email` varchar(60) NOT NULL DEFAULT '',
  `password` varchar(32) NOT NULL DEFAULT '',
  `join_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_ip` varchar(15) NOT NULL DEFAULT '',
  `action_list` text NOT NULL,
  `nav_list` text NOT NULL,
  `lang_type` varchar(50) NOT NULL DEFAULT '',
  `allowedip_type` enum('ANYWHERE','COMPANY','SELECTED') NOT NULL DEFAULT 'COMPANY' COMMENT 'IP访问策略',
  `allowedip_list` text NOT NULL COMMENT '该用户允许的ip列表',
  `real_name` varchar(100) NOT NULL DEFAULT '' COMMENT '真实姓名',
  PRIMARY KEY (`user_id`),
  KEY `user_name` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COMMENT='管理员用户表，editor系统使用\r\n';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attribute`
--

DROP TABLE IF EXISTS `attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute` (
  `attr_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `cat_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attr_name` varchar(60) NOT NULL DEFAULT '',
  `attr_type` enum('radio','checkbox','text') NOT NULL DEFAULT 'text' COMMENT '属性模版输入类型',
  `attr_values` varchar(1024) NOT NULL,
  `sort_order` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `default_value` text NOT NULL,
  `attr_description` text NOT NULL,
  `is_delete` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_show` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `display_order` int(11) DEFAULT '0' COMMENT '属性排序',
  PRIMARY KEY (`attr_id`),
  UNIQUE KEY `attr_name` (`attr_name`,`parent_id`,`attr_id`),
  KEY `cat_id` (`cat_id`),
  KEY `attr_values_index` (`attr_values`(255)) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4839 DEFAULT CHARSET=utf8 COMMENT='商品属性表。';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attribute_languages`
--

DROP TABLE IF EXISTS `attribute_languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_languages` (
  `attr_lang_id` int(11) NOT NULL AUTO_INCREMENT,
  `attr_id` smallint(5) NOT NULL,
  `languages_id` tinyint(3) NOT NULL,
  `attr_name` varchar(60) NOT NULL DEFAULT '',
  `attr_values` varchar(1024) NOT NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
  `last_update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  PRIMARY KEY (`attr_lang_id`),
  UNIQUE KEY `attr_id` (`attr_id`,`languages_id`),
  KEY `languages_id` (`languages_id`),
  KEY `attr_values_index` (`attr_values`(255),`attr_id`,`languages_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=52558 DEFAULT CHARSET=utf8 COMMENT='商品属性表翻译。';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `brand`
--

DROP TABLE IF EXISTS `brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `brand` (
  `brand_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `brand_name` varchar(60) NOT NULL DEFAULT '',
  `brand_logo` varchar(80) NOT NULL DEFAULT '',
  `brand_desc` text NOT NULL,
  `site_url` varchar(255) NOT NULL DEFAULT '',
  `brand_order` smallint(5) unsigned NOT NULL DEFAULT '0',
  `is_show` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `brand_code` varchar(100) DEFAULT '',
  PRIMARY KEY (`brand_id`),
  KEY `is_show` (`is_show`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `brand_words`
--

DROP TABLE IF EXISTS `brand_words`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `brand_words` (
  `words` varchar(200) NOT NULL DEFAULT '',
  UNIQUE KEY `words` (`words`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `buy_probability`
--

DROP TABLE IF EXISTS `buy_probability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `buy_probability` (
  `view_goods_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `buy_goods_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `prob` double DEFAULT NULL,
  UNIQUE KEY `view_goods_id` (`view_goods_id`,`buy_goods_id`),
  KEY `view_goods_id_index` (`view_goods_id`),
  KEY `buy_goods_id_index` (`buy_goods_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='计算用户关联购买的概率，计算关联购买时候使用\r\n';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category` (
  `cat_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `cat_name` varchar(90) NOT NULL DEFAULT '',
  `depth` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `keywords` varchar(255) NOT NULL DEFAULT '',
  `cat_desc` varchar(1000) NOT NULL,
  `parent_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `sort_order` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_show` tinyint(1) NOT NULL DEFAULT '1',
  `party_id` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '分离id',
  `config` text NOT NULL COMMENT '配置信息，制作时间 6 - 8 等',
  `erp_cat_id` int(11) NOT NULL DEFAULT '0' COMMENT 'erp 分类id',
  `erp_top_cat_id` int(11) NOT NULL DEFAULT '0' COMMENT 'erp 父分类id',
  `pk_cat_id` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'see category_erp.pk_cat_id',
  `is_accessory` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否是配件',
  PRIMARY KEY (`cat_id`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8 COMMENT='商品类目信息，cat_id是主键，parent_id是父类目的主键';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `category_attribute`
--

DROP TABLE IF EXISTS `category_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category_attribute` (
  `category_id` int(11) NOT NULL,
  `languages_id` int(11) unsigned NOT NULL,
  `attr_name` varchar(60) NOT NULL,
  `attr_value` text NOT NULL,
  PRIMARY KEY (`category_id`,`attr_name`),
  KEY `languages_id` (`languages_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `category_display_order`
--

DROP TABLE IF EXISTS `category_display_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category_display_order` (
  `project_name` enum('AmorModa','JenJenHouse','JennyJoseph','Shop','JJsHouse') NOT NULL DEFAULT 'Shop',
  `location` enum('LEFT_SIDE_BAR','LIST_VIEW','MENU','SUB_MENU') NOT NULL DEFAULT 'MENU',
  `cat_id` smallint(4) NOT NULL DEFAULT '0',
  `sort_order` int(11) NOT NULL DEFAULT '0',
  `is_display` tinyint(1) NOT NULL DEFAULT '1',
  UNIQUE KEY `project_name` (`project_name`,`location`,`cat_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `category_erp`
--

DROP TABLE IF EXISTS `category_erp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category_erp` (
  `project_name` varchar(60) NOT NULL DEFAULT '',
  `pk_cat_id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `party_id` int(11) NOT NULL DEFAULT '0',
  `erp_cat_id` int(11) NOT NULL DEFAULT '0',
  `erp_top_cat_id` int(11) NOT NULL DEFAULT '0',
  `memo` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`project_name`,`pk_cat_id`),
  UNIQUE KEY `project_name` (`project_name`,`erp_cat_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `category_languages`
--

DROP TABLE IF EXISTS `category_languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category_languages` (
  `cat_lang_id` int(11) NOT NULL AUTO_INCREMENT,
  `cat_id` smallint(5) NOT NULL,
  `languages_id` tinyint(3) NOT NULL,
  `cat_name` varchar(90) NOT NULL DEFAULT '',
  `seo_title` varchar(300) NOT NULL COMMENT 'seo title',
  `keywords` varchar(300) NOT NULL DEFAULT '' COMMENT '255不够用了',
  `cat_desc` varchar(1000) NOT NULL,
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
  `last_update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  PRIMARY KEY (`cat_lang_id`),
  UNIQUE KEY `cat_id` (`cat_id`,`languages_id`),
  KEY `languages_id` (`languages_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1374 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `category_relation`
--

DROP TABLE IF EXISTS `category_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category_relation` (
  `relation_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID，主键',
  `cat_id` int(11) NOT NULL COMMENT 'cat_id为0，表示针对所有分类',
  `languages_id` tinyint(3) NOT NULL COMMENT '语言ID',
  `type` varchar(30) NOT NULL DEFAULT '' COMMENT '类型，如related_tags,search_tags',
  `value` text NOT NULL COMMENT '字段的值',
  `url` varchar(120) NOT NULL DEFAULT '' COMMENT '衔接跳转地址',
  `is_show` int(11) NOT NULL COMMENT '1表示显示，0表示不显示',
  `project_name` varchar(40) NOT NULL DEFAULT '' COMMENT '项目名称',
  PRIMARY KEY (`relation_id`),
  KEY `my_iddex` (`cat_id`,`languages_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1674 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cms_article`
--

DROP TABLE IF EXISTS `cms_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_article` (
  `article_id` int(11) NOT NULL AUTO_INCREMENT,
  `cate_id` int(11) NOT NULL DEFAULT '0' COMMENT '分类编号',
  `acct_id` int(11) NOT NULL DEFAULT '0',
  `author` varchar(60) NOT NULL DEFAULT '' COMMENT '作者',
  `from_site` varchar(255) NOT NULL DEFAULT '' COMMENT '来源站点名称',
  `from_uri` varchar(255) NOT NULL DEFAULT '' COMMENT '来源链接',
  `article_lastmodtime` int(11) NOT NULL DEFAULT '0' COMMENT '最后修改时间',
  `article_title` varchar(255) NOT NULL DEFAULT '' COMMENT '文章标题',
  `article_subtitle` varchar(255) NOT NULL DEFAULT '' COMMENT '文章副标题',
  `article_image` varchar(255) NOT NULL DEFAULT '' COMMENT '文章图片',
  `article_summary` text NOT NULL COMMENT '文章摘要',
  `article_keyword` varchar(255) NOT NULL DEFAULT '' COMMENT '关键字',
  `article_cip` int(11) NOT NULL DEFAULT '0' COMMENT '创建时的IP',
  `article_ctime` int(11) NOT NULL DEFAULT '0' COMMENT '创建时的时间',
  `article_stime` int(11) NOT NULL DEFAULT '0' COMMENT '开始日期',
  `article_etime` int(11) NOT NULL DEFAULT '0' COMMENT '结束日期',
  `article_ding` int(11) NOT NULL DEFAULT '0' COMMENT '顶，用于排序',
  `article_show` int(11) NOT NULL DEFAULT '0' COMMENT '是否显示',
  `article_opts` int(11) NOT NULL DEFAULT '0' COMMENT '选项',
  `article_type` varchar(8) NOT NULL DEFAULT '' COMMENT '文章类型',
  `article_tag` varchar(100) NOT NULL DEFAULT '' COMMENT '文章标签',
  `article_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '文章状态',
  `article_clicks` int(11) NOT NULL DEFAULT '0' COMMENT '点击数',
  `article_replies` int(11) NOT NULL DEFAULT '0' COMMENT '回复数',
  `allow_reply` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否允许回复',
  `is_approved` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否通过审核',
  `has_attachment` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否有附件',
  `upload_path_type` int(11) NOT NULL DEFAULT '1' COMMENT '上传路径类型',
  PRIMARY KEY (`article_id`),
  KEY `article_title` (`article_title`),
  KEY `article_tags` (`article_keyword`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 PACK_KEYS=0;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cms_article_content`
--

DROP TABLE IF EXISTS `cms_article_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_article_content` (
  `ac_id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` int(11) NOT NULL DEFAULT '0',
  `ac_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `ac_cip` int(11) NOT NULL DEFAULT '0' COMMENT '创建IP',
  `ac_ctime` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `article_content` mediumtext NOT NULL COMMENT '文章内容',
  `article_keyword_search` varchar(255) NOT NULL DEFAULT '' COMMENT '关键字搜索',
  `article_tag_search` varchar(255) NOT NULL DEFAULT '' COMMENT '标签搜索',
  `article_search` varchar(255) NOT NULL DEFAULT '' COMMENT '文章内容搜索',
  PRIMARY KEY (`ac_id`),
  KEY `article_id` (`article_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 PACK_KEYS=0;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cms_category`
--

DROP TABLE IF EXISTS `cms_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_category` (
  `cate_id` int(11) NOT NULL AUTO_INCREMENT,
  `cate_pid` int(11) NOT NULL DEFAULT '0',
  `cate_code` varchar(20) NOT NULL DEFAULT '',
  `cate_name` varchar(20) NOT NULL DEFAULT '',
  `cate_order` tinyint(4) NOT NULL DEFAULT '0',
  `cate_show` int(11) NOT NULL DEFAULT '1',
  `cate_opts` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`cate_id`),
  UNIQUE KEY `cate_code` (`cate_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cms_editor_link`
--

DROP TABLE IF EXISTS `cms_editor_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_editor_link` (
  `el_id` int(11) NOT NULL AUTO_INCREMENT,
  `elc_id` int(11) NOT NULL DEFAULT '0' COMMENT '链接分类ID',
  `el_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `el_title` varchar(255) NOT NULL DEFAULT '' COMMENT '链接标题',
  `el_url` varchar(255) NOT NULL DEFAULT '' COMMENT '链接地址',
  `el_target` varchar(60) NOT NULL DEFAULT '_self' COMMENT '链接目标',
  `el_summary` text NOT NULL COMMENT '链接摘要',
  `el_image` varchar(100) NOT NULL DEFAULT '' COMMENT '链接图片',
  `el_image_desc` varchar(255) NOT NULL DEFAULT '' COMMENT '链接图片相关文字',
  `el_ctime` int(11) NOT NULL DEFAULT '0',
  `el_cip` int(11) NOT NULL DEFAULT '0',
  `el_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '链接状态',
  `username` varchar(100) NOT NULL DEFAULT '' COMMENT '链接创建人',
  `upload_path_type` int(11) NOT NULL DEFAULT '3' COMMENT '上传路径类型',
  `el_date` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`el_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='编辑可以编辑的链接';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cms_editor_link_class`
--

DROP TABLE IF EXISTS `cms_editor_link_class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_editor_link_class` (
  `elc_id` int(11) NOT NULL AUTO_INCREMENT,
  `elc_pid` int(11) NOT NULL DEFAULT '0' COMMENT '上级分类',
  `elc_name` varchar(100) NOT NULL COMMENT '分类名称',
  `elc_code` varchar(100) NOT NULL COMMENT '分类代码',
  PRIMARY KEY (`elc_id`),
  UNIQUE KEY `elc_name` (`elc_name`),
  UNIQUE KEY `elc_code` (`elc_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='编辑可以编辑的链接分类，用于区别说明；只分两级';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cms_page`
--

DROP TABLE IF EXISTS `cms_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_page` (
  `page_id` int(11) NOT NULL AUTO_INCREMENT,
  `page_code` varchar(255) NOT NULL DEFAULT '',
  `page_content` mediumtext NOT NULL,
  `page_desc` varchar(255) NOT NULL DEFAULT '',
  `page_de` text NOT NULL COMMENT '德语',
  `page_fr` text NOT NULL COMMENT '法语',
  `page_es` text NOT NULL COMMENT '西班牙语',
  `page_se` text NOT NULL COMMENT '瑞典语',
  `page_no` text NOT NULL COMMENT '挪威语',
  `page_it` text NOT NULL COMMENT '意大利语',
  `page_pt` text NOT NULL COMMENT '葡萄牙语',
  `page_da` text NOT NULL COMMENT '丹麦语',
  `page_fi` text NOT NULL COMMENT '芬兰语',
  `page_ru` text NOT NULL COMMENT '俄语',
  `page_nl` text NOT NULL COMMENT '荷兰语',
  PRIMARY KEY (`page_id`),
  UNIQUE KEY `page_code` (`page_code`)
) ENGINE=MyISAM AUTO_INCREMENT=106 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `currency`
--

DROP TABLE IF EXISTS `currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `currency` (
  `currency_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `currency` varchar(20) NOT NULL DEFAULT '' COMMENT '币种代号，如 CNY USD EUR ',
  `currency_symbol` varchar(20) NOT NULL DEFAULT '' COMMENT '货币符号，如 $ ￥ 等',
  `desc_en` varchar(100) NOT NULL DEFAULT '' COMMENT '币种，英文描述',
  `desc_cn` varchar(200) NOT NULL DEFAULT '' COMMENT '币种，中文描述',
  `disabled` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0启用；1禁用',
  `display_order` smallint(6) NOT NULL DEFAULT '0' COMMENT '显示排序',
  PRIMARY KEY (`currency_id`),
  UNIQUE KEY `currency` (`currency`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COMMENT='币种;如要显示更多语言请设计新表currency_language';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `currency_rate`
--

DROP TABLE IF EXISTS `currency_rate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `currency_rate` (
  `currency_id` smallint(6) NOT NULL DEFAULT '0' COMMENT '币种ID',
  `base_id` smallint(6) NOT NULL DEFAULT '0' COMMENT '基准币种ID',
  `base` decimal(10,4) NOT NULL DEFAULT '0.0000' COMMENT '基准量，如美元',
  `exchange` decimal(10,4) NOT NULL DEFAULT '0.0000' COMMENT '兑换量',
  UNIQUE KEY `currency_id` (`currency_id`,`base_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='汇率;公式:数量为N的base_id兑换为currency_id的兑换量为:(N*exchange/base)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dress_like_a_star`
--

DROP TABLE IF EXISTS `dress_like_a_star`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dress_like_a_star` (
  `goods_id` int(11) NOT NULL DEFAULT '0',
  `img_id` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_subscribe`
--

DROP TABLE IF EXISTS `email_subscribe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_subscribe` (
  `es_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `create_time` datetime NOT NULL,
  `ip` bigint(20) NOT NULL,
  `source` varchar(50) NOT NULL DEFAULT 'jjshouse' COMMENT 'Email来源',
  `country_id` int(10) unsigned NOT NULL COMMENT '国家region_id',
  `project_name` varchar(50) NOT NULL DEFAULT 'JJsHouse' COMMENT '按项目退订',
  PRIMARY KEY (`es_id`),
  UNIQUE KEY `email` (`email`,`project_name`),
  KEY `ip` (`ip`),
  KEY `source` (`source`),
  KEY `country_id` (`country_id`)
) ENGINE=InnoDB AUTO_INCREMENT=171581 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_unsubscribe`
--

DROP TABLE IF EXISTS `email_unsubscribe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_unsubscribe` (
  `eu_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'human' COMMENT '取消的渠道类型',
  `datetime` datetime NOT NULL,
  `reason` text NOT NULL COMMENT '取消原因',
  `project_name` varchar(50) NOT NULL DEFAULT 'JJsHouse' COMMENT '按项目退订',
  PRIMARY KEY (`eu_id`),
  UNIQUE KEY `email` (`email`,`project_name`),
  KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=386139 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fabric_color_gallery`
--

DROP TABLE IF EXISTS `fabric_color_gallery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fabric_color_gallery` (
  `fabric_value` varchar(50) NOT NULL DEFAULT '' COMMENT '面料名称',
  `color_value` varchar(50) NOT NULL DEFAULT '' COMMENT '颜色名称',
  `img_url` varchar(100) NOT NULL DEFAULT '' COMMENT '图片地址',
  UNIQUE KEY `fabric_value` (`fabric_value`,`color_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='面料颜色图';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gc_payment_product`
--

DROP TABLE IF EXISTS `gc_payment_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gc_payment_product` (
  `payment_product_id` int(11) NOT NULL DEFAULT '0',
  `payment_product_name` varchar(100) NOT NULL DEFAULT '',
  `enabled` tinyint(4) NOT NULL DEFAULT '0',
  `bg_img_order` tinyint(4) NOT NULL DEFAULT '0' COMMENT '背景图片排序',
  UNIQUE KEY `payment_product_id` (`payment_product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='gc payment product ids';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gmail_info`
--

DROP TABLE IF EXISTS `gmail_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gmail_info` (
  `msgno` int(11) NOT NULL AUTO_INCREMENT,
  `subject` varchar(225) NOT NULL,
  `in_reply_to` varchar(225) NOT NULL,
  `message_id` varchar(225) NOT NULL,
  `references_text` text NOT NULL,
  `toaddress` varchar(255) NOT NULL,
  `toemail` varchar(255) NOT NULL,
  `to_json` text NOT NULL,
  `fromaddress` varchar(255) NOT NULL,
  `fromemail` varchar(255) NOT NULL,
  `from_json` text NOT NULL,
  `ccaddress` varchar(255) NOT NULL,
  `cc` text NOT NULL,
  `reply_toaddress` varchar(255) NOT NULL,
  `reply_to` text NOT NULL,
  `senderaddress` varchar(255) NOT NULL,
  `sender` text NOT NULL,
  `udate` int(11) NOT NULL,
  `body` text NOT NULL,
  `mailbox` varchar(255) NOT NULL,
  `mail_type` varchar(255) NOT NULL COMMENT '邮件类型，售前、售后等',
  PRIMARY KEY (`msgno`),
  KEY `mailbox` (`mailbox`),
  KEY `subject` (`subject`),
  KEY `in_reply_to` (`in_reply_to`),
  KEY `message_id` (`message_id`),
  KEY `toaddress` (`toaddress`),
  KEY `fromaddress` (`fromaddress`),
  KEY `ccaddress` (`ccaddress`),
  KEY `reply_toaddress` (`reply_toaddress`),
  KEY `senderaddress` (`senderaddress`),
  KEY `udate` (`udate`),
  KEY `mail_type` (`mail_type`),
  KEY `toemail` (`toemail`),
  KEY `fromemail` (`fromemail`)
) ENGINE=InnoDB AUTO_INCREMENT=299755 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gmail_spam`
--

DROP TABLE IF EXISTS `gmail_spam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gmail_spam` (
  `gs_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `datetime` datetime NOT NULL,
  `reason` text NOT NULL COMMENT '取消原因',
  `operator` varchar(255) NOT NULL COMMENT '操作人',
  PRIMARY KEY (`gs_id`),
  UNIQUE KEY `email` (`email`),
  KEY `operator` (`operator`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8 COMMENT='gmail的spam用户列表，在spam列表里面的用户发来的邮件不会被计入统计。\r\n';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods`
--

DROP TABLE IF EXISTS `goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods` (
  `goods_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `goods_party_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '分隔不同用户',
  `cat_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `goods_sn` varchar(60) NOT NULL DEFAULT '',
  `sku` varchar(60) NOT NULL,
  `goods_name` varchar(255) NOT NULL DEFAULT '',
  `goods_url_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'url 重写',
  `brand_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `goods_number` smallint(255) unsigned NOT NULL DEFAULT '0',
  `goods_weight` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '商品重量，克(g)',
  `goods_weight_bak` int(11) NOT NULL DEFAULT '0' COMMENT 'goods_weight的备份20110420-201800',
  `market_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `shop_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `no_deal_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `wrap_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '披肩价格',
  `fitting_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `promote_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `promote_start` date NOT NULL DEFAULT '0000-00-00',
  `promote_end` date NOT NULL DEFAULT '0000-00-00',
  `warn_number` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `keywords` varchar(255) NOT NULL DEFAULT '',
  `goods_brief` varchar(1024) NOT NULL,
  `goods_desc` text NOT NULL,
  `goods_thumb` varchar(255) NOT NULL DEFAULT '',
  `goods_img` varchar(255) NOT NULL DEFAULT '',
  `original_img` varchar(255) NOT NULL DEFAULT '',
  `is_on_sale` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0',
  `is_delete` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_promote` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `last_update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `goods_type` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '区分录入商品与定制生成商品',
  `goods_details` text,
  `is_on_sale_pending` tinyint(1) NOT NULL,
  `top_cat_id` smallint(5) NOT NULL DEFAULT '0',
  `sale_status` enum('tosale','presale','shortage','normal','withdrawn','booking') NOT NULL DEFAULT 'normal',
  `is_display` tinyint(4) NOT NULL DEFAULT '1',
  `is_complete` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '编辑是否完成',
  `comment_count` int(11) NOT NULL DEFAULT '0' COMMENT 'comment count',
  `question_count` int(11) NOT NULL DEFAULT '0' COMMENT '商品提问数量',
  `is_new` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否新品',
  `fb_like_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'facebook like',
  `model_card` varchar(100) NOT NULL DEFAULT '' COMMENT '模特卡',
  PRIMARY KEY (`goods_id`),
  UNIQUE KEY `sku` (`sku`),
  KEY `goods_sn` (`goods_sn`),
  KEY `cat_id` (`cat_id`),
  KEY `goods_weight` (`goods_weight`),
  KEY `goods_number` (`goods_number`),
  KEY `top_cat_id` (`top_cat_id`),
  KEY `is_new` (`is_new`),
  KEY `fb_like_count` (`fb_like_count`),
  KEY `is_on_sale` (`is_on_sale`,`is_delete`,`is_display`),
  KEY `goods_thumb` (`goods_thumb`)
) ENGINE=InnoDB AUTO_INCREMENT=20373 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_attr`
--

DROP TABLE IF EXISTS `goods_attr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_attr` (
  `goods_attr_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `goods_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `attr_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attr_value_x` text NOT NULL,
  `is_delete` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_show` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`goods_attr_id`),
  UNIQUE KEY `goods_id` (`goods_id`,`attr_id`),
  KEY `attr_id` (`attr_id`),
  KEY `attr_id_2` (`attr_id`,`is_delete`,`is_show`,`goods_id`)
) ENGINE=InnoDB AUTO_INCREMENT=350325 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_attr_languages`
--

DROP TABLE IF EXISTS `goods_attr_languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_attr_languages` (
  `attr_lang_id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_attr_id` int(10) NOT NULL,
  `languages_id` tinyint(3) NOT NULL,
  `attr_value` text NOT NULL,
  PRIMARY KEY (`attr_lang_id`),
  UNIQUE KEY `goods_attr_id_2` (`goods_attr_id`,`languages_id`),
  KEY `goods_attr_id` (`goods_attr_id`),
  KEY `languages_id` (`languages_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14853 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_category`
--

DROP TABLE IF EXISTS `goods_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_category` (
  `goods_id` int(11) unsigned NOT NULL,
  `cat_id` int(11) unsigned NOT NULL,
  `cat_pid` int(11) unsigned NOT NULL COMMENT 'cat_id的上一层目录',
  UNIQUE KEY `goods_cat_index` (`goods_id`,`cat_id`),
  KEY `cat_pid` (`cat_pid`),
  KEY `cat_id` (`cat_id`,`goods_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_comment`
--

DROP TABLE IF EXISTS `goods_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_comment` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` mediumint(9) NOT NULL DEFAULT '0',
  `goods_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) NOT NULL DEFAULT '0',
  `nick` varchar(100) NOT NULL DEFAULT '',
  `user_email` varchar(200) NOT NULL DEFAULT '' COMMENT '游客的 email',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'comment title',
  `comment` text NOT NULL,
  `rating` tinyint(4) NOT NULL DEFAULT '0' COMMENT '评分 1 2 3 4 5',
  `status` enum('OK','REJECTED','DELETED','DNR') NOT NULL DEFAULT 'OK' COMMENT 'DNR: do not reply',
  `post_datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `reply` text NOT NULL,
  `replied_by` int(11) NOT NULL DEFAULT '0',
  `replied_nick` varchar(100) NOT NULL DEFAULT '',
  `replied_datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `replied_point` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '第一次回复的时间点',
  `faq` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `type` enum('goods','shipping','payment','postsale','complaint','function') NOT NULL DEFAULT 'goods',
  `party_id` smallint(5) unsigned NOT NULL DEFAULT '1',
  `store_id` int(11) NOT NULL DEFAULT '0',
  `display_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `language_id` tinyint(4) NOT NULL DEFAULT '0',
  `ticket_id` int(11) NOT NULL DEFAULT '0',
  `project_name` varchar(30) DEFAULT '' COMMENT '项目名',
  PRIMARY KEY (`comment_id`),
  KEY `nick` (`nick`),
  KEY `goods_user` (`goods_id`,`user_id`),
  KEY `user_id` (`user_id`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=41795 DEFAULT CHARSET=utf8 COMMENT='购买商品前的问题';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_display_order`
--

DROP TABLE IF EXISTS `goods_display_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_display_order` (
  `goods_id` int(11) unsigned NOT NULL COMMENT '商品id',
  `sales_order` int(11) NOT NULL DEFAULT '0' COMMENT '销量排序',
  `sales_order_7_days` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '7天销量排序',
  `goods_order` int(11) NOT NULL DEFAULT '0' COMMENT '商品手工排序',
  `virtual_sales_order` int(11) NOT NULL DEFAULT '0' COMMENT '虚拟销量排序',
  `project_name` varchar(60) NOT NULL DEFAULT '',
  `effective_cat_id` tinyint(1) DEFAULT NULL,
  UNIQUE KEY `goods_id` (`goods_id`,`project_name`),
  KEY `sales_order_7_days` (`sales_order_7_days`),
  KEY `sales_order` (`sales_order`,`goods_order`,`virtual_sales_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品排序';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_display_order_batch`
--

DROP TABLE IF EXISTS `goods_display_order_batch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_display_order_batch` (
  `goods_id` int(11) unsigned NOT NULL COMMENT '商品id',
  `sales_order` int(11) NOT NULL DEFAULT '0' COMMENT '销量排序',
  `sales_order_7_days` int(11) NOT NULL DEFAULT '0',
  `goods_order` int(11) NOT NULL DEFAULT '0' COMMENT '商品手工排序',
  `virtual_sales_order` int(11) NOT NULL DEFAULT '0' COMMENT '虚拟销量排序',
  `project_name` varchar(60) NOT NULL DEFAULT '',
  `effective_cat_id` tinyint(1) DEFAULT NULL,
  `batch` char(14) NOT NULL DEFAULT '' COMMENT '批次',
  UNIQUE KEY `goods_id` (`goods_id`,`project_name`,`batch`),
  KEY `sales_order` (`sales_order`,`goods_order`,`virtual_sales_order`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='商品排序历史记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_display_order_us`
--

DROP TABLE IF EXISTS `goods_display_order_us`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_display_order_us` (
  `goods_id` int(11) unsigned NOT NULL COMMENT '商品id',
  `sales_order` int(11) NOT NULL DEFAULT '0' COMMENT '销量排序',
  `sales_order_7_days` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '7天销量排序',
  `goods_order` int(11) NOT NULL DEFAULT '0' COMMENT '商品手工排序',
  `virtual_sales_order` int(11) NOT NULL DEFAULT '0' COMMENT '虚拟销量排序',
  `project_name` varchar(60) NOT NULL DEFAULT '',
  `effective_cat_id` tinyint(1) DEFAULT NULL,
  UNIQUE KEY `goods_id` (`goods_id`,`project_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_extension`
--

DROP TABLE IF EXISTS `goods_extension`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_extension` (
  `ge_id` int(10) NOT NULL AUTO_INCREMENT,
  `goods_id` int(10) NOT NULL,
  `ext_name` varchar(255) NOT NULL,
  `ext_value` text NOT NULL,
  `is_display` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`ge_id`),
  KEY `goods_id` (`goods_id`),
  KEY `goods_id_2` (`ext_name`,`is_display`,`goods_id`),
  KEY `ext_name` (`ext_name`)
) ENGINE=InnoDB AUTO_INCREMENT=88534 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_gallery`
--

DROP TABLE IF EXISTS `goods_gallery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_gallery` (
  `img_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `goods_id` int(10) unsigned NOT NULL DEFAULT '0',
  `img_url` varchar(255) NOT NULL DEFAULT '',
  `img_color` varchar(60) NOT NULL DEFAULT '',
  `thumb_url` varchar(255) NOT NULL DEFAULT '',
  `img_original` varchar(255) NOT NULL DEFAULT '',
  `cat_id` mediumint(9) NOT NULL DEFAULT '0',
  `direction` tinyint(4) NOT NULL,
  `party_id` mediumint(5) unsigned NOT NULL DEFAULT '1',
  `sequence` smallint(5) unsigned NOT NULL DEFAULT '1',
  `is_display` tinyint(1) NOT NULL DEFAULT '1',
  `img_parent_id` mediumint(9) NOT NULL DEFAULT '0',
  `img_type` enum('old','no','ps','photo','sample','design') NOT NULL DEFAULT 'old' COMMENT '旧图；无背景图；ps图；模特图',
  `img_ctime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '图片上传时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `has_done` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否生成缩略图',
  `cdn_synced` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否同步到cdn',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否默认图',
  `user_name` varchar(60) NOT NULL DEFAULT '' COMMENT '上传人',
  `model_img` varchar(60) DEFAULT '' COMMENT '模特图',
  `last_update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `img_color_style_id` int(11) DEFAULT '0' COMMENT '颜色对应style_id',
  PRIMARY KEY (`img_id`),
  KEY `goods_id` (`goods_id`),
  KEY `cat_id` (`cat_id`),
  KEY `img_type` (`img_type`),
  KEY `img_parent_id` (`img_parent_id`),
  KEY `thumb_url` (`thumb_url`),
  KEY `has_done` (`has_done`),
  KEY `cdn_synced` (`cdn_synced`),
  KEY `img_color_style_id` (`img_color_style_id`),
  KEY `is_delete` (`is_delete`)
) ENGINE=InnoDB AUTO_INCREMENT=112945 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_history`
--

DROP TABLE IF EXISTS `goods_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_history` (
  `goods_history_id` int(11) NOT NULL AUTO_INCREMENT,
  `table_name` varchar(50) NOT NULL DEFAULT '' COMMENT '表名',
  `field_id_name` varchar(50) NOT NULL COMMENT 'field_id对应的名称',
  `field_id` int(11) NOT NULL DEFAULT '0',
  `field_name` varchar(50) NOT NULL DEFAULT '' COMMENT '字段名',
  `old_value` text NOT NULL COMMENT '原来的值',
  `new_value` text NOT NULL COMMENT '新值',
  `user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '用户名',
  `modify_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '修改时间',
  `memo` varchar(50) NOT NULL DEFAULT '' COMMENT '修改描述',
  `oper_type` enum('','INSERT','DELETE','MODIFY') NOT NULL DEFAULT '',
  `parent_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`goods_history_id`),
  KEY `table_name` (`table_name`,`field_id_name`,`field_id`,`field_name`),
  KEY `parent_id` (`parent_id`),
  KEY `field_id_name` (`field_id_name`,`field_id`)
) ENGINE=MyISAM AUTO_INCREMENT=850092 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_image_hash`
--

DROP TABLE IF EXISTS `goods_image_hash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_image_hash` (
  `img_id` int(11) NOT NULL DEFAULT '0',
  `goods_id` int(11) NOT NULL DEFAULT '0',
  `img_url` varchar(255) NOT NULL DEFAULT '',
  `image_hash` varchar(255) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_languages`
--

DROP TABLE IF EXISTS `goods_languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_languages` (
  `goods_lang_id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_id` int(10) NOT NULL,
  `languages_id` tinyint(3) NOT NULL,
  `goods_name` varchar(255) NOT NULL DEFAULT '',
  `goods_url_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'url 重写',
  `keywords` varchar(255) NOT NULL DEFAULT '',
  `goods_desc` varchar(255) NOT NULL DEFAULT '',
  `goods_details` text NOT NULL,
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
  `last_update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  PRIMARY KEY (`goods_lang_id`),
  UNIQUE KEY `goods_id_2` (`goods_id`,`languages_id`),
  KEY `goods_id` (`goods_id`),
  KEY `languages_id` (`languages_id`)
) ENGINE=InnoDB AUTO_INCREMENT=224849 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_languages_project`
--

DROP TABLE IF EXISTS `goods_languages_project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_languages_project` (
  `goods_lang_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '表id，主键',
  `goods_id` int(10) NOT NULL DEFAULT '0' COMMENT '商品id',
  `languages_id` tinyint(3) NOT NULL DEFAULT '0' COMMENT '语言id',
  `goods_name` varchar(255) NOT NULL DEFAULT '' COMMENT '商品名称',
  `goods_url_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'url 重写',
  `keywords` varchar(255) NOT NULL DEFAULT '' COMMENT '商品keywords',
  `goods_desc` varchar(255) NOT NULL DEFAULT '' COMMENT '商品描述',
  `goods_details` text NOT NULL COMMENT '商品细节描述',
  `project_name` varchar(30) NOT NULL DEFAULT '' COMMENT '项目名称',
  PRIMARY KEY (`goods_lang_id`),
  UNIQUE KEY `goods_id` (`goods_id`,`goods_lang_id`,`project_name`) USING BTREE,
  KEY `languages_id` (`languages_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='商品信息按项目自定义';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_list_item`
--

DROP TABLE IF EXISTS `goods_list_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_list_item` (
  `item_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `goods_id` int(10) unsigned NOT NULL COMMENT '商品goods_id',
  `list_id` int(10) unsigned NOT NULL COMMENT '商品分组id',
  `sort` int(10) NOT NULL COMMENT '排序',
  PRIMARY KEY (`item_id`),
  KEY `list_id` (`list_id`),
  KEY `goods_id` (`goods_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8 COMMENT='商品分组推荐';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_name_prefix`
--

DROP TABLE IF EXISTS `goods_name_prefix`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_name_prefix` (
  `prefix_id` int(30) NOT NULL AUTO_INCREMENT,
  `prefix` varchar(100) DEFAULT NULL,
  `language` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`prefix_id`),
  UNIQUE KEY `lan_pre_index` (`language`,`prefix`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_price_history`
--

DROP TABLE IF EXISTS `goods_price_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_price_history` (
  `bak_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `goods_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `cat_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `goods_sn` varchar(60) NOT NULL DEFAULT '',
  `sku` varchar(60) NOT NULL,
  `goods_name` varchar(255) NOT NULL DEFAULT '',
  `goods_url_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'url 重写',
  `goods_weight` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '商品重量，克(g)',
  `market_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `shop_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `no_deal_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `now()` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`goods_id`),
  UNIQUE KEY `goods_id_date` (`goods_id`,`bak_date`)
) ENGINE=InnoDB AUTO_INCREMENT=4981 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_project`
--

DROP TABLE IF EXISTS `goods_project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_project` (
  `goods_id` int(11) NOT NULL DEFAULT '0',
  `project_name` varchar(100) NOT NULL DEFAULT '',
  `goods_thumb` varchar(100) NOT NULL DEFAULT '',
  `img_type` varchar(20) NOT NULL DEFAULT '' COMMENT '默认图图片类型',
  `shop_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品价格，按项目分',
  `last_update_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '最后更新时间',
  UNIQUE KEY `goods_id` (`goods_id`,`project_name`),
  KEY `goods_thumb` (`goods_thumb`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='根据不同项目的缩略图确定商品是否显示';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_project_config`
--

DROP TABLE IF EXISTS `goods_project_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_project_config` (
  `config_id` int(11) NOT NULL AUTO_INCREMENT,
  `img_type` varchar(30) NOT NULL DEFAULT '' COMMENT '图片类型',
  `project_name` varchar(30) NOT NULL DEFAULT '' COMMENT '项目名',
  `display_order` tinyint(4) NOT NULL DEFAULT '1' COMMENT '默认图显示顺序',
  `cat_id` varchar(255) NOT NULL DEFAULT '' COMMENT '产品分类ID，针对特殊处理',
  `is_clothes` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否是衣服',
  PRIMARY KEY (`config_id`),
  UNIQUE KEY `img_type` (`img_type`,`project_name`,`cat_id`,`is_clothes`)
) ENGINE=MyISAM AUTO_INCREMENT=1106 DEFAULT CHARSET=utf8 COMMENT='默认图生成逻辑配置';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_purchase`
--

DROP TABLE IF EXISTS `goods_purchase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_purchase` (
  `p_id` int(10) NOT NULL AUTO_INCREMENT,
  `goods_id` int(10) NOT NULL,
  `purchase_price` decimal(10,2) NOT NULL,
  `purchase_cycle` varchar(60) NOT NULL,
  `purchase_detail` text NOT NULL,
  PRIMARY KEY (`p_id`),
  UNIQUE KEY `goods_id` (`goods_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2955 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_question`
--

DROP TABLE IF EXISTS `goods_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_question` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` mediumint(9) NOT NULL DEFAULT '0',
  `goods_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) NOT NULL DEFAULT '0',
  `nick` varchar(100) NOT NULL DEFAULT '',
  `user_email` varchar(200) NOT NULL DEFAULT '' COMMENT '游客的 email',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'comment title',
  `comment` text NOT NULL,
  `rating` tinyint(4) NOT NULL DEFAULT '0' COMMENT '评分 1 2 3 4 5',
  `status` enum('OK','REJECTED','DELETED','DNR') NOT NULL DEFAULT 'OK',
  `post_datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `reply` text NOT NULL,
  `replied_by` int(11) NOT NULL DEFAULT '0',
  `replied_nick` varchar(100) NOT NULL DEFAULT '',
  `replied_datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `replied_point` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '第一次回复的时间点',
  `faq` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `type` enum('goods','shipping','payment','postsale','complaint','function') NOT NULL DEFAULT 'goods',
  `party_id` smallint(5) unsigned NOT NULL DEFAULT '1',
  `store_id` int(11) NOT NULL DEFAULT '0',
  `display_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `language_id` tinyint(4) NOT NULL DEFAULT '0',
  `ticket_id` int(11) NOT NULL DEFAULT '0',
  `project_name` varchar(30) DEFAULT '' COMMENT '项目名',
  PRIMARY KEY (`comment_id`),
  KEY `nick` (`nick`),
  KEY `goods_user` (`goods_id`,`user_id`),
  KEY `user_id` (`user_id`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=21543 DEFAULT CHARSET=utf8 COMMENT='商品咨询问题';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_review`
--

DROP TABLE IF EXISTS `goods_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_review` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) NOT NULL DEFAULT '0',
  `nick` varchar(100) NOT NULL DEFAULT '',
  `comment` text NOT NULL,
  `rating` tinyint(4) NOT NULL DEFAULT '0' COMMENT '评分 1 2 3 4 5',
  `status` enum('OK','REJECTED','DELETED') NOT NULL DEFAULT 'OK',
  `post_datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `reply` text NOT NULL,
  `replied_by` int(11) NOT NULL DEFAULT '0',
  `replied_nick` varchar(100) NOT NULL DEFAULT '',
  `replied_datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `replied_point` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '第一次回复的时间点',
  `party_id` smallint(5) unsigned NOT NULL DEFAULT '1',
  `store_id` int(11) NOT NULL DEFAULT '0',
  `display_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`comment_id`),
  UNIQUE KEY `goods_user` (`goods_id`,`user_id`),
  KEY `user_id` (`user_id`),
  KEY `nick` (`nick`),
  KEY `party_id` (`party_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='购买后的商品评论';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_sidebar_recommandation`
--

DROP TABLE IF EXISTS `goods_sidebar_recommandation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_sidebar_recommandation` (
  `goods_id` int(10) unsigned NOT NULL DEFAULT '0',
  `cat_id` int(10) unsigned NOT NULL DEFAULT '0',
  `display_order` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `goods_id` (`goods_id`,`cat_id`),
  KEY `cat_id` (`cat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='goods sidebar recommandation';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_size_chart`
--

DROP TABLE IF EXISTS `goods_size_chart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_size_chart` (
  `size_chart_id` int(11) NOT NULL AUTO_INCREMENT,
  `size_type` enum('','Dress','Plus Size Dress','Flower Girl Dresses','Junior Bridesmaid Dresses') NOT NULL DEFAULT '' COMMENT '尺码表类型，大人，青少年，小孩，……',
  `size` varchar(10) NOT NULL DEFAULT '' COMMENT '标准尺码',
  `bust` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '胸围',
  `waist` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '腰围',
  `hips` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '臀部尺寸',
  `shoulder_width` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '肩宽',
  `hollow_to_hem` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '中空到下摆（for short length dress）；喉咙到下摆',
  `hollow_to_floor` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '空心至地面（for floor length dress）；喉咙到地',
  `under_bust` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '下胸围',
  `units` enum('inch','cm') NOT NULL DEFAULT 'inch' COMMENT '尺寸的单位',
  `country` varchar(100) NOT NULL DEFAULT 'US' COMMENT '国别，如 US、UK、EUROPE',
  `reference` varchar(100) NOT NULL DEFAULT 'lightinthebox' COMMENT '类谁？milanoo、lightinthebox',
  `remark` text NOT NULL COMMENT '备注',
  PRIMARY KEY (`size_chart_id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8 COMMENT='商品标准尺码表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_size_chart_wrap`
--

DROP TABLE IF EXISTS `goods_size_chart_wrap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_size_chart_wrap` (
  `size_chart_id` int(11) NOT NULL AUTO_INCREMENT,
  `size_type` enum('','Wraps') NOT NULL DEFAULT '' COMMENT '尺码表类型，大人，青少年，小孩，……',
  `size` varchar(10) NOT NULL DEFAULT '' COMMENT '标准尺码',
  `bust` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '胸围',
  `shoulder_to_bust` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '肩到胸的尺寸',
  `shoulder_to_waist` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '肩到腰的尺寸',
  `bust_point_to_bust_point` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '胸点的距离',
  `shoulder` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '肩宽',
  `armhole` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '袖口的宽度',
  `country` varchar(100) NOT NULL DEFAULT 'US' COMMENT '国别，如 US、UK、EUROPE',
  `units` enum('inch','cm') NOT NULL COMMENT '单位类型',
  `reference` varchar(100) NOT NULL DEFAULT 'lightinthebox' COMMENT '类谁？milanoo、lightinthebox',
  `remark` text NOT NULL COMMENT '备注',
  PRIMARY KEY (`size_chart_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COMMENT='商品标准尺码表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_sku`
--

DROP TABLE IF EXISTS `goods_sku`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_sku` (
  `sku_id` int(11) NOT NULL AUTO_INCREMENT,
  `bust` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '胸围',
  `waist` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '腰围',
  `hips` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '臀部尺寸',
  `shoulder_width` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '肩宽',
  `hollow_to_hem` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '中空到下摆（for short length dress）',
  `hollow_to_floor` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '空心至地面（for floor length dress）',
  `under_bust` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '下胸围',
  `sash_size` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '腰带尺寸',
  `height` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '身高',
  `units` enum('in','cm') NOT NULL DEFAULT 'in' COMMENT '尺寸的单位',
  `item_remarks` text NOT NULL,
  `sleeve_length` decimal(10,2) DEFAULT '0.00' COMMENT '袖长',
  `upper_arm_sleeve_width` decimal(10,2) DEFAULT '0.00' COMMENT '上臂袖宽',
  PRIMARY KEY (`sku_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33993 DEFAULT CHARSET=utf8 COMMENT='能确定 sku 的相关属性';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_style`
--

DROP TABLE IF EXISTS `goods_style`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_style` (
  `goods_style_id` int(8) unsigned NOT NULL AUTO_INCREMENT,
  `sku` varchar(200) NOT NULL DEFAULT '',
  `sku_id` int(11) NOT NULL DEFAULT '0' COMMENT '@see goods_sku.sku_id',
  `goods_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `style_color_id` int(11) NOT NULL DEFAULT '0' COMMENT '颜色',
  `style_size_id` int(11) NOT NULL DEFAULT '0' COMMENT '尺码',
  `style_sash_color_id` int(11) NOT NULL DEFAULT '0' COMMENT 'sash color',
  `style_fabric_id` int(11) NOT NULL DEFAULT '0' COMMENT '布料的结构, 织物, 构造',
  `style_cup_size_id` int(11) NOT NULL DEFAULT '0',
  `style_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `img_url` varchar(255) NOT NULL DEFAULT '',
  `sale_status` enum('tosale','presale','shortage','normal','withdrawn','booking') NOT NULL DEFAULT 'normal',
  `sale_status_detail` varchar(50) NOT NULL DEFAULT '' COMMENT 'å•†å“çŠ¶æ€çš„è¯¦ç»†',
  `is_remains` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否启用库存',
  `goods_number` smallint(6) unsigned NOT NULL DEFAULT '0' COMMENT '库存数量',
  `price_range` decimal(10,0) unsigned NOT NULL DEFAULT '0' COMMENT '降价区间',
  `style_bodice_color_id` int(11) NOT NULL DEFAULT '0' COMMENT '女服的紧身上衣',
  `style_embroidery_color_id` int(11) NOT NULL DEFAULT '0' COMMENT '刺绣颜色',
  `style_wrap_id` int(11) NOT NULL DEFAULT '0',
  `style_heel_type_id` int(11) NOT NULL DEFAULT '0' COMMENT '鞋跟',
  PRIMARY KEY (`goods_style_id`),
  UNIQUE KEY `sku` (`sku`),
  KEY `goods_id` (`goods_id`)
) ENGINE=InnoDB AUTO_INCREMENT=97014 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_style_black_white`
--

DROP TABLE IF EXISTS `goods_style_black_white`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_style_black_white` (
  `bw_id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `black_white` enum('black','white') NOT NULL DEFAULT 'white' COMMENT '是黑名单还是白名单',
  `style_name` varchar(100) NOT NULL DEFAULT '' COMMENT '样式名称',
  `style_value` varchar(100) NOT NULL DEFAULT '' COMMENT '样式的值',
  PRIMARY KEY (`bw_id`),
  UNIQUE KEY `goods_id` (`goods_id`,`black_white`,`style_name`,`style_value`),
  KEY `style_value` (`style_value`)
) ENGINE=InnoDB AUTO_INCREMENT=91954 DEFAULT CHARSET=utf8 COMMENT='商品样式黑白名单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_tag`
--

DROP TABLE IF EXISTS `goods_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_tag` (
  `goods_id` int(11) NOT NULL DEFAULT '0',
  `tag` varchar(255) NOT NULL DEFAULT '',
  `is_delete` tinyint(4) NOT NULL DEFAULT '0',
  `is_display` tinyint(4) NOT NULL DEFAULT '1',
  `language_id` tinyint(4) NOT NULL DEFAULT '0',
  UNIQUE KEY `goods_id` (`goods_id`,`tag`,`language_id`),
  KEY `tag` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='goods tag';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_thumb`
--

DROP TABLE IF EXISTS `goods_thumb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_thumb` (
  `goods_thumb_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) NOT NULL DEFAULT '0',
  `img_id` int(11) NOT NULL DEFAULT '0',
  `thumb_name` varchar(20) NOT NULL DEFAULT '' COMMENT '目录名',
  `width` int(11) NOT NULL DEFAULT '0',
  `height` int(11) NOT NULL DEFAULT '0',
  `watermark` varchar(20) NOT NULL DEFAULT '' COMMENT 'jjshouse,jenjenhouse',
  `has_done` tinyint(4) NOT NULL DEFAULT '0',
  `cdn_synced` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否同步到cdn',
  `thumb_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`goods_thumb_id`),
  UNIQUE KEY `goods_id` (`goods_id`,`img_id`,`thumb_name`,`watermark`),
  KEY `has_done` (`has_done`,`cdn_synced`),
  KEY `img_id` (`img_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4974818 DEFAULT CHARSET=utf8 COMMENT='缩略图记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goods_thumb_config`
--

DROP TABLE IF EXISTS `goods_thumb_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_thumb_config` (
  `config_id` int(11) NOT NULL AUTO_INCREMENT,
  `thumb_name` varchar(20) NOT NULL DEFAULT '' COMMENT '缩略图名称',
  `width` smallint(6) NOT NULL DEFAULT '0' COMMENT '宽度',
  `height` smallint(6) NOT NULL DEFAULT '0' COMMENT '高度',
  `watermark` varchar(20) NOT NULL DEFAULT '' COMMENT '水印',
  `img_type` varchar(10) NOT NULL DEFAULT '' COMMENT '图片类型，old,no,ps,photo,sample',
  PRIMARY KEY (`config_id`),
  UNIQUE KEY `size` (`thumb_name`,`watermark`,`img_type`),
  KEY `img_type` (`img_type`)
) ENGINE=MyISAM AUTO_INCREMENT=257 DEFAULT CHARSET=utf8 COMMENT='缩略图配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `group_goods`
--

DROP TABLE IF EXISTS `group_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group_goods` (
  `group_goods_id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '所属商品goods_id',
  `parent_style_id` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '所属商品style_id',
  `parent_cat_id` mediumint(8) NOT NULL DEFAULT '0' COMMENT '套餐的parent分类id',
  `parent_store_id` mediumint(8) NOT NULL DEFAULT '0',
  `goods_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `style_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `child_store_id` mediumint(8) NOT NULL DEFAULT '0',
  `goods_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `created_by` char(32) NOT NULL,
  `created_datetime` datetime NOT NULL,
  `seq` mediumint(5) NOT NULL DEFAULT '0',
  `name` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`group_goods_id`),
  KEY `parent_store_id` (`parent_store_id`),
  KEY `child_store_id` (`child_store_id`),
  KEY `goods_id` (`goods_id`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `languages`
--

DROP TABLE IF EXISTS `languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `languages` (
  `languages_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL DEFAULT '',
  `code` char(5) NOT NULL DEFAULT '' COMMENT '使用zh-CN格式',
  `disabled` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0启用；1禁用',
  `lang_order` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`languages_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `livechatinc_chats`
--

DROP TABLE IF EXISTS `livechatinc_chats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `livechatinc_chats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chat_id` varchar(20) NOT NULL COMMENT '聊天ID',
  `visitor_name` varchar(50) NOT NULL COMMENT '访客姓名',
  `visitor_email` varchar(50) NOT NULL COMMENT '访客邮箱',
  `operator_name` varchar(50) NOT NULL COMMENT '客服姓名',
  `operator_email` varchar(50) NOT NULL COMMENT '客服邮箱',
  `postchat_survey` text NOT NULL COMMENT '调查',
  `messages` text NOT NULL COMMENT '聊天内容',
  `source` varchar(30) NOT NULL COMMENT '来源 在 custom_variables',
  `goal` varchar(30) NOT NULL COMMENT '目标',
  `goal_id` int(11) NOT NULL DEFAULT '0',
  `goal_name` varchar(30) NOT NULL,
  `rate` varchar(20) NOT NULL,
  `started_timestamp` bigint(9) NOT NULL COMMENT '开始时间timestamp',
  `started` datetime NOT NULL COMMENT '开始时间',
  `ended_timestamp` bigint(9) NOT NULL COMMENT '结束时间timestamp',
  `ended` datetime NOT NULL COMMENT '结束时间',
  `duration` mediumint(9) NOT NULL COMMENT '聊天时长',
  `custom_variables` varchar(255) NOT NULL COMMENT '自定义变量',
  PRIMARY KEY (`id`),
  UNIQUE KEY `chat_id` (`chat_id`) USING BTREE,
  KEY `operator_email` (`operator_email`) USING BTREE,
  KEY `started_timestamp` (`started_timestamp`) USING BTREE,
  KEY `visitor_email` (`visitor_email`) USING BTREE,
  KEY `started` (`started`)
) ENGINE=MyISAM AUTO_INCREMENT=8484 DEFAULT CHARSET=utf8 COMMENT='Livechatinc聊天记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `multilanguage`
--

DROP TABLE IF EXISTS `multilanguage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `multilanguage` (
  `multilanguage_id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `en` text NOT NULL COMMENT '英语',
  `en_note` text NOT NULL COMMENT '英语备注',
  `de` text NOT NULL COMMENT '德语',
  `de_note` text NOT NULL COMMENT '德语备注',
  `fr` text NOT NULL COMMENT '法语',
  `fr_note` text NOT NULL COMMENT '法语备注',
  `es` text NOT NULL COMMENT '西班牙语',
  `es_note` text NOT NULL COMMENT '西班牙语备注',
  `se` text NOT NULL COMMENT '瑞典语',
  `se_note` text NOT NULL COMMENT '瑞典语备注',
  `no` text NOT NULL COMMENT '挪威语',
  `no_note` text NOT NULL COMMENT '挪威语备注',
  `it` text NOT NULL COMMENT '意大利语',
  `it_note` text NOT NULL COMMENT '意大利语备注',
  `pt` text NOT NULL COMMENT '葡萄牙语',
  `pt_note` text NOT NULL COMMENT '葡萄牙语备注',
  `da` text NOT NULL COMMENT '丹麦语',
  `da_note` text NOT NULL COMMENT '丹麦语备注',
  `fi` text NOT NULL COMMENT '芬兰语',
  `fi_note` text NOT NULL COMMENT '芬兰语备注',
  `ru` text NOT NULL COMMENT '俄语',
  `ru_note` text NOT NULL COMMENT '俄语备注',
  `nl` text NOT NULL COMMENT '荷兰语',
  `nl_note` text NOT NULL COMMENT '荷兰语备注',
  `ctime` int(11) NOT NULL DEFAULT '0',
  `last_update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  PRIMARY KEY (`multilanguage_id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=MyISAM AUTO_INCREMENT=218126 DEFAULT CHARSET=utf8 COMMENT='网页元素多语言';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `multilanguage_log`
--

DROP TABLE IF EXISTS `multilanguage_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `multilanguage_log` (
  `multilanguage_queue_id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL DEFAULT '',
  `language_code` varchar(100) NOT NULL,
  `language` text NOT NULL,
  `type` enum('ADD','MOD','DEL') NOT NULL,
  `ctime` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`multilanguage_queue_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9981 DEFAULT CHARSET=utf8 COMMENT='多语言翻译日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `multilanguage_queue`
--

DROP TABLE IF EXISTS `multilanguage_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `multilanguage_queue` (
  `multilanguage_queue_id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL DEFAULT '',
  `language_code` varchar(100) NOT NULL,
  `type` enum('ADD','MOD') NOT NULL DEFAULT 'ADD',
  `status` varchar(20) NOT NULL DEFAULT '' COMMENT 'untranslated; translated',
  `ctime` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`multilanguage_queue_id`),
  KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2278 DEFAULT CHARSET=utf8 COMMENT='多语言任务队列';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `newsletter_orders`
--

DROP TABLE IF EXISTS `newsletter_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `newsletter_orders` (
  `no_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_sn` varchar(64) NOT NULL,
  `nl_code` varchar(255) NOT NULL,
  PRIMARY KEY (`no_id`),
  UNIQUE KEY `order_sn` (`order_sn`),
  KEY `nl_code` (`nl_code`)
) ENGINE=InnoDB AUTO_INCREMENT=139542 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `newsletter_send_email`
--

DROP TABLE IF EXISTS `newsletter_send_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `newsletter_send_email` (
  `nse_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nl_code` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '' COMMENT '用户email',
  `send_time` datetime NOT NULL COMMENT '发送时间',
  `http_code` smallint(3) NOT NULL COMMENT 'email发送是否成功的http code',
  `open_count` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '统计用户打开的次数  ',
  PRIMARY KEY (`nse_id`),
  UNIQUE KEY `nl_code` (`nl_code`,`email`),
  KEY `http_code` (`http_code`)
) ENGINE=InnoDB AUTO_INCREMENT=11341179 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `newsletters`
--

DROP TABLE IF EXISTS `newsletters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `newsletters` (
  `nl_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nl_code` varchar(255) NOT NULL COMMENT 'newsletter code',
  `nl_type` char(6) NOT NULL DEFAULT '',
  `type` varchar(255) NOT NULL DEFAULT 'common' COMMENT 'newsletter不同模式',
  `email_body` text NOT NULL COMMENT '邮件正文',
  `email_subject` varchar(255) NOT NULL COMMENT '邮件标题',
  `create_time` datetime NOT NULL,
  `send_time` datetime NOT NULL,
  `send_count` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '发送数量',
  `open_count` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '打开数量',
  `arrive_count` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '发送成功到达数量',
  `visitors` int(10) unsigned NOT NULL COMMENT '访问人数',
  `newsletter_url` varchar(255) NOT NULL,
  `thumbnail_url` varchar(500) NOT NULL COMMENT '缩略图url',
  `note` text NOT NULL COMMENT '一些备注信息',
  `is_delete` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`nl_id`),
  UNIQUE KEY `nl_code` (`nl_code`),
  KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=594 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ok_coupon`
--

DROP TABLE IF EXISTS `ok_coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ok_coupon` (
  `coupon_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '红包ID',
  `party_id` smallint(6) NOT NULL DEFAULT '0',
  `coupon_config_id` int(11) NOT NULL DEFAULT '0' COMMENT '红包配置Id',
  `coupon_code` char(16) NOT NULL DEFAULT '' COMMENT '红包 code',
  `coupon_ctime` int(11) NOT NULL DEFAULT '0' COMMENT '红包生成时间, create time',
  `coupon_cip` int(11) NOT NULL DEFAULT '0' COMMENT '红包生成的ip, create ip',
  `coupon_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '红包状态',
  `coupon_comment` text NOT NULL COMMENT '备注',
  `coupon_gtime` int(11) NOT NULL DEFAULT '0' COMMENT '发红包时间',
  `coupon_creator` int(11) NOT NULL DEFAULT '0' COMMENT '红包创建人',
  `can_use_times` int(11) NOT NULL DEFAULT '0' COMMENT '此红包最多可以使用的次数',
  `used_times` int(11) NOT NULL DEFAULT '0' COMMENT '此红包已经使用的次数',
  `draw_timestamp` int(11) NOT NULL DEFAULT '0' COMMENT '红包领用时间',
  `coupon_applicant` varchar(255) DEFAULT '' COMMENT '红包申请人',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '领用人用户ID，为空则表示未认领',
  `refer_id` varchar(255) NOT NULL DEFAULT '' COMMENT '关联的订单',
  `give_user_id` int(11) NOT NULL DEFAULT '0' COMMENT '获取的这个红包的用户；发放人',
  `give_comment` text NOT NULL COMMENT '获取这个红包的备注',
  `give_time` int(11) NOT NULL DEFAULT '0' COMMENT '获取红包的时间',
  `used_timestamp` int(11) NOT NULL DEFAULT '0' COMMENT '使用时间',
  `used_order_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用订单',
  `used_user_id` int(11) NOT NULL DEFAULT '0' COMMENT '使用人ID',
  PRIMARY KEY (`coupon_id`),
  UNIQUE KEY `coupon_code` (`coupon_code`),
  KEY `coupon_config_id` (`coupon_config_id`),
  KEY `user_id` (`user_id`),
  KEY `refer_id` (`refer_id`),
  KEY `used_order_id` (`used_order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2847 DEFAULT CHARSET=utf8 COMMENT='红包';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ok_coupon_config`
--

DROP TABLE IF EXISTS `ok_coupon_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ok_coupon_config` (
  `coupon_config_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '红包配置Id',
  `site_id` int(11) NOT NULL DEFAULT '0' COMMENT '启用端编号',
  `party_id` smallint(6) NOT NULL DEFAULT '0',
  `coupon_config_value` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '红包的价值',
  `coupon_config_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '红包的使用状态：0 启用；1 禁用',
  `coupon_config_stime` int(11) NOT NULL DEFAULT '0' COMMENT '红包启用的开始时间, start time',
  `coupon_config_etime` int(11) NOT NULL DEFAULT '0' COMMENT '红包启用的结束时间, end time',
  `coupon_config_comment` varchar(255) NOT NULL DEFAULT '' COMMENT '红包类型注释',
  `coupon_config_coupon_type` enum('value','percent') NOT NULL DEFAULT 'value' COMMENT '是值还是百分比',
  `coupon_config_apply_type` enum('goods','shipping_fee','order') NOT NULL DEFAULT 'goods' COMMENT '是针对商品价格还是针对运费',
  `coupon_config_data` text NOT NULL COMMENT '红包配置',
  `coupon_config_type_id` int(11) NOT NULL DEFAULT '0' COMMENT '红包的类型（促销，返现，补偿）',
  `coupon_config_minimum_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '超过此值方可使用该优惠券',
  `cat_id` int(11) NOT NULL DEFAULT '0' COMMENT '跟分类关联',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '跟商品关联',
  `created_by` int(11) NOT NULL DEFAULT '0' COMMENT '创建人',
  `created_datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '创建时间',
  `currency_id` smallint(6) NOT NULL DEFAULT '0' COMMENT '币种ID',
  `currency` varchar(20) NOT NULL DEFAULT '' COMMENT 'USD HKD',
  PRIMARY KEY (`coupon_config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2325 DEFAULT CHARSET=utf8 COMMENT='红包配置表            对发放的红包整体进行控制';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ok_coupon_config_type`
--

DROP TABLE IF EXISTS `ok_coupon_config_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ok_coupon_config_type` (
  `coupon_config_type_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '红包类型',
  `config_type_name` varchar(100) NOT NULL DEFAULT '' COMMENT '类型名称',
  `invoice_print` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否打印发票(0 不打印；1 打印)',
  `refer_id_required` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否必须填refer_id',
  `config_type_description` varchar(255) DEFAULT '' COMMENT '类型描述',
  `created_by` int(11) DEFAULT '0' COMMENT '由该用户创建（须是管理员）',
  `created_datetime` datetime DEFAULT '0000-00-00 00:00:00' COMMENT '创建时间',
  PRIMARY KEY (`coupon_config_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='红包类型配置';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ok_coupon_log`
--

DROP TABLE IF EXISTS `ok_coupon_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ok_coupon_log` (
  `coupon_log_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '红包使用ID',
  `coupon_config_id` int(11) NOT NULL DEFAULT '0' COMMENT '红包配置ID',
  `coupon_id` int(11) NOT NULL DEFAULT '0' COMMENT '红包ID',
  `coupon_code` char(16) NOT NULL DEFAULT '',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `coupon_log_utime` int(11) NOT NULL DEFAULT '0' COMMENT '红包使用时间, user time',
  `coupon_log_uip` int(11) NOT NULL DEFAULT '0' COMMENT '红包使用时IP, user ip',
  `coupon_log_fk_id` varchar(255) NOT NULL DEFAULT '' COMMENT '红包使用外部关联ID',
  `coupon_log_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '红包使用类型',
  `coupon_log_comment` text NOT NULL COMMENT '备注',
  PRIMARY KEY (`coupon_log_id`),
  KEY `fk_reference_1` (`coupon_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5113 DEFAULT CHARSET=utf8 COMMENT='红包使用日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ops_log`
--

DROP TABLE IF EXISTS `ops_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ops_log` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_sn` varchar(64) NOT NULL DEFAULT '',
  `ops` varchar(20) NOT NULL COMMENT 'order_status, pay_status, shipping_status',
  `status` varchar(100) NOT NULL DEFAULT '' COMMENT '状态时是数字；是其他值时是字符串或者空白',
  `old_status` varchar(100) NOT NULL DEFAULT '' COMMENT '更改之前的值',
  `jjsdatetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `worker` varchar(100) NOT NULL DEFAULT '',
  `datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `note_type` varchar(100) NOT NULL DEFAULT '' COMMENT '值为SHIPPING的将备注显示给用户，否则不显示备注',
  `comment` text NOT NULL,
  PRIMARY KEY (`log_id`),
  KEY `order_sn` (`order_sn`),
  KEY `datetime` (`datetime`),
  KEY `status` (`status`,`old_status`),
  KEY `jjsdatetime` (`jjsdatetime`),
  KEY `ops` (`ops`),
  KEY `worker` (`worker`),
  KEY `ops_2` (`ops`,`status`,`jjsdatetime`)
) ENGINE=InnoDB AUTO_INCREMENT=804832 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_action`
--

DROP TABLE IF EXISTS `order_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_action` (
  `action_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `action_user` varchar(30) NOT NULL DEFAULT '',
  `order_status` tinyint(1) NOT NULL DEFAULT '-1',
  `shipping_status` tinyint(1) NOT NULL DEFAULT '-1',
  `pay_status` tinyint(1) NOT NULL DEFAULT '-1',
  `action_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `action_note` varchar(255) NOT NULL DEFAULT '',
  `invoice_status` tinyint(1) NOT NULL DEFAULT '-1',
  `shortage_status` tinyint(4) NOT NULL COMMENT '缺货状态：0有货；1暂缺货；2请等待；3已到货；4取消',
  `note_type` varchar(50) NOT NULL COMMENT '备注类型',
  PRIMARY KEY (`action_id`),
  KEY `order_id` (`order_id`),
  KEY `shipping_status` (`shipping_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_address`
--

DROP TABLE IF EXISTS `order_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_address` (
  `address_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `address_type` varchar(20) NOT NULL DEFAULT 'SHIPPING' COMMENT 'SHIPPING, BILLING',
  `address_name` varchar(50) NOT NULL DEFAULT '',
  `user_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `consignee` varchar(60) NOT NULL DEFAULT '',
  `first_name` varchar(60) NOT NULL DEFAULT '',
  `last_name` varchar(60) NOT NULL DEFAULT '',
  `gender` enum('male','female','unknown') NOT NULL DEFAULT 'unknown' COMMENT '性别',
  `email` varchar(60) NOT NULL DEFAULT '',
  `country` smallint(5) NOT NULL DEFAULT '0',
  `province` smallint(5) NOT NULL DEFAULT '0',
  `city` smallint(5) NOT NULL DEFAULT '0',
  `district` smallint(5) NOT NULL DEFAULT '0',
  `address` varchar(120) NOT NULL DEFAULT '',
  `zipcode` varchar(60) NOT NULL DEFAULT '',
  `tel` varchar(60) NOT NULL DEFAULT '',
  `mobile` varchar(60) NOT NULL DEFAULT '',
  `sign_building` varchar(120) NOT NULL DEFAULT '',
  `best_time` varchar(120) NOT NULL DEFAULT '',
  `province_text` varchar(100) NOT NULL DEFAULT '' COMMENT '省/直辖市，输入',
  `city_text` varchar(100) NOT NULL DEFAULT '' COMMENT '市/区，输入',
  `district_text` varchar(100) NOT NULL DEFAULT '' COMMENT '县/区，输入',
  `is_default` tinyint(1) DEFAULT '0' COMMENT '是否是默认配送地址',
  PRIMARY KEY (`address_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_analytics`
--

DROP TABLE IF EXISTS `order_analytics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_analytics` (
  `oa_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `order_id` int(11) unsigned NOT NULL COMMENT '订单ID',
  `source` mediumtext NOT NULL COMMENT '来源',
  `keyword` mediumtext NOT NULL COMMENT '关键词',
  `landing_page` mediumtext NOT NULL COMMENT '着陆页面',
  `country` varchar(255) NOT NULL COMMENT '国家',
  `region` varchar(255) NOT NULL COMMENT '地区',
  `city` varchar(255) NOT NULL COMMENT '城市',
  `browser` varchar(255) NOT NULL COMMENT '浏览器',
  `screen_resolution` varchar(255) NOT NULL COMMENT '屏幕分辨率',
  `campaign` varchar(255) NOT NULL DEFAULT '',
  `ad_content` mediumtext NOT NULL,
  `visitor_type` varchar(255) NOT NULL DEFAULT '',
  `operating_system` varchar(255) NOT NULL DEFAULT '',
  `adFormat` varchar(225) NOT NULL,
  `adDisplayUrl` text NOT NULL,
  `adDestinationUrl` text NOT NULL,
  `adwordsCustomerID` varchar(225) NOT NULL,
  `adGroup` varchar(225) NOT NULL,
  `adwordsCriteriaID` varchar(225) NOT NULL,
  `adDistributionNetwork` varchar(225) NOT NULL,
  `adMatchType` varchar(225) NOT NULL,
  `adMatchedQuery` text NOT NULL,
  `adwordsCampaignID` varchar(225) NOT NULL,
  `adwordsAdGroupID` varchar(225) NOT NULL,
  `adwordsCreativeID` varchar(225) NOT NULL,
  PRIMARY KEY (`oa_id`),
  UNIQUE KEY `order_id` (`order_id`),
  KEY `campaign_id_index` (`adwordsCampaignID`),
  KEY `adgroup_id_index` (`adwordsAdGroupID`),
  KEY `keyword_id_index` (`adwordsCriteriaID`)
) ENGINE=InnoDB AUTO_INCREMENT=455499 DEFAULT CHARSET=utf8 COMMENT='记录google统计的数据';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_comment`
--

DROP TABLE IF EXISTS `order_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_comment` (
  `order_comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` mediumint(8) NOT NULL DEFAULT '0',
  `comment_cat` tinyint(4) NOT NULL DEFAULT '0',
  `comment` text NOT NULL,
  `user_id` char(32) NOT NULL DEFAULT '',
  `post_datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `reply` text NOT NULL,
  `replied_by` char(32) NOT NULL DEFAULT '',
  `reply_datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `reply_point` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '第一次回复成功的时间点',
  `status` enum('OK','DELETED') NOT NULL DEFAULT 'OK',
  PRIMARY KEY (`order_comment_id`),
  KEY `order_id` (`order_id`,`comment_cat`,`post_datetime`,`status`),
  KEY `replied_by` (`replied_by`),
  KEY `comment_cat` (`comment_cat`),
  KEY `order_id_2` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单评论，暂未使用';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_convert_stat`
--

DROP TABLE IF EXISTS `order_convert_stat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_convert_stat` (
  `stat_date` date NOT NULL DEFAULT '0000-00-00' COMMENT '统计日期',
  `staff_email` varchar(60) NOT NULL COMMENT '客服邮箱',
  `order_count` int(11) NOT NULL DEFAULT '0' COMMENT '有效回复次数（订单数）',
  `ticket_count` int(11) NOT NULL DEFAULT '0' COMMENT '总回复次数',
  UNIQUE KEY `stat_date` (`stat_date`,`staff_email`) USING BTREE,
  KEY `staff_email` (`staff_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='售前转化率报表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_goods`
--

DROP TABLE IF EXISTS `order_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_goods` (
  `rec_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `goods_style_id` int(11) NOT NULL DEFAULT '0' COMMENT '@see goods_style.goods_style_id',
  `sku` varchar(200) NOT NULL DEFAULT '' COMMENT '@see gods_style.sku',
  `sku_id` int(11) NOT NULL DEFAULT '0' COMMENT '@see goods_sku.sku_id',
  `goods_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `goods_name` varchar(255) NOT NULL DEFAULT '',
  `goods_sn` varchar(60) DEFAULT NULL,
  `goods_sku` varchar(100) NOT NULL DEFAULT '' COMMENT '商品 sku',
  `goods_number` smallint(5) unsigned NOT NULL DEFAULT '1',
  `market_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `shop_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `shop_price_exchange` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '价格转换后的数额',
  `shop_price_amount_exchange` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总额的转换后数值',
  `bonus` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '该商品的折扣，负值；可能来自分类折扣或该商品折扣',
  `coupon_code` varchar(16) NOT NULL DEFAULT '' COMMENT '优惠券代码',
  `goods_attr` text,
  `send_number` smallint(5) unsigned NOT NULL DEFAULT '0',
  `is_real` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `extension_code` varchar(30) DEFAULT NULL,
  `parent_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `is_gift` smallint(5) unsigned NOT NULL DEFAULT '0',
  `goods_status` tinyint(2) NOT NULL DEFAULT '0',
  `action_amt` decimal(10,2) NOT NULL DEFAULT '0.00',
  `action_reason_cat` tinyint(2) NOT NULL DEFAULT '0',
  `action_note` text,
  `carrier_bill_id` int(11) NOT NULL DEFAULT '0',
  `provider_id` int(10) NOT NULL DEFAULT '0',
  `invoice_num` varchar(50) DEFAULT NULL,
  `return_points` int(11) DEFAULT '0',
  `return_bonus` varchar(16) DEFAULT NULL,
  `biaoju_store_goods_id` int(11) NOT NULL DEFAULT '0',
  `subtitle` varchar(500) DEFAULT NULL,
  `addtional_shipping_fee` int(11) NOT NULL DEFAULT '0',
  `style_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `customized` enum('mobile','non-mobile','all','not-applicable') NOT NULL DEFAULT 'not-applicable' COMMENT '表示移动定制机信息',
  `status_id` varchar(30) DEFAULT 'INV_STTS_AVAILABLE' COMMENT '商品新旧状态',
  `added_fee` decimal(10,4) unsigned NOT NULL DEFAULT '1.1700' COMMENT '税率',
  `custom_fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '自定义尺寸的费用',
  `custom_fee_exchange` decimal(10,2) NOT NULL DEFAULT '0.00',
  `plussize_fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '大尺码加钱',
  `plussize_fee_exchange` decimal(10,2) NOT NULL DEFAULT '0.00',
  `rush_order_fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'rush order fee',
  `rush_order_fee_exchange` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'rush order fee',
  `coupon_goods_id` smallint(6) NOT NULL DEFAULT '0',
  `coupon_cat_id` smallint(6) NOT NULL DEFAULT '0',
  `coupon_config_value` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '@see ok_coupon_config',
  `coupon_config_coupon_type` enum('','value','percent') NOT NULL DEFAULT '' COMMENT '@see ok_coupon_config',
  `styles` text NOT NULL COMMENT '用户选择或输入的各种样式，json；记录备查',
  `img_type` varchar(20) DEFAULT '' COMMENT '默认图类型',
  `goods_gallery` text NOT NULL COMMENT '下单时产品显示图',
  `goods_price_original` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品未添加任何附加费的价格',
  `wrap_price` decimal(10,2) DEFAULT '0.00' COMMENT '披肩美元价格',
  `wrap_price_exchange` decimal(10,2) DEFAULT '0.00' COMMENT '当前下单使用币种转换后的披肩价格',
  PRIMARY KEY (`rec_id`),
  KEY `order_id` (`order_id`),
  KEY `goods_id` (`goods_id`),
  KEY `carrier_bill_id` (`carrier_bill_id`),
  KEY `goods_sn` (`goods_sn`),
  KEY `provider_id` (`provider_id`),
  KEY `biaoju_store_goods_id` (`biaoju_store_goods_id`),
  KEY `goods_name` (`goods_name`)
) ENGINE=InnoDB AUTO_INCREMENT=227359 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_info`
--

DROP TABLE IF EXISTS `order_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_info` (
  `order_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `party_id` int(10) unsigned NOT NULL DEFAULT '0',
  `order_sn` varchar(64) NOT NULL,
  `user_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `order_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `order_status` int(10) unsigned NOT NULL DEFAULT '0',
  `shipping_status` int(10) unsigned NOT NULL DEFAULT '0',
  `pay_status` int(10) unsigned NOT NULL DEFAULT '0',
  `consignee` varchar(100) NOT NULL DEFAULT '',
  `gender` enum('male','female','unknown') NOT NULL DEFAULT 'unknown',
  `country` smallint(5) unsigned NOT NULL DEFAULT '0',
  `province` smallint(5) unsigned NOT NULL DEFAULT '0',
  `province_text` varchar(100) NOT NULL DEFAULT '' COMMENT '省/直辖市，输入',
  `city` smallint(5) unsigned NOT NULL DEFAULT '0',
  `city_text` varchar(100) NOT NULL DEFAULT '' COMMENT '市/区，输入',
  `district` smallint(5) unsigned NOT NULL DEFAULT '0',
  `district_text` varchar(100) NOT NULL DEFAULT '' COMMENT '县/区，输入',
  `address` varchar(255) NOT NULL DEFAULT '',
  `zipcode` varchar(60) NOT NULL DEFAULT '',
  `tel` varchar(60) NOT NULL DEFAULT '',
  `mobile` varchar(60) NOT NULL DEFAULT '',
  `email` varchar(60) NOT NULL DEFAULT '',
  `best_time` varchar(120) NOT NULL DEFAULT '',
  `sign_building` varchar(120) NOT NULL DEFAULT '',
  `postscript` text NOT NULL COMMENT '订单附言',
  `important_day` date NOT NULL COMMENT 'The Date of Your Important Day (Wedding, Prom, Party, etc)',
  `sm_id` smallint(6) NOT NULL DEFAULT '0' COMMENT 'shipping method id',
  `shipping_id` tinyint(3) NOT NULL DEFAULT '0',
  `shipping_name` varchar(120) NOT NULL DEFAULT '',
  `payment_id` smallint(6) NOT NULL DEFAULT '0',
  `payment_name` varchar(120) NOT NULL DEFAULT '',
  `how_oos` varchar(120) NOT NULL DEFAULT '',
  `how_surplus` varchar(120) NOT NULL DEFAULT '',
  `pack_name` varchar(120) NOT NULL DEFAULT '',
  `card_name` varchar(120) NOT NULL DEFAULT '',
  `card_message` varchar(255) NOT NULL DEFAULT '',
  `inv_payee` varchar(120) NOT NULL DEFAULT '',
  `inv_content` varchar(120) NOT NULL DEFAULT '',
  `inv_address` varchar(255) NOT NULL COMMENT '发票寄送地址',
  `inv_zipcode` varchar(60) NOT NULL COMMENT '发票寄送地址邮编',
  `inv_phone` varchar(30) NOT NULL COMMENT '发票到的电话',
  `goods_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `goods_amount_exchange` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品转换后的数额',
  `shipping_fee` decimal(10,2) NOT NULL DEFAULT '0.00',
  `shipping_fee_exchange` decimal(10,2) NOT NULL DEFAULT '0.00',
  `insure_fee` decimal(10,2) NOT NULL DEFAULT '0.00',
  `shipping_proxy_fee` decimal(10,2) NOT NULL DEFAULT '0.00',
  `payment_fee` decimal(10,2) NOT NULL DEFAULT '0.00',
  `pack_fee` decimal(10,2) NOT NULL DEFAULT '0.00',
  `card_fee` decimal(10,2) NOT NULL DEFAULT '0.00',
  `money_paid` decimal(10,2) NOT NULL DEFAULT '0.00',
  `surplus` decimal(10,2) NOT NULL DEFAULT '0.00',
  `integral` int(10) NOT NULL DEFAULT '0' COMMENT '已经抵用欧币',
  `integral_money` decimal(10,2) NOT NULL DEFAULT '0.00',
  `bonus` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '优惠费用，负值',
  `bonus_exchange` decimal(10,2) NOT NULL DEFAULT '0.00',
  `order_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `base_currency_id` smallint(6) NOT NULL DEFAULT '0' COMMENT '币种ID',
  `order_currency_id` smallint(6) NOT NULL DEFAULT '0' COMMENT '生成订单时用户选择的币种',
  `order_currency_symbol` varchar(20) NOT NULL DEFAULT '' COMMENT 'like US$ HK$',
  `rate` varchar(100) NOT NULL DEFAULT '' COMMENT '字符串：exchange/base',
  `order_amount_exchange` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '转换后的数额',
  `from_ad` smallint(5) NOT NULL DEFAULT '0',
  `referer` varchar(255) NOT NULL DEFAULT '',
  `confirm_time` int(10) unsigned NOT NULL DEFAULT '0',
  `pay_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `shipping_time` int(10) unsigned NOT NULL DEFAULT '0',
  `shipping_date_estimate` date NOT NULL DEFAULT '0000-00-00' COMMENT '预计发货日期',
  `shipping_carrier` varchar(60) NOT NULL DEFAULT '',
  `shipping_tracking_number` varchar(60) NOT NULL DEFAULT '' COMMENT '货运单号',
  `pack_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `card_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `coupon_code` char(16) NOT NULL DEFAULT '' COMMENT '优惠券代码',
  `invoice_no` varchar(50) NOT NULL DEFAULT '',
  `extension_code` varchar(30) NOT NULL DEFAULT '',
  `extension_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `to_buyer` varchar(255) NOT NULL DEFAULT '',
  `pay_note` varchar(255) NOT NULL DEFAULT '',
  `invoice_status` tinyint(1) NOT NULL DEFAULT '0',
  `carrier_bill_id` int(11) NOT NULL DEFAULT '0',
  `receiving_time` int(10) NOT NULL DEFAULT '0',
  `biaoju_store_id` int(11) NOT NULL DEFAULT '0',
  `parent_order_id` int(11) NOT NULL DEFAULT '0',
  `track_id` char(32) DEFAULT '',
  `ga_track_id` char(32) NOT NULL DEFAULT '' COMMENT 'ga跟踪ID',
  `real_paid` decimal(10,2) NOT NULL DEFAULT '0.00',
  `real_shipping_fee` decimal(10,2) NOT NULL DEFAULT '0.00',
  `is_shipping_fee_clear` tinyint(1) NOT NULL,
  `is_order_amount_clear` tinyint(2) NOT NULL,
  `is_ship_emailed` tinyint(2) NOT NULL DEFAULT '0',
  `proxy_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '代收货款费用',
  `pay_method` enum('NONE','CASH','POS') NOT NULL DEFAULT 'NONE',
  `is_back` enum('NONE','YES','NO') NOT NULL DEFAULT 'NONE' COMMENT '是否从快递公司追回已发送货物',
  `is_finance_clear` tinyint(2) NOT NULL COMMENT '财务是否清算',
  `finance_clear_type` tinyint(4) NOT NULL COMMENT '财务清算类型',
  `handle_time` int(11) NOT NULL DEFAULT '0' COMMENT '处理时间，该时间点前的订单不显示在待配货页面',
  `start_shipping_time` int(11) NOT NULL DEFAULT '0' COMMENT '起始快递时间，小时',
  `end_shipping_time` int(11) NOT NULL DEFAULT '0' COMMENT '结束快递时间，小时',
  `shortage_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '缺货状态：0有货；1暂缺货；2请等待；3已到货；4取消',
  `is_shortage_await` enum('NO','WAIT') NOT NULL DEFAULT 'NO' COMMENT '缺货等待',
  `order_type_id` varchar(30) DEFAULT NULL,
  `special_type_id` varchar(30) NOT NULL DEFAULT 'NORMAL' COMMENT '特殊类型定义',
  `is_display` char(1) NOT NULL DEFAULT 'Y' COMMENT '是否显示给客服',
  `misc_fee` decimal(10,2) NOT NULL COMMENT '????',
  `additional_amount` decimal(10,2) NOT NULL COMMENT '-h订单还需要增加的费用',
  `distributor_id` mediumint(9) NOT NULL COMMENT '分销商',
  `taobao_order_sn` varchar(255) DEFAULT NULL,
  `distribution_purchase_order_sn` varchar(64) DEFAULT NULL COMMENT '分销采购单号',
  `need_invoice` char(1) NOT NULL COMMENT '是否需要发票',
  `facility_id` varchar(30) NOT NULL COMMENT '仓库id',
  `language_id` mediumint(9) NOT NULL DEFAULT '0',
  `coupon_cat_id` smallint(6) NOT NULL DEFAULT '0',
  `coupon_config_value` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '@see ok_coupon_config',
  `coupon_config_coupon_type` enum('','value','percent') NOT NULL DEFAULT '' COMMENT '@see ok_coupon_config',
  `is_conversion` tinyint(1) NOT NULL DEFAULT '0' COMMENT '数据是否已提交给google adwords',
  `from_domain` varchar(100) NOT NULL DEFAULT '' COMMENT '订单来源',
  `project_name` varchar(60) NOT NULL DEFAULT '',
  `user_agent_id` int(11) NOT NULL DEFAULT '0' COMMENT '下单时的 user agent',
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `order_sn` (`order_sn`),
  KEY `user_id` (`user_id`),
  KEY `order_status` (`order_status`),
  KEY `shipping_status` (`shipping_status`),
  KEY `pay_status` (`pay_status`),
  KEY `shipping_id` (`shipping_id`),
  KEY `carrier_bill_id` (`carrier_bill_id`),
  KEY `parent_order_id` (`parent_order_id`),
  KEY `order_time` (`order_time`),
  KEY `facility_id` (`facility_id`),
  KEY `payment_id` (`payment_id`),
  KEY `track_id` (`track_id`),
  KEY `email` (`email`),
  KEY `pay_time` (`pay_time`),
  KEY `pay_status_2` (`pay_status`,`project_name`)
) ENGINE=InnoDB AUTO_INCREMENT=150382 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_info_purchase`
--

DROP TABLE IF EXISTS `order_info_purchase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_info_purchase` (
  `oip_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL DEFAULT '0',
  `goods_id` int(11) NOT NULL DEFAULT '0',
  `goods_style_id` int(11) NOT NULL DEFAULT '0',
  `order_sn` varchar(20) NOT NULL DEFAULT '',
  `purchase_josn` text NOT NULL,
  PRIMARY KEY (`oip_id`),
  UNIQUE KEY `order_id` (`order_id`,`goods_style_id`)
) ENGINE=InnoDB AUTO_INCREMENT=531 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_info_sync`
--

DROP TABLE IF EXISTS `order_info_sync`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_info_sync` (
  `order_id` int(11) NOT NULL,
  `order_sn` varchar(64) NOT NULL COMMENT '订单号',
  `sync_time` int(11) NOT NULL COMMENT '同步时间',
  `check_num` tinyint(4) NOT NULL DEFAULT '0' COMMENT '校验次数',
  UNIQUE KEY `order_sn` (`order_sn`),
  KEY `check_num` (`check_num`),
  KEY `sync_time` (`sync_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单同步信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_livechatinc`
--

DROP TABLE IF EXISTS `order_livechatinc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_livechatinc` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `order_id` mediumint(9) NOT NULL,
  `order_sn` varchar(64) NOT NULL,
  `visitor_id` varchar(30) NOT NULL DEFAULT '',
  `goal_id` int(11) NOT NULL DEFAULT '0',
  `send_time` int(11) NOT NULL DEFAULT '0' COMMENT '有的即为发送了',
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_goal_id` (`goal_id`,`order_id`),
  KEY `order_id` (`order_id`),
  KEY `order_sn` (`order_sn`),
  KEY `status` (`send_time`),
  KEY `visitor_id` (`visitor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=463952 DEFAULT CHARSET=utf8 COMMENT='livechatinc跟踪';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_service_stat`
--

DROP TABLE IF EXISTS `order_service_stat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_service_stat` (
  `order_id` int(11) NOT NULL,
  `order_sn` varchar(64) NOT NULL,
  `order_time` datetime NOT NULL COMMENT '订单时间',
  `email` varchar(60) NOT NULL COMMENT '客户邮箱',
  `staff_email` varchar(60) NOT NULL COMMENT '客服邮箱',
  `staff_name` varchar(32) NOT NULL COMMENT '客服姓名',
  `service_time` datetime NOT NULL COMMENT '服务时间',
  `staff_source` varchar(20) NOT NULL COMMENT '客服来源',
  `source_id` varchar(20) DEFAULT '' COMMENT 'ticketid或者chat_id',
  `pay_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '付款时间',
  `sequence` mediumint(9) NOT NULL DEFAULT '1' COMMENT '最接近付款时间排名',
  `is_cancelled` tinyint(4) NOT NULL DEFAULT '0' COMMENT '订单是否取消，1是取消，0是未取消',
  `order_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单金额',
  UNIQUE KEY `order_sn` (`order_sn`,`staff_source`),
  UNIQUE KEY `order_id` (`order_id`,`staff_source`),
  KEY `order_time` (`order_time`),
  KEY `pay_time` (`pay_time`),
  KEY `sequence` (`sequence`),
  KEY `staff_email` (`staff_email`),
  KEY `staff_source` (`staff_source`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='售前客服贡献统计';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_api_key`
--

DROP TABLE IF EXISTS `ost_api_key`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_api_key` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `isactive` tinyint(1) NOT NULL DEFAULT '1',
  `ipaddr` varchar(16) NOT NULL,
  `apikey` varchar(255) NOT NULL,
  `updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ipaddr` (`ipaddr`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_category`
--

DROP TABLE IF EXISTS `ost_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_category` (
  `cat_id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT '上级ID',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '名称',
  `type` varchar(20) NOT NULL DEFAULT '' COMMENT '分类',
  PRIMARY KEY (`cat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8 COMMENT='ticket分类';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_config`
--

DROP TABLE IF EXISTS `ost_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_config` (
  `id` tinyint(1) unsigned NOT NULL AUTO_INCREMENT,
  `isonline` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `timezone_offset` float(3,1) NOT NULL DEFAULT '0.0',
  `enable_daylight_saving` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `staff_ip_binding` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `staff_max_logins` tinyint(3) unsigned NOT NULL DEFAULT '4',
  `staff_login_timeout` int(10) unsigned NOT NULL DEFAULT '2',
  `staff_session_timeout` int(10) unsigned NOT NULL DEFAULT '30',
  `client_max_logins` tinyint(3) unsigned NOT NULL DEFAULT '4',
  `client_login_timeout` int(10) unsigned NOT NULL DEFAULT '2',
  `client_session_timeout` int(10) unsigned NOT NULL DEFAULT '30',
  `max_page_size` tinyint(3) unsigned NOT NULL DEFAULT '25',
  `max_open_tickets` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `max_file_size` int(11) unsigned NOT NULL DEFAULT '1048576',
  `autolock_minutes` tinyint(3) unsigned NOT NULL DEFAULT '3',
  `overdue_grace_period` int(10) unsigned NOT NULL DEFAULT '0',
  `alert_email_id` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `default_email_id` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `default_dept_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `default_priority_id` tinyint(2) unsigned NOT NULL DEFAULT '2',
  `default_template_id` tinyint(4) unsigned NOT NULL DEFAULT '1',
  `default_smtp_id` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `spoof_default_smtp` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `clickable_urls` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `allow_priority_change` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `use_email_priority` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `enable_captcha` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `enable_auto_cron` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `enable_mail_fetch` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `enable_email_piping` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `send_sql_errors` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `send_mailparse_errors` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `send_login_errors` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `save_email_headers` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `strip_quoted_reply` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `log_ticket_activity` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `ticket_autoresponder` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `message_autoresponder` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `ticket_notice_active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `ticket_alert_active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `ticket_alert_admin` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `ticket_alert_dept_manager` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `ticket_alert_dept_members` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `message_alert_active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `message_alert_laststaff` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `message_alert_assigned` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `message_alert_dept_manager` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `note_alert_active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `note_alert_laststaff` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `note_alert_assigned` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `note_alert_dept_manager` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `overdue_alert_active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `overdue_alert_assigned` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `overdue_alert_dept_manager` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `overdue_alert_dept_members` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `auto_assign_reopened_tickets` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `show_assigned_tickets` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `show_answered_tickets` tinyint(1) NOT NULL DEFAULT '0',
  `hide_staff_name` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `overlimit_notice_active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `email_attachments` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `allow_attachments` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `allow_email_attachments` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `allow_online_attachments` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `allow_online_attachments_onlogin` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `random_ticket_ids` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `log_level` tinyint(1) unsigned NOT NULL DEFAULT '2',
  `log_graceperiod` int(10) unsigned NOT NULL DEFAULT '12',
  `upload_dir` varchar(255) NOT NULL DEFAULT '',
  `allowed_filetypes` varchar(255) NOT NULL DEFAULT '.doc, .pdf',
  `time_format` varchar(32) NOT NULL DEFAULT ' h:i A',
  `date_format` varchar(32) NOT NULL DEFAULT 'm/d/Y',
  `datetime_format` varchar(60) NOT NULL DEFAULT 'm/d/Y g:i a',
  `daydatetime_format` varchar(60) NOT NULL DEFAULT 'D, M j Y g:ia',
  `reply_separator` varchar(60) NOT NULL DEFAULT '-- do not edit --',
  `admin_email` varchar(125) NOT NULL DEFAULT '',
  `helpdesk_title` varchar(255) NOT NULL DEFAULT 'osTicket Support Ticket System',
  `helpdesk_url` varchar(255) NOT NULL DEFAULT '',
  `api_passphrase` varchar(125) NOT NULL DEFAULT '',
  `ostversion` varchar(16) NOT NULL DEFAULT '',
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `isoffline` (`isonline`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_department`
--

DROP TABLE IF EXISTS `ost_department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_department` (
  `dept_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tpl_id` int(10) unsigned NOT NULL DEFAULT '0',
  `email_id` int(10) unsigned NOT NULL DEFAULT '0',
  `autoresp_email_id` int(10) unsigned NOT NULL DEFAULT '0',
  `manager_id` int(10) unsigned NOT NULL DEFAULT '0',
  `dept_name` varchar(32) NOT NULL DEFAULT '',
  `dept_signature` tinytext NOT NULL,
  `ispublic` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `ticket_auto_response` tinyint(1) NOT NULL DEFAULT '1',
  `message_auto_response` tinyint(1) NOT NULL DEFAULT '0',
  `can_append_signature` tinyint(1) NOT NULL DEFAULT '1',
  `updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `auto_assign_ticket_count` mediumint(9) NOT NULL DEFAULT '10' COMMENT '分配ticket数量',
  `dept_name_type` varchar(32) NOT NULL DEFAULT '' COMMENT '语言类型,对应EN关系用,代码无用',
  `dept_name_content` varchar(32) NOT NULL DEFAULT '' COMMENT '名称,对应EN关系用,代码无用',
  `is_internal` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否是内部部门',
  PRIMARY KEY (`dept_id`),
  UNIQUE KEY `dept_name` (`dept_name`),
  KEY `manager_id` (`manager_id`),
  KEY `autoresp_email_id` (`autoresp_email_id`),
  KEY `tpl_id` (`tpl_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_email`
--

DROP TABLE IF EXISTS `ost_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_email` (
  `email_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `noautoresp` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `priority_id` tinyint(3) unsigned NOT NULL DEFAULT '2',
  `dept_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `email` varchar(125) NOT NULL DEFAULT '',
  `name` varchar(32) NOT NULL DEFAULT '',
  `userid` varchar(125) NOT NULL,
  `userpass` varchar(125) NOT NULL,
  `mail_active` tinyint(1) NOT NULL DEFAULT '0',
  `mail_host` varchar(125) NOT NULL,
  `mail_protocol` enum('POP','IMAP') NOT NULL DEFAULT 'POP',
  `mail_encryption` enum('NONE','SSL') NOT NULL,
  `mail_port` int(6) DEFAULT NULL,
  `mail_fetchfreq` tinyint(3) NOT NULL DEFAULT '5',
  `mail_fetchmax` tinyint(4) NOT NULL DEFAULT '30',
  `mail_delete` tinyint(1) NOT NULL DEFAULT '0',
  `mail_errors` tinyint(3) NOT NULL DEFAULT '0',
  `mail_lasterror` datetime DEFAULT NULL,
  `mail_lastfetch` datetime DEFAULT NULL,
  `smtp_active` tinyint(1) DEFAULT '0',
  `smtp_host` varchar(125) NOT NULL,
  `smtp_port` int(6) DEFAULT NULL,
  `smtp_secure` tinyint(1) NOT NULL DEFAULT '1',
  `smtp_auth` tinyint(1) NOT NULL DEFAULT '1',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`email_id`),
  UNIQUE KEY `email` (`email`),
  KEY `priority_id` (`priority_id`),
  KEY `dept_id` (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_email_banlist`
--

DROP TABLE IF EXISTS `ost_email_banlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_email_banlist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL DEFAULT '',
  `submitter` varchar(126) NOT NULL DEFAULT '',
  `added` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_email_template`
--

DROP TABLE IF EXISTS `ost_email_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_email_template` (
  `tpl_id` int(11) NOT NULL AUTO_INCREMENT,
  `cfg_id` int(10) unsigned NOT NULL DEFAULT '0',
  `name` varchar(32) NOT NULL DEFAULT '',
  `notes` text,
  `ticket_autoresp_subj` varchar(255) NOT NULL DEFAULT '',
  `ticket_autoresp_body` text NOT NULL,
  `ticket_notice_subj` varchar(255) NOT NULL,
  `ticket_notice_body` text NOT NULL,
  `ticket_alert_subj` varchar(255) NOT NULL DEFAULT '',
  `ticket_alert_body` text NOT NULL,
  `message_autoresp_subj` varchar(255) NOT NULL DEFAULT '',
  `message_autoresp_body` text NOT NULL,
  `message_alert_subj` varchar(255) NOT NULL DEFAULT '',
  `message_alert_body` text NOT NULL,
  `note_alert_subj` varchar(255) NOT NULL,
  `note_alert_body` text NOT NULL,
  `assigned_alert_subj` varchar(255) NOT NULL DEFAULT '',
  `assigned_alert_body` text NOT NULL,
  `ticket_overdue_subj` varchar(255) NOT NULL DEFAULT '',
  `ticket_overdue_body` text NOT NULL,
  `ticket_overlimit_subj` varchar(255) NOT NULL DEFAULT '',
  `ticket_overlimit_body` text NOT NULL,
  `ticket_reply_subj` varchar(255) NOT NULL DEFAULT '',
  `ticket_reply_body` text NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`tpl_id`),
  KEY `cfg_id` (`cfg_id`),
  FULLTEXT KEY `message_subj` (`ticket_reply_subj`)
) ENGINE=MyISAM AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_groups`
--

DROP TABLE IF EXISTS `ost_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_groups` (
  `group_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group_enabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `group_name` varchar(50) NOT NULL DEFAULT '',
  `dept_access` varchar(255) NOT NULL DEFAULT '',
  `can_create_tickets` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `can_edit_tickets` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `can_delete_tickets` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `can_close_tickets` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `can_transfer_tickets` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `can_ban_emails` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `can_manage_kb` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`group_id`),
  KEY `group_active` (`group_enabled`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_help_topic`
--

DROP TABLE IF EXISTS `ost_help_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_help_topic` (
  `topic_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `isactive` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `noautoresp` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `priority_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dept_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `topic` varchar(32) NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `cms_table` varchar(30) DEFAULT '' COMMENT '对应CMS的表名,goods_comment和goods_question',
  `topic_language` varchar(32) NOT NULL DEFAULT '' COMMENT '语言类型,对应EN关系用,代码无用',
  `topic_content` varchar(32) NOT NULL DEFAULT '' COMMENT '名称,对应EN关系用,代码无用',
  `display_order` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`topic_id`),
  UNIQUE KEY `topic` (`topic`),
  KEY `priority_id` (`priority_id`),
  KEY `dept_id` (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=218 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_kb_premade`
--

DROP TABLE IF EXISTS `ost_kb_premade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_kb_premade` (
  `premade_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dept_id` int(10) unsigned NOT NULL DEFAULT '0',
  `isenabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `title` varchar(125) NOT NULL DEFAULT '',
  `answer` text NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `answer_md5` varchar(32) NOT NULL DEFAULT '' COMMENT 'answer的MD5',
  PRIMARY KEY (`premade_id`),
  UNIQUE KEY `title_2` (`title`,`dept_id`),
  KEY `dept_id` (`dept_id`),
  KEY `active` (`isenabled`),
  FULLTEXT KEY `title` (`title`,`answer`)
) ENGINE=MyISAM AUTO_INCREMENT=589 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_question_email_template`
--

DROP TABLE IF EXISTS `ost_question_email_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_question_email_template` (
  `qet_id` int(11) NOT NULL AUTO_INCREMENT,
  `topic_id` int(11) NOT NULL DEFAULT '0',
  `question_type_id` int(11) NOT NULL DEFAULT '0',
  `answer_type` varchar(100) NOT NULL DEFAULT 'COMMON',
  `email_template` text,
  PRIMARY KEY (`qet_id`),
  UNIQUE KEY `topic_id` (`topic_id`,`question_type_id`,`answer_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8 COMMENT='自动回复邮件模板';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_question_goods_gallery`
--

DROP TABLE IF EXISTS `ost_question_goods_gallery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_question_goods_gallery` (
  `goods_id` int(11) NOT NULL,
  `style_color_id` int(11) NOT NULL DEFAULT '0' COMMENT '颜色样式ID',
  `style_color_value` varchar(30) NOT NULL COMMENT '颜色',
  `need_count` int(11) NOT NULL DEFAULT '0' COMMENT '需要次数',
  `is_exists` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否已经有样图',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '创建时间',
  `last_update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次需要时间',
  `style_color_id_nocat` int(11) NOT NULL DEFAULT '0' COMMENT 'cat_id = 0 时的 style_id',
  UNIQUE KEY `goods_id` (`goods_id`,`style_color_id`),
  KEY `style_color_value` (`goods_id`,`style_color_value`) USING BTREE,
  KEY `style_color_id_nocat` (`style_color_id_nocat`),
  KEY `is_exists` (`is_exists`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='客户需求产品样图是否存在表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_question_type`
--

DROP TABLE IF EXISTS `ost_question_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_question_type` (
  `question_type_id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL DEFAULT '',
  `language_code` varchar(10) NOT NULL DEFAULT '',
  `topic_id` int(11) NOT NULL DEFAULT '0',
  `question_type` varchar(255) NOT NULL DEFAULT '',
  `display_order` tinyint(4) NOT NULL DEFAULT '0',
  `is_auto_response` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否需要自动回复',
  `cat_id` varchar(50) NOT NULL DEFAULT '' COMMENT '所属分类,多个用英文逗号分割',
  PRIMARY KEY (`question_type_id`),
  UNIQUE KEY `topic_id` (`topic_id`,`question_type`),
  KEY `is_auto_response` (`is_auto_response`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 COMMENT='自动回复问题类型';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_staff`
--

DROP TABLE IF EXISTS `ost_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_staff` (
  `staff_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(10) unsigned NOT NULL DEFAULT '0',
  `dept_id` int(10) unsigned NOT NULL DEFAULT '0',
  `username` varchar(32) NOT NULL DEFAULT '',
  `firstname` varchar(32) DEFAULT NULL,
  `lastname` varchar(32) DEFAULT NULL,
  `passwd` varchar(128) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `phone` varchar(24) NOT NULL DEFAULT '',
  `phone_ext` varchar(6) DEFAULT NULL,
  `mobile` varchar(24) NOT NULL DEFAULT '',
  `signature` tinytext NOT NULL,
  `isactive` tinyint(1) NOT NULL DEFAULT '1',
  `isadmin` tinyint(1) NOT NULL DEFAULT '0',
  `isvisible` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `onvacation` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `daylight_saving` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `append_signature` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `change_passwd` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `timezone_offset` float(3,1) NOT NULL DEFAULT '0.0',
  `max_page_size` int(11) unsigned NOT NULL DEFAULT '0',
  `auto_refresh_rate` int(10) unsigned NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `lastlogin` datetime DEFAULT NULL,
  `updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`staff_id`),
  UNIQUE KEY `username` (`username`),
  KEY `dept_id` (`dept_id`),
  KEY `issuperuser` (`isadmin`),
  KEY `group_id` (`group_id`,`staff_id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_syslog`
--

DROP TABLE IF EXISTS `ost_syslog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_syslog` (
  `log_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `log_type` enum('Debug','Warning','Error') NOT NULL,
  `title` varchar(255) NOT NULL,
  `log` text NOT NULL,
  `logger` varchar(64) NOT NULL,
  `ip_address` varchar(16) NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`log_id`),
  KEY `log_type` (`log_type`)
) ENGINE=InnoDB AUTO_INCREMENT=5140 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_ticket`
--

DROP TABLE IF EXISTS `ost_ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_ticket` (
  `ticket_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ticketID` bigint(20) NOT NULL DEFAULT '0',
  `dept_id` int(10) unsigned NOT NULL DEFAULT '1',
  `priority_id` int(10) unsigned NOT NULL DEFAULT '2',
  `topic_id` int(10) unsigned NOT NULL DEFAULT '0',
  `staff_id` int(10) unsigned NOT NULL DEFAULT '0',
  `email` varchar(120) NOT NULL DEFAULT '',
  `name` varchar(32) NOT NULL DEFAULT '',
  `subject` varchar(255) NOT NULL DEFAULT '[no subject]',
  `helptopic` varchar(255) DEFAULT NULL,
  `phone` varchar(16) DEFAULT NULL,
  `phone_ext` varchar(8) DEFAULT NULL,
  `ip_address` varchar(16) NOT NULL DEFAULT '',
  `status` enum('open','closed') NOT NULL DEFAULT 'open',
  `source` enum('Web','Email','Phone','Other') NOT NULL DEFAULT 'Other',
  `isoverdue` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `isanswered` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `duedate` datetime DEFAULT NULL,
  `reopened` datetime DEFAULT NULL,
  `closed` datetime DEFAULT NULL,
  `lastmessage` datetime DEFAULT NULL,
  `lastresponse` datetime DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `language` varchar(2) NOT NULL DEFAULT 'en' COMMENT '语言',
  `lastresponse_staff_name` varchar(32) DEFAULT NULL,
  `lastresponse_staff_id` int(11) DEFAULT '0',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `order_sn` varchar(64) DEFAULT NULL COMMENT '订单号',
  `goods_id` int(11) DEFAULT '0' COMMENT 'review 和 quesiton 用到',
  `domain` varchar(30) DEFAULT '' COMMENT '来源',
  `order_goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '订单产品记录ID',
  `country_region` varchar(100) NOT NULL DEFAULT '' COMMENT 'ticket发送国家',
  `auto_send_count` smallint(6) NOT NULL DEFAULT '0',
  `vote` enum('1','2','0') NOT NULL DEFAULT '0' COMMENT '1:好评 2：差评 0：没有评价',
  `have_send_count` smallint(6) NOT NULL DEFAULT '0' COMMENT '已经自动发送的次数',
  PRIMARY KEY (`ticket_id`),
  UNIQUE KEY `email_extid` (`ticketID`,`email`),
  KEY `dept_id` (`dept_id`),
  KEY `staff_id` (`staff_id`),
  KEY `status` (`status`),
  KEY `priority_id` (`priority_id`),
  KEY `created` (`created`),
  KEY `closed` (`closed`),
  KEY `duedate` (`duedate`),
  KEY `topic_id` (`topic_id`),
  KEY `lastresponse_staff_id` (`lastresponse_staff_id`),
  KEY `lastresponse` (`lastresponse`),
  KEY `isanswered` (`isanswered`),
  KEY `isoverdue` (`isoverdue`),
  KEY `reopened` (`reopened`),
  KEY `lastmessage` (`lastmessage`),
  KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=67091 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_ticket_attachment`
--

DROP TABLE IF EXISTS `ost_ticket_attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_ticket_attachment` (
  `attach_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) unsigned NOT NULL DEFAULT '0',
  `ref_id` int(11) unsigned NOT NULL DEFAULT '0',
  `ref_type` enum('M','R') NOT NULL DEFAULT 'M',
  `file_size` varchar(32) NOT NULL DEFAULT '',
  `file_name` varchar(128) NOT NULL DEFAULT '',
  `file_key` varchar(128) NOT NULL DEFAULT '',
  `deleted` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`attach_id`),
  KEY `ticket_id` (`ticket_id`),
  KEY `ref_type` (`ref_type`),
  KEY `ref_id` (`ref_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33900 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_ticket_category`
--

DROP TABLE IF EXISTS `ost_ticket_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_ticket_category` (
  `ticket_id` int(11) NOT NULL DEFAULT '0',
  `cat_id` int(11) NOT NULL DEFAULT '0',
  KEY `ticket_id` (`ticket_id`),
  KEY `cat_id` (`cat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='每个ticket对应的分类';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_ticket_category_stat`
--

DROP TABLE IF EXISTS `ost_ticket_category_stat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_ticket_category_stat` (
  `ticket_date` date NOT NULL DEFAULT '0000-00-00' COMMENT '日期',
  `project_name` varchar(30) NOT NULL DEFAULT '' COMMENT '项目名',
  `cat_id` int(11) NOT NULL DEFAULT '0' COMMENT '分类ID',
  `cat_num` int(11) NOT NULL DEFAULT '0' COMMENT '分类数量',
  `dept_id` int(11) NOT NULL DEFAULT '0' COMMENT '部门',
  UNIQUE KEY `ticket_date` (`ticket_date`,`cat_id`,`project_name`,`dept_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ticket分类统计';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_ticket_lock`
--

DROP TABLE IF EXISTS `ost_ticket_lock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_ticket_lock` (
  `lock_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) unsigned NOT NULL DEFAULT '0',
  `staff_id` int(10) unsigned NOT NULL DEFAULT '0',
  `expire` datetime DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`lock_id`),
  UNIQUE KEY `ticket_id` (`ticket_id`),
  KEY `staff_id` (`staff_id`),
  KEY `expire` (`expire`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_ticket_message`
--

DROP TABLE IF EXISTS `ost_ticket_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_ticket_message` (
  `msg_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) unsigned NOT NULL DEFAULT '0',
  `messageId` varchar(255) DEFAULT NULL,
  `message` text NOT NULL,
  `headers` text,
  `source` varchar(16) DEFAULT NULL,
  `ip_address` varchar(16) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` datetime DEFAULT NULL,
  `message_translation` text COMMENT 'google翻译内容',
  PRIMARY KEY (`msg_id`),
  KEY `ticket_id` (`ticket_id`),
  KEY `msgId` (`messageId`),
  KEY `created` (`created`),
  FULLTEXT KEY `message` (`message`)
) ENGINE=MyISAM AUTO_INCREMENT=96980 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_ticket_note`
--

DROP TABLE IF EXISTS `ost_ticket_note`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_ticket_note` (
  `note_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) unsigned NOT NULL DEFAULT '0',
  `staff_id` int(10) unsigned NOT NULL DEFAULT '0',
  `source` varchar(32) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT 'Generic Intermal Notes',
  `note` text NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`note_id`),
  KEY `ticket_id` (`ticket_id`),
  KEY `staff_id` (`staff_id`),
  FULLTEXT KEY `note` (`note`)
) ENGINE=MyISAM AUTO_INCREMENT=54266 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_ticket_priority`
--

DROP TABLE IF EXISTS `ost_ticket_priority`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_ticket_priority` (
  `priority_id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `priority` varchar(60) NOT NULL DEFAULT '',
  `priority_desc` varchar(30) NOT NULL DEFAULT '',
  `priority_color` varchar(7) NOT NULL DEFAULT '',
  `priority_urgency` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `ispublic` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`priority_id`),
  UNIQUE KEY `priority` (`priority`),
  KEY `priority_urgency` (`priority_urgency`),
  KEY `ispublic` (`ispublic`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_ticket_question`
--

DROP TABLE IF EXISTS `ost_ticket_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_ticket_question` (
  `ticket_id` int(11) NOT NULL DEFAULT '0',
  `question_type_id` int(11) NOT NULL DEFAULT '0',
  `question_type_value` varchar(255) NOT NULL DEFAULT '',
  `question_type_value_id` int(11) NOT NULL DEFAULT '0',
  KEY `ticket_id` (`ticket_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ticket问题';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_ticket_response`
--

DROP TABLE IF EXISTS `ost_ticket_response`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_ticket_response` (
  `response_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `msg_id` int(11) unsigned NOT NULL DEFAULT '0',
  `ticket_id` int(11) unsigned NOT NULL DEFAULT '0',
  `staff_id` int(11) unsigned NOT NULL DEFAULT '0',
  `staff_name` varchar(32) NOT NULL DEFAULT '',
  `response` text NOT NULL,
  `ip_address` varchar(16) NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `response_translation` text COMMENT 'google 翻译',
  PRIMARY KEY (`response_id`),
  KEY `ticket_id` (`ticket_id`),
  KEY `msg_id` (`msg_id`),
  KEY `staff_id` (`staff_id`),
  KEY `created` (`created`),
  FULLTEXT KEY `response` (`response`)
) ENGINE=MyISAM AUTO_INCREMENT=85527 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_ticket_stat`
--

DROP TABLE IF EXISTS `ost_ticket_stat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_ticket_stat` (
  `ticket_date` date NOT NULL COMMENT '统计日期',
  `staff_reply_num` smallint(6) NOT NULL DEFAULT '0' COMMENT '客服回复数量',
  `customer_reply_num` smallint(6) NOT NULL DEFAULT '0' COMMENT '顾客回头回复数量',
  `order_num` smallint(6) NOT NULL DEFAULT '0' COMMENT '顾客后来下单数量',
  `order_money` float(10,2) NOT NULL DEFAULT '0.00' COMMENT '顾客后来下单总金额',
  `dept_id` smallint(6) NOT NULL DEFAULT '0' COMMENT 'ticket部门ID',
  `topic_id` smallint(6) DEFAULT '0' COMMENT 'ticket help topic id',
  `customer_reply_ticketid_num` mediumint(9) NOT NULL DEFAULT '0' COMMENT '根据ticket id统计',
  `staff_reply_ticketid_num` mediumint(9) NOT NULL DEFAULT '0' COMMENT '根据ticket id统计',
  UNIQUE KEY `ticket_date` (`ticket_date`,`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='tikcet统计';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ost_timezone`
--

DROP TABLE IF EXISTS `ost_timezone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ost_timezone` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `offset` float(3,1) NOT NULL DEFAULT '0.0',
  `timezone` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pay_log`
--

DROP TABLE IF EXISTS `pay_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pay_log` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `order_sn` varchar(64) NOT NULL DEFAULT '',
  `script` varchar(255) NOT NULL COMMENT '调用的脚本',
  `message` text NOT NULL COMMENT '错误信息',
  `message_type` enum('OK','FAIL','Exception','OTHER','WARNING') NOT NULL DEFAULT 'OTHER' COMMENT '信息类型',
  `datetime` datetime NOT NULL COMMENT '时间',
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=107650 DEFAULT CHARSET=utf8 COMMENT='execute or pay log';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment` (
  `payment_id` smallint(8) unsigned NOT NULL AUTO_INCREMENT,
  `payment_code` varchar(50) NOT NULL DEFAULT '',
  `payment_name` varchar(120) NOT NULL DEFAULT '',
  `payment_fee` varchar(10) NOT NULL DEFAULT '0',
  `display_order` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `payment_config` text NOT NULL,
  `disabled` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '0启用；1禁用',
  `is_cod` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `acct_name` varchar(100) NOT NULL,
  `is_gc` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`payment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payment_config`
--

DROP TABLE IF EXISTS `payment_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_config` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payment_config_bak20121219`
--

DROP TABLE IF EXISTS `payment_config_bak20121219`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_config_bak20121219` (
  `project_name` varchar(100) NOT NULL DEFAULT '',
  `language_code` varchar(20) NOT NULL DEFAULT '',
  `country_code` varchar(20) NOT NULL DEFAULT '',
  `currency_code` varchar(20) NOT NULL DEFAULT '',
  `payment_list` varchar(254) NOT NULL DEFAULT '',
  `gc_product_ids` varchar(1024) NOT NULL DEFAULT '' COMMENT 'gc:1,2,3,111,114,119,122,125,123;realtimebank:809,836;webmoney:841',
  `ctime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `project_name` (`project_name`,`language_code`,`country_code`,`currency_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='支付配置，按国家语言语言';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payment_config_bak20121220`
--

DROP TABLE IF EXISTS `payment_config_bak20121220`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_config_bak20121220` (
  `project_name` varchar(100) NOT NULL DEFAULT '',
  `language_code` varchar(20) NOT NULL DEFAULT '',
  `country_code` varchar(20) NOT NULL DEFAULT '',
  `currency_code` varchar(20) NOT NULL DEFAULT '',
  `payment_list` varchar(254) NOT NULL DEFAULT '',
  `gc_product_ids` varchar(1024) NOT NULL DEFAULT '' COMMENT 'gc:1,2,3,111,114,119,122,125,123;realtimebank:809,836;webmoney:841',
  `ctime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `project_name` (`project_name`,`language_code`,`country_code`,`currency_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='支付配置，按国家语言语言';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payment_language`
--

DROP TABLE IF EXISTS `payment_language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_language` (
  `pl_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `payment_id` smallint(6) NOT NULL DEFAULT '0',
  `language_id` smallint(6) NOT NULL DEFAULT '0',
  `payment_desc` text NOT NULL,
  `payment_name` varchar(120) NOT NULL DEFAULT '' COMMENT '支付方式名称',
  `lang_acct_name` varchar(100) NOT NULL,
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
  `last_update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  PRIMARY KEY (`pl_id`),
  UNIQUE KEY `payment_id` (`payment_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=185 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `paypal_txn`
--

DROP TABLE IF EXISTS `paypal_txn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paypal_txn` (
  `txn_id` varchar(100) NOT NULL DEFAULT '' COMMENT 'PayPal交易ID',
  `order_sn` varchar(64) NOT NULL DEFAULT '',
  `txn_datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `txn_post` text NOT NULL COMMENT 'paypal POST 过来的数据',
  `txn_status` varchar(60) NOT NULL DEFAULT '' COMMENT '每次交易的状态',
  `txn_result` varchar(100) NOT NULL DEFAULT '' COMMENT 'paypal校验结果',
  `site_code` varchar(100) NOT NULL DEFAULT '' COMMENT '网站返回的code',
  `boleto_url` varchar(255) NOT NULL DEFAULT '' COMMENT 'boleto的url',
  KEY `txn_id` (`txn_id`),
  KEY `order_sn` (`order_sn`),
  KEY `txn_status` (`txn_status`),
  KEY `txn_datetime` (`txn_datetime`),
  KEY `txn_result` (`txn_result`,`site_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `price_history`
--

DROP TABLE IF EXISTS `price_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `price_history` (
  `ph_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `admin_user_id` int(10) unsigned NOT NULL,
  `goods_id` int(11) unsigned NOT NULL,
  `previous_price` decimal(10,2) unsigned NOT NULL COMMENT '更改前价格',
  `shop_price` decimal(10,2) unsigned NOT NULL COMMENT '更改后价格',
  `datetime` datetime NOT NULL,
  `reason` text NOT NULL COMMENT '更改原因',
  PRIMARY KEY (`ph_id`),
  KEY `admin_user_id` (`admin_user_id`,`datetime`),
  KEY `goods_id` (`goods_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30514 DEFAULT CHARSET=utf8 COMMENT='商品价格历史修改记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_tags`
--

DROP TABLE IF EXISTS `product_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_tags` (
  `pt_id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'tag名字',
  `tag_group` varchar(255) NOT NULL DEFAULT '' COMMENT '组名',
  `is_display` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否显示',
  `language` varchar(3) DEFAULT NULL,
  `batch_id` int(11) DEFAULT NULL,
  `project_name` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`pt_id`),
  UNIQUE KEY `tag_name` (`tag_name`,`language`,`project_name`),
  KEY `tag_group` (`language`,`tag_group`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1067966 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_tags_description_template`
--

DROP TABLE IF EXISTS `product_tags_description_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_tags_description_template` (
  `template_id` int(11) NOT NULL AUTO_INCREMENT,
  `language_code` varchar(3) DEFAULT NULL,
  `template_text` varchar(2048) DEFAULT NULL,
  `is_display` int(11) DEFAULT '1',
  `template_text_md5` char(32) NOT NULL,
  PRIMARY KEY (`template_id`),
  UNIQUE KEY `template_text_md5` (`template_text_md5`),
  KEY `language_index` (`language_code`)
) ENGINE=InnoDB AUTO_INCREMENT=313 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_tags_info`
--

DROP TABLE IF EXISTS `product_tags_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_tags_info` (
  `pti_id` int(11) NOT NULL AUTO_INCREMENT,
  `pt_id` int(11) NOT NULL,
  `tag_wordcount` int(11) NOT NULL,
  `tag_visitedcount` int(11) NOT NULL,
  `tag_name_md5` char(32) NOT NULL COMMENT '首字母大写空格分隔之后的md5串',
  PRIMARY KEY (`pti_id`),
  UNIQUE KEY `pt_id` (`pt_id`),
  KEY `tag_wordcount` (`tag_wordcount`),
  KEY `tag_name_md5` (`tag_name_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_tags_project_mapping`
--

DROP TABLE IF EXISTS `product_tags_project_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_tags_project_mapping` (
  `ptpm_id` int(11) NOT NULL AUTO_INCREMENT,
  `pt_id` int(11) NOT NULL,
  `project_name` varchar(20) NOT NULL,
  PRIMARY KEY (`ptpm_id`),
  UNIQUE KEY `pt_id` (`pt_id`,`project_name`),
  KEY `pt_id_2` (`pt_id`),
  KEY `project_name` (`project_name`)
) ENGINE=MyISAM AUTO_INCREMENT=523219 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_tags_relevance`
--

DROP TABLE IF EXISTS `product_tags_relevance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_tags_relevance` (
  `ptr_id` int(11) NOT NULL AUTO_INCREMENT,
  `pt_id` int(11) NOT NULL,
  `relevance_list` text NOT NULL,
  `update_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`ptr_id`),
  UNIQUE KEY `pt_id` (`pt_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_tags_test`
--

DROP TABLE IF EXISTS `product_tags_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_tags_test` (
  `pt_id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'tag名字',
  `tag_group` varchar(255) NOT NULL DEFAULT '' COMMENT '组名',
  `is_display` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否显示',
  `language` varchar(3) DEFAULT NULL,
  `batch_id` int(11) DEFAULT NULL,
  `project_name` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`pt_id`),
  UNIQUE KEY `tag_name` (`tag_name`,`language`,`project_name`),
  KEY `tag_group` (`language`,`tag_group`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=547272 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_tags_word_mapping`
--

DROP TABLE IF EXISTS `product_tags_word_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_tags_word_mapping` (
  `ptwm_id` int(11) NOT NULL AUTO_INCREMENT,
  `ptw_id` int(11) NOT NULL,
  `pt_id` int(11) NOT NULL,
  `weight` decimal(10,2) NOT NULL,
  PRIMARY KEY (`ptwm_id`),
  UNIQUE KEY `uniq_id` (`ptw_id`,`pt_id`),
  KEY `pt_id` (`pt_id`),
  KEY `ptw_id` (`ptw_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_tags_words`
--

DROP TABLE IF EXISTS `product_tags_words`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_tags_words` (
  `ptw_id` int(11) NOT NULL AUTO_INCREMENT,
  `word_name` varchar(50) NOT NULL,
  PRIMARY KEY (`ptw_id`),
  UNIQUE KEY `word_name` (`word_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `region`
--

DROP TABLE IF EXISTS `region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `region` (
  `region_id` int(5) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(5) unsigned NOT NULL DEFAULT '0',
  `region_name` varchar(120) NOT NULL DEFAULT '',
  `region_type` tinyint(1) NOT NULL DEFAULT '2',
  `region_display` tinyint(4) NOT NULL DEFAULT '0',
  `region_code` varchar(2) NOT NULL DEFAULT '' COMMENT '缩写，两个字母or字符',
  `display_order` int(11) DEFAULT '100000' COMMENT '国家排序',
  PRIMARY KEY (`region_id`),
  KEY `parent_id` (`parent_id`),
  KEY `region_type` (`region_type`)
) ENGINE=InnoDB AUTO_INCREMENT=4492 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `region_seo`
--

DROP TABLE IF EXISTS `region_seo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `region_seo` (
  `region_id` int(11) NOT NULL AUTO_INCREMENT,
  `region_code` varchar(100) NOT NULL,
  `region_name` varchar(100) NOT NULL,
  `state_code` varchar(100) NOT NULL,
  `state_name` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `population` decimal(20,2) unsigned NOT NULL COMMENT '人口',
  `airport_code` varchar(100) NOT NULL,
  `postcode_begin` varchar(100) NOT NULL,
  `postcode_end` varchar(100) NOT NULL,
  `description` text NOT NULL COMMENT '城市介绍',
  `is_recommend` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`region_id`),
  KEY `region_code` (`region_code`),
  KEY `postcode_begin` (`postcode_begin`),
  KEY `postcode_end` (`postcode_end`),
  KEY `population` (`population`),
  KEY `is_recommend` (`is_recommend`),
  KEY `state_code` (`state_code`,`is_recommend`,`region_code`,`population`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=374204 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `send_email_log`
--

DROP TABLE IF EXISTS `send_email_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `send_email_log` (
  `sel_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `send_time` datetime NOT NULL,
  `status` smallint(3) NOT NULL,
  `message` varchar(255) NOT NULL COMMENT '记录邮件信息',
  PRIMARY KEY (`sel_id`),
  KEY `type` (`type`),
  KEY `email` (`email`),
  KEY `status` (`status`),
  KEY `message` (`message`)
) ENGINE=InnoDB AUTO_INCREMENT=714 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `sesskey` varchar(32) NOT NULL DEFAULT '',
  `expiry` int(10) unsigned NOT NULL DEFAULT '0',
  `userid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `adminid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ip` varchar(15) NOT NULL DEFAULT '',
  `data` longtext NOT NULL,
  PRIMARY KEY (`sesskey`),
  KEY `expiry` (`expiry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipping`
--

DROP TABLE IF EXISTS `shipping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shipping` (
  `shipping_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `party_id` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '组织id',
  `shipping_code` varchar(20) NOT NULL DEFAULT '',
  `shipping_name` varchar(120) NOT NULL DEFAULT '',
  `shipping_desc` varchar(255) NOT NULL DEFAULT '',
  `shipping_disabled_desc` varchar(255) NOT NULL DEFAULT '' COMMENT '配送方式在该地区不能用时的描述',
  `midway_address` varchar(500) NOT NULL DEFAULT '' COMMENT '物流中途中转地址',
  `insure` varchar(10) NOT NULL DEFAULT '0',
  `support_cod` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `shipping_order` tinyint(4) NOT NULL DEFAULT '0',
  `support_no_cod` tinyint(1) NOT NULL DEFAULT '1',
  `default_carrier_id` int(11) NOT NULL DEFAULT '0' COMMENT '该货运方式默认使用的快递公司',
  `support_biaoju` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否支持镖局',
  `contact_name` varchar(20) NOT NULL DEFAULT '' COMMENT '联系人名字',
  `contact_email` varchar(255) NOT NULL DEFAULT '' COMMENT '联系邮箱',
  `contact_phone` varchar(20) NOT NULL DEFAULT '' COMMENT '联系电话',
  `self_work_time` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`shipping_id`),
  KEY `shipping_code` (`shipping_code`,`enabled`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipping_method`
--

DROP TABLE IF EXISTS `shipping_method`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shipping_method` (
  `sm_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `sm_fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '费用',
  `currency_id` int(11) NOT NULL DEFAULT '0' COMMENT '币种ID',
  `sm_desc` text NOT NULL COMMENT '货运方式的说明，中文，方便我们查看',
  `disabled` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0启用；1禁用',
  `display_order` smallint(6) NOT NULL COMMENT '排序',
  `config` text NOT NULL COMMENT '配置信息，货运时间 6 - 8 等',
  PRIMARY KEY (`sm_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipping_method_area`
--

DROP TABLE IF EXISTS `shipping_method_area`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shipping_method_area` (
  `sma_id` int(11) NOT NULL AUTO_INCREMENT,
  `region_id` int(11) NOT NULL DEFAULT '0',
  `sm_id` smallint(6) NOT NULL DEFAULT '0',
  `sm_area` varchar(60) NOT NULL,
  PRIMARY KEY (`sma_id`),
  UNIQUE KEY `region_id` (`region_id`,`sm_id`,`sm_area`)
) ENGINE=InnoDB AUTO_INCREMENT=671 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipping_method_fee`
--

DROP TABLE IF EXISTS `shipping_method_fee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shipping_method_fee` (
  `smf_id` int(11) NOT NULL AUTO_INCREMENT,
  `sm_area` varchar(60) NOT NULL DEFAULT '' COMMENT '快递分区',
  `basic_fee` decimal(10,2) NOT NULL COMMENT '首重费用，人民币',
  `basic_weight` decimal(10,0) NOT NULL COMMENT '首重',
  `additional_fee` decimal(10,2) NOT NULL COMMENT '续重费，人民币',
  `additional_weight` int(11) NOT NULL COMMENT '续重，单位克',
  `discount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '折扣比率',
  `baf` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '燃油附加费，比率',
  `fixed_fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '挂号费、报关费等固定费用，人民币',
  PRIMARY KEY (`smf_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COMMENT='按地区算货运费用';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipping_method_language`
--

DROP TABLE IF EXISTS `shipping_method_language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shipping_method_language` (
  `sml_id` int(11) NOT NULL AUTO_INCREMENT,
  `sm_id` smallint(6) NOT NULL DEFAULT '0',
  `language_id` smallint(6) NOT NULL DEFAULT '0',
  `sml_title` varchar(255) NOT NULL DEFAULT '' COMMENT 'like "Expedited Shipping" or "Standard Shipping"',
  `sml_desc` text NOT NULL COMMENT '描述信息',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
  `last_update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  PRIMARY KEY (`sml_id`),
  UNIQUE KEY `sm_id` (`sm_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shop_config`
--

DROP TABLE IF EXISTS `shop_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shop_config` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `code` varchar(100) NOT NULL DEFAULT '',
  `type` varchar(10) NOT NULL DEFAULT '',
  `store_range` varchar(255) NOT NULL DEFAULT '',
  `store_dir` varchar(255) NOT NULL DEFAULT '',
  `value` text NOT NULL,
  `title` varchar(50) NOT NULL COMMENT 'code所对应的说明文字',
  `project_name` varchar(100) NOT NULL DEFAULT '' COMMENT '项目名',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`,`project_name`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shopping_cart`
--

DROP TABLE IF EXISTS `shopping_cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shopping_cart` (
  `rec_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `session_id` varchar(32) NOT NULL DEFAULT '',
  `goods_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `goods_sn` varchar(60) NOT NULL DEFAULT '',
  `goods_name` varchar(120) NOT NULL DEFAULT '',
  `market_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `shop_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `goods_number` smallint(5) unsigned NOT NULL DEFAULT '0',
  `goods_attr` text NOT NULL,
  `is_real` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `extension_code` varchar(30) NOT NULL DEFAULT '',
  `parent_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `rec_type` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_gift` smallint(5) unsigned NOT NULL DEFAULT '0',
  `can_handsel` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `style_id` int(10) unsigned NOT NULL DEFAULT '0',
  `styles` text NOT NULL COMMENT '各种样式，json',
  PRIMARY KEY (`rec_id`),
  KEY `session_id` (`session_id`),
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=574338 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `style`
--

DROP TABLE IF EXISTS `style`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `style` (
  `style_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `cat_id` smallint(5) NOT NULL DEFAULT '0',
  `name` varchar(200) NOT NULL DEFAULT '',
  `value` varchar(200) NOT NULL DEFAULT '',
  `parent_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `is_show` tinyint(1) NOT NULL DEFAULT '1',
  `display_order` int(11) NOT NULL DEFAULT '0' COMMENT '显示排序',
  PRIMARY KEY (`style_id`),
  KEY `type` (`parent_id`),
  KEY `value` (`value`)
) ENGINE=InnoDB AUTO_INCREMENT=3121 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `style_languages`
--

DROP TABLE IF EXISTS `style_languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `style_languages` (
  `sl_id` mediumint(8) NOT NULL AUTO_INCREMENT,
  `style_id` mediumint(8) NOT NULL DEFAULT '0',
  `languages_id` tinyint(3) NOT NULL DEFAULT '0',
  `name` varchar(60) NOT NULL DEFAULT '',
  `value` varchar(60) NOT NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
  `last_update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  PRIMARY KEY (`sl_id`),
  UNIQUE KEY `style_id` (`style_id`,`languages_id`),
  KEY `languages_id` (`languages_id`)
) ENGINE=InnoDB AUTO_INCREMENT=42137 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_access_pca`
--

DROP TABLE IF EXISTS `sys_access_pca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_access_pca` (
  `pca_id` int(11) NOT NULL AUTO_INCREMENT,
  `pca_basepath` varchar(32) NOT NULL DEFAULT '',
  `pca_controller` varchar(32) NOT NULL DEFAULT '',
  `pca_filename` varchar(255) NOT NULL DEFAULT '',
  `pca_powers` text NOT NULL,
  `pca_name` varchar(60) NOT NULL DEFAULT '',
  `pca_desc` text NOT NULL,
  PRIMARY KEY (`pca_id`),
  UNIQUE KEY `pca_basepath` (`pca_basepath`,`pca_controller`)
) ENGINE=InnoDB AUTO_INCREMENT=487 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_account`
--

DROP TABLE IF EXISTS `sys_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_account` (
  `acct_id` int(11) NOT NULL AUTO_INCREMENT,
  `acct_disable` tinyint(1) NOT NULL DEFAULT '0' COMMENT '账户是否禁用 默认0-可用',
  `acct_main` int(11) NOT NULL DEFAULT '0',
  `acct_email` varchar(60) NOT NULL DEFAULT '',
  `acct_cell` varchar(13) DEFAULT NULL,
  `acct_pswd` varchar(32) NOT NULL DEFAULT '*',
  `acct_alias` varchar(50) NOT NULL DEFAULT '',
  `acct_realname` varchar(100) NOT NULL DEFAULT '' COMMENT '账户真实名称',
  `acct_local` varchar(8) NOT NULL DEFAULT '',
  `acct_opts` int(11) NOT NULL DEFAULT '0',
  `acct_ctime` int(11) NOT NULL DEFAULT '0',
  `acct_mtime` int(11) NOT NULL DEFAULT '0',
  `acct_expc` int(11) NOT NULL DEFAULT '100',
  `acct_level` int(4) NOT NULL DEFAULT '1',
  `acct_gid` int(4) NOT NULL DEFAULT '1',
  `acct_points` int(11) NOT NULL DEFAULT '0',
  `acct_zipcode` varchar(10) NOT NULL DEFAULT '',
  `acct_cip` int(11) NOT NULL DEFAULT '0',
  `acct_last_ip` int(11) NOT NULL DEFAULT '0',
  `acct_last_visit` int(11) NOT NULL DEFAULT '0',
  `acct_last_activity` int(11) NOT NULL DEFAULT '0',
  `acct_birthday` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`acct_id`),
  UNIQUE KEY `acct_alias` (`acct_alias`),
  UNIQUE KEY `acct_email` (`acct_email`(30)),
  UNIQUE KEY `acct_cell` (`acct_cell`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_permission`
--

DROP TABLE IF EXISTS `sys_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_permission` (
  `role_id` int(10) unsigned NOT NULL DEFAULT '0',
  `perm_content` longtext NOT NULL,
  UNIQUE KEY `role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_role` (
  `role_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_name` varchar(64) NOT NULL DEFAULT '' COMMENT '角色名称',
  `role_ctime` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `role_etime` int(11) NOT NULL DEFAULT '0' COMMENT '过期时间',
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_user_role` (
  `username` varchar(60) NOT NULL DEFAULT '',
  `role_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`username`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `temp_lang_data`
--

DROP TABLE IF EXISTS `temp_lang_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp_lang_data` (
  `A` varchar(254) DEFAULT NULL,
  `B` varchar(239) DEFAULT NULL,
  `C` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `temp_send_email`
--

DROP TABLE IF EXISTS `temp_send_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp_send_email` (
  `order_id` int(11) NOT NULL,
  `order_time` datetime DEFAULT NULL,
  `order_sn` varchar(20) DEFAULT '',
  `email` varchar(128) DEFAULT '',
  `region_name` varchar(128) DEFAULT '',
  `user_name` varchar(128) DEFAULT '',
  `project_name` varchar(60) DEFAULT '',
  `party_id` int(11) DEFAULT '0',
  `status` smallint(6) DEFAULT '0',
  UNIQUE KEY `order_id` (`order_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `temp_weekly_deal_order_stat`
--

DROP TABLE IF EXISTS `temp_weekly_deal_order_stat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp_weekly_deal_order_stat` (
  `cat_name` varchar(90) NOT NULL DEFAULT '',
  `cat_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `goods_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `cnt` bigint(21) NOT NULL DEFAULT '0',
  `amount` decimal(38,2) DEFAULT NULL,
  `discount` decimal(24,10) DEFAULT NULL,
  KEY `weekly_deal_cat_index` (`cat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ticket_sequence`
--

DROP TABLE IF EXISTS `ticket_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_sequence` (
  `sequence_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ticket sequence',
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11274186 DEFAULT CHARSET=utf8 COMMENT='ticket sequence';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_c_attr_goods`
--

DROP TABLE IF EXISTS `tmp_c_attr_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_c_attr_goods` (
  `attr_pid` int(11) NOT NULL DEFAULT '0',
  `attr_id` int(11) NOT NULL DEFAULT '0',
  `cat_id` int(11) NOT NULL DEFAULT '0',
  `project_name` varchar(60) NOT NULL DEFAULT '',
  `goods_nos` varbinary(60000) NOT NULL DEFAULT '',
  `last_update_time` int(11) NOT NULL DEFAULT '0' COMMENT '重建时间标志位',
  UNIQUE KEY `attr_pid` (`attr_pid`,`attr_id`,`cat_id`,`project_name`),
  KEY `cat_id` (`cat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_c_attr_goods_filter`
--

DROP TABLE IF EXISTS `tmp_c_attr_goods_filter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_c_attr_goods_filter` (
  `attr_pid` int(11) NOT NULL DEFAULT '0',
  `attr_id` int(11) NOT NULL DEFAULT '0',
  `cat_id` int(11) NOT NULL DEFAULT '0',
  `project_name` varchar(60) NOT NULL DEFAULT '',
  `goods_nos` varbinary(10000) NOT NULL DEFAULT '',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0',
  `last_update_time` int(11) NOT NULL DEFAULT '0',
  `same_attr_id` varchar(500) NOT NULL DEFAULT '0',
  `attr_name` varchar(60) NOT NULL DEFAULT '',
  `attr_values` varchar(200) NOT NULL DEFAULT '',
  UNIQUE KEY `cat_id` (`cat_id`,`attr_name`,`attr_values`,`project_name`),
  UNIQUE KEY `attr_pid` (`cat_id`,`attr_pid`,`attr_id`,`project_name`),
  KEY `attr_id` (`attr_id`),
  KEY `project_name` (`project_name`,`last_update_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_c_goods_no`
--

DROP TABLE IF EXISTS `tmp_c_goods_no`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_c_goods_no` (
  `goods_index` int(11) NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) NOT NULL DEFAULT '0',
  `project_name` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`goods_index`),
  UNIQUE KEY `goods_id` (`goods_id`,`project_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6949733 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_c_goods_no_filter`
--

DROP TABLE IF EXISTS `tmp_c_goods_no_filter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_c_goods_no_filter` (
  `goods_index` int(11) NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) NOT NULL DEFAULT '0',
  `project_name` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`goods_index`)
) ENGINE=MyISAM AUTO_INCREMENT=6137178 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_cocktail_dresses_lchen`
--

DROP TABLE IF EXISTS `tmp_cocktail_dresses_lchen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_cocktail_dresses_lchen` (
  `goods_id` mediumint(8) unsigned NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_goods_attr_map_2`
--

DROP TABLE IF EXISTS `tmp_goods_attr_map_2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_goods_attr_map_2` (
  `goods_id` int(11) NOT NULL DEFAULT '0',
  `weekly_deal` int(11) NOT NULL DEFAULT '0',
  `attr_1` int(11) NOT NULL DEFAULT '0',
  `attr_8` int(11) NOT NULL DEFAULT '0',
  `attr_18` int(11) NOT NULL DEFAULT '0',
  `attr_29` int(11) NOT NULL DEFAULT '0',
  `attr_37` int(11) NOT NULL DEFAULT '0',
  `attr_57` int(11) NOT NULL DEFAULT '0',
  `attr_67` int(11) NOT NULL DEFAULT '0',
  `attr_73` int(11) NOT NULL DEFAULT '0',
  `attr_1520` int(11) NOT NULL DEFAULT '0',
  `attr_1526` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `goods_id` (`goods_id`),
  KEY `weekly_deal` (`weekly_deal`),
  KEY `attr_1` (`attr_1`),
  KEY `attr_8` (`attr_8`),
  KEY `attr_18` (`attr_18`),
  KEY `attr_29` (`attr_29`),
  KEY `attr_37` (`attr_37`),
  KEY `attr_57` (`attr_57`),
  KEY `attr_67` (`attr_67`),
  KEY `attr_73` (`attr_73`),
  KEY `attr_1520` (`attr_1520`),
  KEY `attr_1526` (`attr_1526`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_goods_attr_map_7`
--

DROP TABLE IF EXISTS `tmp_goods_attr_map_7`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_goods_attr_map_7` (
  `goods_id` int(11) NOT NULL DEFAULT '0',
  `weekly_deal` int(11) NOT NULL DEFAULT '0',
  `attr_531` int(11) NOT NULL DEFAULT '0',
  `attr_537` int(11) NOT NULL DEFAULT '0',
  `attr_547` int(11) NOT NULL DEFAULT '0',
  `attr_562` int(11) NOT NULL DEFAULT '0',
  `attr_569` int(11) NOT NULL DEFAULT '0',
  `attr_577` int(11) NOT NULL DEFAULT '0',
  `attr_582` int(11) NOT NULL DEFAULT '0',
  `attr_588` int(11) NOT NULL DEFAULT '0',
  `attr_1427` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `goods_id` (`goods_id`),
  KEY `weekly_deal` (`weekly_deal`),
  KEY `attr_531` (`attr_531`),
  KEY `attr_537` (`attr_537`),
  KEY `attr_547` (`attr_547`),
  KEY `attr_562` (`attr_562`),
  KEY `attr_569` (`attr_569`),
  KEY `attr_577` (`attr_577`),
  KEY `attr_582` (`attr_582`),
  KEY `attr_588` (`attr_588`),
  KEY `attr_1427` (`attr_1427`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `translation`
--

DROP TABLE IF EXISTS `translation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translation` (
  `old` text NOT NULL COMMENT '待翻译原始数据',
  `old_md5` char(32) NOT NULL DEFAULT '' COMMENT '字段`old`的MD5值',
  `new` text NOT NULL COMMENT '待翻译原始数据去掉\r\n空格等特殊字符的新值',
  `new_md5` char(32) NOT NULL DEFAULT '' COMMENT '字段`new`的MD5值',
  `de` text NOT NULL COMMENT '翻译后数据(德语)',
  `fr` text NOT NULL COMMENT '翻译后数据(法语)',
  `es` text NOT NULL COMMENT '翻译后数据(西班牙语)',
  `se` text NOT NULL COMMENT '翻译后数据(瑞典语)',
  `no` text NOT NULL COMMENT '翻译后数据(挪威语)',
  `it` text NOT NULL COMMENT '翻译后数据(意大利语)',
  `pt` text NOT NULL COMMENT '翻译后数据(葡萄牙语)',
  `da` text NOT NULL COMMENT '丹麦语',
  UNIQUE KEY `old_md5` (`old_md5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跟 translation 表结合使用';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `translation_map`
--

DROP TABLE IF EXISTS `translation_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translation_map` (
  `map_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '翻译记录自增ID',
  `code` varchar(200) NOT NULL DEFAULT '' COMMENT 'code命名规则：data_(第一次导入时的en数据,截取前10个字节，非字母数字的去掉)_tableName_fieldName_md5(第一次导入时的en)',
  `table_name` varchar(100) NOT NULL DEFAULT '' COMMENT '待翻译原始数据所属表名',
  `field_id` int(11) NOT NULL DEFAULT '0' COMMENT '待翻译原始数据所属字段id',
  `field_name` varchar(100) NOT NULL DEFAULT '' COMMENT '待翻译原始数据所属字段名称',
  `field_value` text NOT NULL COMMENT '待翻译原始数据值',
  `md5sum` char(32) NOT NULL DEFAULT '' COMMENT '待翻译原始数据(feild_value)的MD5值',
  `field_id_name` varchar(50) NOT NULL DEFAULT '' COMMENT 'field_id对应的字段名',
  PRIMARY KEY (`map_id`),
  UNIQUE KEY `table_name` (`table_name`,`field_id`,`field_name`)
) ENGINE=InnoDB AUTO_INCREMENT=1422177 DEFAULT CHARSET=utf8 COMMENT='从各表导出数据到此表，此表再到translation表；翻译好之后再导回原表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_active_record`
--

DROP TABLE IF EXISTS `user_active_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_active_record` (
  `active_id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) NOT NULL DEFAULT '0' COMMENT '用户id',
  `email` varchar(255) NOT NULL DEFAULT '' COMMENT '用户email',
  `jjsid` varchar(32) NOT NULL DEFAULT '' COMMENT 'jessionid',
  `jjstid` varchar(60) NOT NULL DEFAULT '',
  `jjcid` smallint(6) NOT NULL DEFAULT '0' COMMENT '货币id',
  `ip` int(11) NOT NULL DEFAULT '0' COMMENT '用户ip',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '用户活动时间',
  `user_agent_id` int(11) NOT NULL DEFAULT '0' COMMENT '浏览器类型id',
  `http_referer` varchar(32) NOT NULL DEFAULT '' COMMENT '完整的url',
  `c_url` varchar(32) NOT NULL DEFAULT '' COMMENT '当前的相对URL',
  PRIMARY KEY (`active_id`),
  KEY `create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=139639 DEFAULT CHARSET=utf8 COMMENT='用户活动信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_address`
--

DROP TABLE IF EXISTS `user_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_address` (
  `address_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `address_type` varchar(20) NOT NULL DEFAULT 'SHIPPING' COMMENT 'SHIPPING, BILLING',
  `address_name` varchar(50) NOT NULL DEFAULT '',
  `user_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `consignee` varchar(60) NOT NULL DEFAULT '',
  `first_name` varchar(60) NOT NULL DEFAULT '',
  `last_name` varchar(60) NOT NULL DEFAULT '',
  `gender` enum('male','female','unknown') NOT NULL DEFAULT 'unknown' COMMENT '性别',
  `email` varchar(60) NOT NULL DEFAULT '',
  `country` smallint(5) NOT NULL DEFAULT '0',
  `province` smallint(5) NOT NULL DEFAULT '0',
  `city` smallint(5) NOT NULL DEFAULT '0',
  `district` smallint(5) NOT NULL DEFAULT '0',
  `address` varchar(120) NOT NULL DEFAULT '',
  `zipcode` varchar(60) NOT NULL DEFAULT '',
  `tel` varchar(60) NOT NULL DEFAULT '',
  `mobile` varchar(60) NOT NULL DEFAULT '',
  `sign_building` varchar(120) NOT NULL DEFAULT '',
  `best_time` varchar(120) NOT NULL DEFAULT '',
  `province_text` varchar(100) NOT NULL DEFAULT '' COMMENT '省/直辖市，输入',
  `city_text` varchar(100) NOT NULL DEFAULT '' COMMENT '市/区，输入',
  `district_text` varchar(100) NOT NULL DEFAULT '' COMMENT '县/区，输入',
  `is_default` tinyint(1) DEFAULT '0' COMMENT '是否是默认配送地址',
  `tax_code_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'CPF or CNPJ code type',
  `tax_code_value` varchar(20) NOT NULL DEFAULT '' COMMENT 'CPF or CNPJ code value',
  PRIMARY KEY (`address_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=113508 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_agent`
--

DROP TABLE IF EXISTS `user_agent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_agent` (
  `user_agent_id` int(10) NOT NULL AUTO_INCREMENT,
  `agent_type` varchar(255) NOT NULL DEFAULT '' COMMENT '浏览器版本号',
  `md5_agent` varchar(32) DEFAULT '',
  PRIMARY KEY (`user_agent_id`),
  KEY `md5_agent` (`md5_agent`)
) ENGINE=InnoDB AUTO_INCREMENT=86421 DEFAULT CHARSET=utf8 COMMENT='HTTP USER AGENT 表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_login_record`
--

DROP TABLE IF EXISTS `user_login_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_login_record` (
  `login_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) NOT NULL DEFAULT '0' COMMENT '用户id',
  `email` varchar(255) NOT NULL DEFAULT '' COMMENT '用户email',
  `jjsid` varchar(32) NOT NULL DEFAULT '' COMMENT 'jsessionid',
  `jjstid` varchar(60) NOT NULL DEFAULT '',
  `jjcid` smallint(6) NOT NULL DEFAULT '0' COMMENT '货币id',
  `ip` int(11) NOT NULL DEFAULT '0' COMMENT '用户当前ip',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '登录时间',
  `user_agent_id` int(10) NOT NULL DEFAULT '0' COMMENT '浏览器类型id',
  `http_referer` varchar(32) NOT NULL DEFAULT '' COMMENT '完整URL',
  `login_result` enum('OTHER','ACCOUNT_MISSING','ACCOUNT_NOT_EXISTS','PASSWORD_MISSING','PASSWORD_ERROR','ALREADY_LOGGED','SUCCESS','FAILED') NOT NULL DEFAULT 'FAILED',
  PRIMARY KEY (`login_id`)
) ENGINE=InnoDB AUTO_INCREMENT=233212 DEFAULT CHARSET=utf8 COMMENT='用户登录信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_url`
--

DROP TABLE IF EXISTS `user_url`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_url` (
  `url_md5` varchar(32) NOT NULL DEFAULT '' COMMENT 'url的md5字符串',
  `url_content` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`url_md5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='url 表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userId` char(32) NOT NULL,
  `email` varchar(60) NOT NULL DEFAULT '',
  `user_name` varchar(60) NOT NULL DEFAULT '',
  `password` varchar(32) NOT NULL DEFAULT '',
  `question` varchar(255) NOT NULL DEFAULT '',
  `answer` varchar(255) NOT NULL DEFAULT '',
  `gender` enum('male','female') DEFAULT 'male',
  `birthday` date NOT NULL DEFAULT '0000-00-00',
  `address_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `reg_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_ip` varchar(15) NOT NULL DEFAULT '',
  `visit_count` smallint(5) unsigned NOT NULL DEFAULT '0',
  `user_rank` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `is_special` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `salt` varchar(10) NOT NULL DEFAULT '0',
  `user_realname` varchar(60) NOT NULL COMMENT '真是姓名',
  `user_mobile` varchar(20) NOT NULL COMMENT '手机',
  `country` smallint(5) NOT NULL DEFAULT '0',
  `province` smallint(5) NOT NULL DEFAULT '0',
  `city` smallint(5) NOT NULL DEFAULT '0',
  `district` smallint(5) NOT NULL DEFAULT '0',
  `zipcode` varchar(60) NOT NULL,
  `user_address` varchar(255) NOT NULL COMMENT '联系地址',
  `track_id` char(32) NOT NULL,
  `reg_source` int(10) unsigned NOT NULL COMMENT '注册来源',
  `reg_province` int(10) unsigned NOT NULL COMMENT '注册来源地',
  `reg_recommender` varchar(50) NOT NULL DEFAULT 'jjshouse' COMMENT '注册推荐人',
  `user_tel` varchar(20) DEFAULT NULL,
  `email_valid` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否通过邮件验证',
  `email_validate_point_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '通过邮件验证时所发放的积分ID',
  `unsubscribe` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否取消邮件订阅',
  `is_delete` tinyint(4) NOT NULL DEFAULT '0' COMMENT '帐号删除',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `userId` (`userId`),
  UNIQUE KEY `email` (`email`,`reg_recommender`),
  KEY `reg_time` (`reg_time`),
  KEY `user_name` (`user_name`),
  KEY `unsubscribe` (`unsubscribe`),
  KEY `password` (`password`)
) ENGINE=InnoDB AUTO_INCREMENT=129990 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users_goods_favorites`
--

DROP TABLE IF EXISTS `users_goods_favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_goods_favorites` (
  `user_id` int(11) NOT NULL DEFAULT '0',
  `goods_id` int(11) NOT NULL DEFAULT '0',
  `last_update_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `is_delete` tinyint(4) NOT NULL DEFAULT '0' COMMENT '1删除',
  UNIQUE KEY `user_id` (`user_id`,`goods_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户收藏商品记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `weekly_deal`
--

DROP TABLE IF EXISTS `weekly_deal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weekly_deal` (
  `wd_id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `is_display` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`wd_id`),
  KEY `goods_id` (`goods_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38914 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-12-26 20:17:52
