CREATE SEQUENCE public.price_goods_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- Цена товара
CREATE TABLE price_goods (
	id int4 NOT NULL DEFAULT nextval('price_goods_seq'::regclass),
	price money,
	goods_id int4,
	date_start timestamp default CURRENT_TIMESTAMP,
	date_end timestamp,
	is_active smallint,
	CONSTRAINT price_goods_pkey PRIMARY KEY (id),
	FOREIGN KEY(goods_id) REFERENCES "goods" (id)
);