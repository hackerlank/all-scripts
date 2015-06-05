<?php
$siteConf = array_merge($siteConf, array(
    'theme' => 'jjshouse',
    'cdn' => array(
        '__CDN_IMG1__/upimg/',
    ),

    'rush_order_fee_date' => array(
        /*
		'within3week' => array(
			'date_start' => 1,
			'date_end' => 14,
			'fee' => 19.99
		),
		'week_3_5' => array(
			'date_start' => 15,
			'date_end' => 21,
			'fee' => 9.99
		)*/
    ),
    'free_shipping_time' => array(
        'start_time' => '2000-01-01 00:00:00',
        'end_time' => '2000-01-01 00:00:00',
    ),
    'category_free_shipping' => array(
        34
    ),
    'goods_free_shipping' => array(),
    'shipping_off' => array(
        1 => '57%', // 按原始的43%收取
        2 => '55%', // 按原始的45%收取
        3 => ''
    ),
    'shipping_off_70_percent' => array(
        'start_time' => '2011-07-15 00:00:00',
        'end_time' => '2020-07-17 23:59:59'
    ),
    'plussize_fee' => 7.99,
    'custom_fee' => date("Ymd") >= 20110404 ? 19.99 : 0,

	'goods_none_size' => array(3911,4054,5747,3849,2531,2337,4236,5745,2516,2334,3808,3848,3850,3851,4152,12528,4137,3853,
									3909,3917,5746,12517,12851,13302,15986,15987,16014,3809,3910,3918,4043,4045,4050,4051,5751,
									11952,12519,12520,12521,12523,12524,12525,12526,12527,12530,12532,12533,12534,12535,12536,
									12538,12540,12541,12542,12543,12544,12545,12546,12547,12549,12550,12551,12552,12553,12554,
									12621,13301,13303,14483,14581,14582,14584,14588,15945,15988,15989,16011,16016,16730,16736,
									16756,16768,16777,16885,16889,16894,16898,16900,16901,16910,16927,16929,16931,16933,16935,
                                    17166,17171,17176,17194,17199,17202,17531,17539,17540,17542,
                                    20435,24283,20438,12516,20432,22577,24285,18675,19550,20433,22590,12531,19542,19543,
                                    19544,19547,22598,24556,17185,18674,18676,18679,19551,20206,20434,22578,22580,22584,
20418,20419,20420,20421,20422,20423,20424,20425,20426,20427,20428,20429,20430,20431,21301,21302,22605,25120,26299,29234,30285),
	'color_chart_ids' => array(4040,36674,36673,40983,40986),

	// ------------- START - use for parent style sort ----------------
	'style_order_group' => array(
		2 => 1,
		4 => 1,
		3 => 1,
		84 => 2,
	),
	'style_order_group_content' => array(
		1 => array(
			'color',
			'bodice color',
			'sash color',
			'skirt color',
			'embroidery color',
			'wrap',
			'size',
		),
		2 => array(
			'color',
			'size',
			'heel type',
		),
	),
	// ------------- END - use for parent style sort ----------------

	'custom_size_dress' => array(
        array(
            'name' => 'bust',
            'inchRange' => range(21, 63, 0.5),
            'cmRange' => range(53, 160, 1),
        ),
        array(
            'name' => 'waist',
            'inchRange' => range(20, 63, 0.5),
            'cmRange' => range(51, 160, 1),
        ),
        array(
            'name' => 'hips',
            'inchRange' => range(20, 63, 0.5),
            'cmRange' => range(51, 160, 1),
        ),
        array(
            'name' => 'hollow_to_floor',
            'inchRange' => range(22, 75, 0.5),
            'cmRange' => range(55, 190, 1),
        ),
        array(
            'name' => 'height',
            'inchRange' => range(35, 76, 0.5),
            'cmRange' => range(88, 193, 1),
        ),
    ),

	'custom_size_wrap' => array(
        array(
            'name' => 'shoulder',
            'inchRange' => range(9, 28, 0.5),
            'cmRange' => range(23, 69, 1),
        ),
        array(
            'name' => 'shoulder_to_bust',
            'inchRange' => range(5, 18, 0.5),
            'cmRange' => range(15, 45, 1),
        ),
        array(
            'name' => 'armhole',
            'inchRange' => range(9, 28, 0.5),
            'cmRange' => range(23, 69, 1),
        ),
    ),

    // old: config.vars.php - $common_region
    'common_shipping_region' => array(
        3835 => array('region_id'=>'3835','region_name'=>'Australia'),
        3844 => array('region_id'=>'3844','region_name'=>'Canada'),
        4003 => array('region_id'=>'4003','region_name'=>'France'),
        4017 => array('region_id'=>'4017','region_name'=>'Germany'),
        3858 => array('region_id'=>'3858','region_name'=>'United Kingdom'),
        3859 => array('region_id'=>'3859','region_name'=>'United States'),
    ),

    'default_shipping_country_id' => 3859,

    'uri_cat_name_prefix_en' => 'Cheap-',

    // --- FOR JJSHOUSE START
    'product_ext.base' => 'jjshouse',

    'colorList' => array(
        'Blushing Pink',
        'Candy Pink',
        'Pearl Pink',
        'Watermelon',
        'Red',
        'Burgundy',
        'Orange',
        'Daffodil',
        'White',
        'Ivory',
        'Champagne',
        'Gold',
        'Brown',
        'Chocolate',
        'Black',
        'Silver',
        'Dark Green',
        'Jade',
        'Clover',
        'Lime Green',
        'Sage',
        'Sky Blue',
        'Pool',
        'Ocean Blue',
        'Royal Blue',
        'Ink Blue',
        'Dark Navy',
        'Regency',
        'Grape',
        'Fuchsia',
        'Lilac',
        'Lavender',
    ),
    'SEOColors' => array(
        'Blush Pink','Ice Pink','Tea Rose','Light Pink','Pink Blush','Suede Rose','Baby Pink','Blossom',
        'Carnation','Rosebud','Rosewood',
        'Peach','Nude','Apricot','Dusty Rose','Cameo','Ballet','Petal',
        'Coral Pink','Guava','Honeysuckle','Coral Reef','Coral','Pantone Honeysuckle','Punch','Petunia','Ginger','Firecracker',
        'Poppy','Apple','Pomegranate','Raspberry','Ruby','Deep Red','Scarlet','Rust',
        'Wine Red','Cherry','Cranberry','Garnet','Bordeaux','Berry','Claret','Barcelona','Wine','Mahogany',
        'Burnt Orange','Tangerine','Tangerine Tango','Clementine','Papaya','Tangelo','Persimmon','Spice','Terra Cotta','Salmon',
        'Yellow','Canary Yellow','Pale Yellow','Sunflower','Buttercup','Canary','Citron','Citrus','Sunbeam','Maize','Banana','Lemon',
        'Bright White',
        'Frost','Oyster','Soft White',
        'Sand','Beige','Palomino','Buff','NBChampagne','Biscotti',
        'Goldenrod','Marigold','Venetian Gold','Blonde','Mustard',
        'Acorn Brown','Cognac','Latte','Cappuccino','Mocha','Copper','Toffee',
        'Dark Brown','Cocoa','Espresso','Dark Brown','Truffle',
        'Ebony',
        'Charcoal','Stone Grey','Taupe Grey','Slate','Pewter','Platinum','Sterling','Charcoal Gray','Mercury','Stone','Mist Grey','Victorian','Stormy','Taupe','Dove',
        'Hunter','Pine Green','Forest Green','Gem','Hampton Green','Pine','Emerald','Emerald Green',
        'Oasis','Aqua','Tiffany','Pantone Turquoise','Teal Green','Teal','Mermaid','Malibu','Fusion',
        'Tarragon','Olive Green','Moss','Forest','Olive','Shamrock','Pantone Emerald','Pantone','Juniper','Appletini','Kelly',
        'Apple Green','Lime',
        'Sage Green','Apple Slice','Kiwi','Spearmint','Celadon','Mint Green','Pistachio','Mint','Mini Mist','Peridot','Limeade','Meadow',
        'Breezy','Cloudy','Icelandic','Seamist','Seaside','Aquamarine','Light Blue','Spa','Coastal','Pale Blue','Desert Blue','Waterfall',
        'Turquoise','Topaz','Capri',
        'Cornflower','Cerulean','Blue Jay','Ocean','Pacific',
        'Cobalt Blue','Electric Blue','Royal','Sapphire','Sailor','Cobalt','Lapis Blue','Lapis','Horizon','Mediterranean Blue',
        'Peacock','Tealness','Slate Blue','Steel Blue','Caspian','Windsor Blue',
        'Navy Blue','Marine','Indigo','Midnight','Navy',
        'Royal Purple','Purple Storm','Viola','African Violet','Amethyst','Blue Violet','Concord','Majestic','Regalia','Mauve',
        'Plum','Aubergine','Italian Plum','Eggplant','Dahlia','Afican Violet','Persian Plum','Sangria','Smashing','Wild Berry','Merlot','Persian','Orchid','Radiant Orchid','Victorian Lilac','Mulberry','Wisteria','Twilight','Magenta Pink','Hot Pink','Cerise','American Beauty','Begonia','Peony','Posie','Rose','Shocking','Tutti Frutti',
        'Iris','Soft Plum',
        'Periwinkle','Peri','Tahiti','Bluebird','Larkspur',
    ),
    'thumbConfig' => array(
        "85x85" => "s85",
        "179x278" => "s179",
        "42x42" => "s42",
        "74x102" => "s74",
        "270x370" => "m",
        "390x540" => "o390",
        "1140x1578" => "h",
        "0x0" => "o",
        "160x160" => "s160",
        "128x128" => "s128",
        // old
        "237x320" => "l",
        "85x85" => "s85",
        "400x400" => "o400",
        "600x600" => "o600",
    ),
    // --- FOR JJSHOUSE END
));
