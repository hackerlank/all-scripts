<?php

const ATTR_IN_ATTRIBUTE = 1;
const ATTR_IN_FILTER = 2;
const ATTR_IN_NAME = 4;

	/**
	 * php htm/index.php "cronjob/rebuildFilter2/project_name/JJsHouse"
	 * 
	 * @return boolean
	 */
	function rebuildFilter2Action($db, $project_name)
	{
		echo "start " . __FUNCTION__ . " at " . date("Y-m-d H:i:s") . "\n";
		echo "project name is $project_name\n";
		
		// {{{ goods 排序索引
		$sql = "CREATE TABLE IF NOT EXISTS `tmp_c_goods_no_filter` (
				  `goods_index` int(11) NOT NULL AUTO_INCREMENT,
				  `goods_id` int(11) NOT NULL DEFAULT '0',
				  `project_name` varchar(60) NOT NULL DEFAULT '',
				  PRIMARY KEY (`goods_index`)
				) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1";
		$db->exec($sql);
		//$sql = "TRUNCATE TABLE `tmp_c_goods_no_filter`";
		$sql = "DELETE FROM `tmp_c_goods_no_filter` WHERE project_name = '" . $project_name . "' ";
		$db->exec($sql);
		$sql = "insert ignore into `tmp_c_goods_no_filter` (goods_id, project_name) 
				SELECT g.goods_id, '" . $project_name . "'
				FROM `goods` As g
					-- LEFT JOIN `category` AS c ON c.cat_id = g.cat_id
					LEFT JOIN goods_languages AS gl ON g.goods_id = gl.goods_id
					LEFT JOIN goods_display_order AS gd ON gd.goods_id = g.goods_id AND gd.project_name = '" . $project_name . "'
					-- LEFT JOIN goods_extension AS ge ON ge.goods_id = g.goods_id AND ge.is_display = 1 AND ge.ext_name = 'weekly_deal'
					LEFT JOIN goods_project AS gp ON gp.goods_id = g.goods_id AND gp.project_name = '" . $project_name . "'
				WHERE 1 
					AND gl.languages_id = 1
					AND g.is_on_sale = 1
					AND g.is_display = 1
					AND g.is_delete = 0
					AND gp.goods_thumb != ''
					AND gp.shop_price > 0
				GROUP BY g.goods_id
				ORDER BY g.goods_id ASC
				/*
				ORDER BY gd.sales_order + ( 
							CASE true
								WHEN ISNULL(gd.effective_cat_id) THEN gd.goods_order + gd.virtual_sales_order
								WHEN gd.effective_cat_id = g.cat_id THEN gd.goods_order + gd.virtual_sales_order
								ELSE 0
							END
						) DESC
				*/ ";
		$db->exec($sql);
		// }}}
		// {{{ 填充属性ID
		$sql = "CREATE TABLE IF NOT EXISTS `tmp_c_attr_goods_filter` (
				  `attr_pid` int(11) NOT NULL DEFAULT '0',
				  `attr_id` int(11) NOT NULL DEFAULT '0',
				  `cat_id` int(11) NOT NULL DEFAULT '0',
				  `project_name` varchar(60) NOT NULL DEFAULT '',
				  `goods_nos` MEDIUMBLOB NULL,
				  `is_delete` tinyint(1) NOT NULL DEFAULT 0,
				  `last_update_time` int(11) NOT NULL DEFAULT 0,
				  `same_attr_id` varchar(500) NOT NULL DEFAULT 0,
				  `attr_name` varchar(60) NOT NULL DEFAULT '',
				  `attr_values` varchar(200) NOT NULL DEFAULT '',
				  UNIQUE KEY `attr_pid` (`cat_id`,`attr_pid`,`attr_id`,`project_name`,`last_update_time`),
				  UNIQUE KEY `cat_id` (`cat_id`,`attr_name`,`attr_values`,`project_name`,`last_update_time`),
				  KEY `attr_id` (`attr_id`),
				  KEY `project_name` (`project_name`,`last_update_time`)
				) ENGINE=MyISAM DEFAULT CHARSET=utf8;";
		$db->exec($sql);
		
		/*********************************获取下级所有分类ID START *********************************/
		function getChildCatId($cat_ids_all, $parent_id, &$cat_child_ids)
		{
			foreach ($cat_ids_all as $k => $v)
			{
				if ($v['parent_id'] == $parent_id)
				{
					$cat_child_ids[] = $v['cat_id'];
					getChildCatId($cat_ids_all, $v['cat_id'], $cat_child_ids);
				}
			}
		}
		
		$last_update_time = time();
		
		$sql = "SELECT COUNT(1) AS total,last_update_time  
				FROM tmp_c_attr_goods_filter 
				WHERE last_update_time > 1 
					AND is_delete = 1
					AND project_name = '" . $project_name . "'";
		$is_run = $db->query($sql)->fetch();
		// 一小时后如果还存在last_update_time > 0 的记录则强制重建
		if ($is_run['total'] && $last_update_time - $is_run['last_update_time'] < 3600)
		{
			echo "{$project_name} rebuilt filter2 doing...\n";
			return;
		}
		
		$sql = "DELETE FROM tmp_c_attr_goods_filter
				WHERE is_delete = 1
					AND project_name = '{$project_name}'
					AND last_update_time != {$last_update_time}
				";
		$db->exec($sql);
		
		$sql = "SELECT cat_id,parent_id FROM category 
				WHERE is_show = 1 
					AND cat_id > 1 AND (cat_id != 5 AND parent_id != 5 OR cat_id IN(6, 13))
					-- AND (parent_id !=84 OR cat_id = 47 OR cat_id = 53 OR cat_id = 88 OR cat_id = 86) AND cat_id != 84";
		$cat_ids_all = $db->query($sql)->fetchAll();
		$category = array();
		
		foreach ($cat_ids_all as $k => $v)
		{
			$cat_child_ids = array($v['cat_id']);
			getChildCatId($cat_ids_all, $v['cat_id'], $cat_child_ids);
			$category[$v['cat_id']] = $cat_child_ids;
		}
		/*********************************获取下级所有分类ID END *********************************/
		
		// 插入属性值，并合并attr_name和attr_value相同的属性值
		
		foreach ($category as $k => $v)
		{
			$category_child = implode(',', $v);
			$sql = "INSERT IGNORE INTO tmp_c_attr_goods_filter (attr_pid, attr_id, cat_id, project_name, last_update_time, same_attr_id, attr_name, attr_values, is_delete)
					SELECT DISTINCT(a.parent_id) AS attr_pid, a.attr_id, {$k}, '" . $project_name . "', {$last_update_time}, a.attr_id, al.attr_name, al.attr_values, 1
					FROM attribute a INNER JOIN attribute_languages al ON a.attr_id=al.attr_id AND al.languages_id=1
					WHERE a.parent_id > 0 AND a.is_delete = 0 AND a.is_show = 1 AND a.cat_id IN({$category_child}) AND a.display_filter & ".ATTR_IN_FILTER." != 0
			 		/*ON DUPLICATE KEY UPDATE last_update_time = {$last_update_time}, 
				          		same_attr_id = IF(attr_pid = a.parent_id AND tmp_c_attr_goods_filter.attr_id = a.attr_id, same_attr_id, CONCAT(same_attr_id, ',', a.attr_id))*/";
			$db->exec($sql);
		}
		
		$sql = "UPDATE tmp_c_attr_goods_filter a
					INNER JOIN (SELECT * 
								FROM tmp_c_attr_goods_filter 
								WHERE project_name = '{$project_name}' 
									AND last_update_time = {$last_update_time}
								ORDER BY attr_pid) b ON a.cat_id = b.cat_id
				SET a.attr_pid = b.attr_pid
				WHERE a.attr_pid > b.attr_pid
					AND a.attr_id != b.attr_id
					AND a.attr_name = b.attr_name
					AND a.project_name = '{$project_name}'
					AND a.last_update_time = {$last_update_time} 
					";
		$db->exec($sql);
		// }}}
		
		// {{{ 填充每个属性的商品
		$sql = "SELECT goods_id 
				FROM tmp_c_goods_no_filter 
				WHERE project_name = '" . $project_name . "'
				ORDER BY goods_id ASC
				 ";
		$goods_index = $db->query($sql)->fetchAll();
		$goods_index_tmp = array();
		foreach ($goods_index as $v) {
			$goods_index_tmp['g'. $v['goods_id']] = 0;
		}
		
		$sql = "SELECT * 
				FROM tmp_c_attr_goods_filter 
				WHERE project_name = '" . $project_name . "' 
					AND last_update_time = {$last_update_time} ";
		$tmp_c_attr_goods = $db->query($sql)->fetchAll();
		
		foreach ($tmp_c_attr_goods as $_attr_goods) {
			
			$category_child = implode(',', $category[$_attr_goods['cat_id']]);
			$attr_name = addslashes($_attr_goods['attr_name']);
			$attr_values = addslashes($_attr_goods['attr_values']);
			
			$sql = "SELECT gc.goods_id
					FROM goods_category gc
						INNER JOIN goods_attr ga ON ga.goods_id = gc.goods_id
						INNER JOIN attribute_languages al ON al.attr_id = ga.attr_id 
					WHERE  gc.cat_id IN({$category_child})
						AND ga.is_delete = 0 
						AND ga.is_show = if(al.attr_name='Price', ga.is_show, 1)
						AND al.languages_id = 1
						AND al.attr_name='{$attr_name}'
						AND al.attr_values='{$attr_values}'
					";
			$_goods_attr = $db->query($sql)->fetchAll();
			$goods_attr = array();
			foreach ($_goods_attr as $_v) {
				$goods_attr['g' . $_v['goods_id']] = 1;
			}
			
			$_tmp_gids = count($goods_attr);
			if ($_tmp_gids) 
			{
				// $goods_index_tmp 是上架商品，$goods_attr是包含指定属性的商品，未必上架，所以此处计算$goods_attr中上架的商品
				$tmp = array_intersect_key($goods_attr, $goods_index_tmp);
				$tmp = array_merge($goods_index_tmp, $tmp);
				$_tmp_gids = implode('', $tmp);
			}
			$sql = "UPDATE tmp_c_attr_goods_filter 
					SET goods_nos = '$_tmp_gids' 
					WHERE cat_id = '{$_attr_goods['cat_id']}' 
						AND attr_id = '{$_attr_goods['attr_id']}'
						AND project_name = '" . $project_name . "'
						AND last_update_time = {$last_update_time}";
			$db->exec($sql);
		}
		
		// {{{ 删除上一次建立的需要删除的数据
		$sql = "UPDATE tmp_c_attr_goods_filter 
				SET is_delete = if(last_update_time != {$last_update_time}, 1, 0), 
					last_update_time = if(last_update_time != {$last_update_time}, 1, 0) 
				WHERE project_name = '{$project_name}'
				";
		$db->exec($sql);
		// }}}
		echo "end " . __FUNCTION__ . " at " . date("Y-m-d H:i:s") . "\n";
	}


