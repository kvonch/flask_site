CREATE SEQUENCE public.goods_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- Товары
CREATE TABLE goods (
	id int4 NOT NULL DEFAULT nextval('goods_seq'::regclass), 
	name VARCHAR(256), 
	comment VARCHAR(2000),
	type_goods_id int4,
	units_id int4,
	date_create timestamp default CURRENT_TIMESTAMP,
	is_active smallint,
	CONSTRAINT goods_pkey PRIMARY KEY (id),
	FOREIGN KEY(type_goods_id) REFERENCES "types_goods" (id),
	FOREIGN KEY(units_id) REFERENCES "units" (id)
);