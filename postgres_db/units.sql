CREATE SEQUENCE public.units_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- Еденицы измерений
CREATE TABLE units (
	id int4 NOT NULL DEFAULT nextval('units_seq'::regclass), 
	name VARCHAR(256), 
	comment VARCHAR(2000), 
	date_create timestamp default CURRENT_TIMESTAMP,
	CONSTRAINT units_pkey PRIMARY KEY (id)
);