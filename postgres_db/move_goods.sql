CREATE SEQUENCE public.move_goods_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
--Движения товаров со склада в магазин и наоборот
CREATE TABLE move_goods (
	id int4 NOT NULL DEFAULT nextval('move_goods_seq'::regclass),
	goods_id int4, 
	warehouse_id int4, 
	shops_id int4,
	goods_move_type_id int4,
	quantity numeric(7,3),
	unit_id int4,
	date_create timestamp default CURRENT_TIMESTAMP,
	CONSTRAINT move_goods_pkey PRIMARY KEY (id),
	FOREIGN KEY(goods_id) REFERENCES "goods" (id),
	FOREIGN KEY(warehouse_id) REFERENCES "warehouse" (id),
	FOREIGN KEY(shops_id) REFERENCES "shops" (id),
	FOREIGN KEY(goods_move_type_id) REFERENCES "goods_move_type" (id)
);