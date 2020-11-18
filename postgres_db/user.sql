CREATE SEQUENCE public.user_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- Пользователи
CREATE TABLE public."user" (
	id int4 NOT NULL DEFAULT nextval('user_seq'::regclass),
	username varchar(64) NULL,
	email varchar(120) NULL,
	password_hash varchar(128) NULL,
	about_me varchar(140) NULL,
	last_seen timestamp default CURRENT_TIMESTAMP,
	CONSTRAINT users_pkey PRIMARY KEY (id)
);

/* ALTER TABLE public.users 
    ALTER COLUMN id 
        SET DEFAULT NEXTVAL('users_id_seq'); */