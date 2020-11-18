CREATE SEQUENCE public.shops_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- Магазины
CREATE TABLE shops (
	id int4 NOT NULL DEFAULT nextval('shops_seq'::regclass),
	shop_name VARCHAR(256),
	comment VARCHAR(2000),
	date_create timestamp default CURRENT_TIMESTAMP,
	date_end timestamp,
	is_active smallint,
	type_shops_id int4,
	CONSTRAINT shops_pkey PRIMARY KEY (id),
	FOREIGN KEY(type_shops_id) REFERENCES "types_shops" (id)
);