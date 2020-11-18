CREATE SEQUENCE public.types_shops_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- Типы магазинов
CREATE TABLE types_shops (
	id int4 NOT NULL DEFAULT nextval('types_shops_seq'::regclass),
	name VARCHAR(256), 
	comment VARCHAR(2000),
	date_create timestamp default CURRENT_TIMESTAMP,
	is_active smallint,
	CONSTRAINT types_shops_pkey PRIMARY KEY (id)
);