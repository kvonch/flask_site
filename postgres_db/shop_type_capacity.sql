CREATE SEQUENCE public.shop_type_capacity_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- Еденицы измерений
CREATE TABLE shop_type_capacity (
	id int4 NOT NULL DEFAULT nextval('shop_type_capacity_seq'::regclass), 
	types_shops_id int4,
	types_goods_id int4,
	weight_capacity numeric(7,3),
	piece_capacity numeric(7,3),
	units_id int4, 
	is_active smallint,
	date_create timestamp default CURRENT_TIMESTAMP,
	CONSTRAINT shop_type_capacity_pkey PRIMARY KEY (id),
	FOREIGN KEY(types_shops_id) REFERENCES "types_shops" (id),
	FOREIGN KEY(types_goods_id) REFERENCES "types_goods" (id),
	FOREIGN KEY(units_id) REFERENCES "units" (id)
);