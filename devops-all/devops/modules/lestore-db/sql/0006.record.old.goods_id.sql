-- goods add old_goods_id field
ALTER TABLE goods ADD COLUMN old_goods_id INT NOT NULL DEFAULT 0 COMMENT '原记录ID';
-- goods_gallery add old_img_id field
ALTER TABLE goods_gallery ADD COLUMN old_img_id INT NOT NULL DEFAULT 0 COMMENT '原记录ID';
