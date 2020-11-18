CREATE SEQUENCE public.shops_wr_goods_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- Остатки товаров в местах хранения в магазинах
CREATE TABLE shops_wr_goods (
	id int4 NOT NULL DEFAULT nextval('shops_wr_goods_seq'::regclass),
	date_create timestamp default CURRENT_TIMESTAMP,
	shop_id int4,
	good_id int4,
	price_id int4,
	quantity numeric(7,3),
	unit_id int4,
	is_active smallint,
	CONSTRAINT shops_wr_goods_pkey PRIMARY KEY (id),
	FOREIGN KEY(shop_id) REFERENCES "shops" (id),
	FOREIGN KEY(good_id) REFERENCES "goods" (id),
	FOREIGN KEY(price_id) REFERENCES "price_goods" (id),
	FOREIGN KEY(unit_id) REFERENCES "units" (id)
);