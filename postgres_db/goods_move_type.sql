CREATE SEQUENCE public.goods_move_type_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- Тип движения товаров: приход, расход, естественная убыль
CREATE TABLE goods_move_type (
	id int4 NOT NULL DEFAULT nextval('goods_move_type_seq'::regclass),
	types_move VARCHAR(256), 
	comment VARCHAR(2000),
	date_create timestamp default CURRENT_TIMESTAMP,
	CONSTRAINT goods_move_type_pkey PRIMARY KEY (id)
);