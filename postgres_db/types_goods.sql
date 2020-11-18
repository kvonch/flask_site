CREATE SEQUENCE public.types_goods_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- Типы товаров
CREATE TABLE types_goods (
	id int4 NOT NULL DEFAULT nextval('types_goods_seq'::regclass), 
	name VARCHAR(256), 
	comment VARCHAR(2000), 
	date_create timestamp default CURRENT_TIMESTAMP,
	CONSTRAINT types_goods_pkey PRIMARY KEY (id)
);