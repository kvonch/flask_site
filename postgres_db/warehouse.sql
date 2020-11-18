CREATE SEQUENCE public.warehouse_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- Склады
CREATE TABLE warehouse (
	id int4 NOT NULL DEFAULT nextval('warehouse_seq'::regclass),
	wr_name VARCHAR(256),
	comment VARCHAR(2000),
	good_id int4,
	price_id int4,
	unit_id int4,
	date_create timestamp default CURRENT_TIMESTAMP,
	date_end timestamp,
	is_active smallint,
	CONSTRAINT warehouse_pkey PRIMARY KEY (id),
	FOREIGN KEY(good_id) REFERENCES "goods" (id),
	FOREIGN KEY(price_id) REFERENCES "price_goods" (id),
	FOREIGN KEY(unit_id) REFERENCES "units" (id)
);