CREATE SEQUENCE public.post_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- Информация о пользователе
CREATE TABLE post (
	id int4 NOT NULL DEFAULT nextval('post_seq'::regclass), 
	body VARCHAR(140), 
	last_seen timestamp default CURRENT_TIMESTAMP,
	user_id INTEGER, 
	CONSTRAINT post_pkey PRIMARY KEY (id),
	FOREIGN KEY(user_id) REFERENCES "user" (id)
);