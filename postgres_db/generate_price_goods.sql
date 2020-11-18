-- генерация за -1 месяц
DO $$DECLARE r record;
d_start timestamp;
d_end timestamp;
is_active int4;
begin
	is_active := 0;
    d_start := date_trunc('month', current_date - INTERVAL '1  month');
    d_end := (DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1  day');
    FOR r IN SELECT pg.goods_id , pg.price FROM price_goods pg
             WHERE pg.is_active  = 1
    LOOP
        INSERT INTO price_goods (price, goods_id, date_start, date_end, is_active) VALUES(r.price-(r.price * random()/8),r.goods_id,d_start,d_end,is_active);
   null;
  END LOOP;
END$$;

-- генерация за -2 месяц
DO $$DECLARE r record;
d_start timestamp;
d_end timestamp;
is_active int4;
begin
	is_active := 2;
    d_start := date_trunc('month', current_date - INTERVAL '2  month');
    d_end := (DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1  month' - INTERVAL '1  day');
    FOR r IN SELECT pg.goods_id , pg.price FROM price_goods pg
             WHERE pg.is_active  = 0
    LOOP
        INSERT INTO price_goods (price, goods_id, date_start, date_end, is_active) VALUES(r.price-(r.price * random()/15),r.goods_id,d_start,d_end,is_active);
   null;
  END LOOP;
END$$;

-- генерация за -3 месяц
DO $$DECLARE r record;
d_start timestamp;
d_end timestamp;
is_active int4;
begin
	is_active := 3;
    d_start := date_trunc('month', current_date - INTERVAL '3  month');
    d_end := (DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '2  month' - INTERVAL '1  day');
    FOR r IN SELECT pg.goods_id , pg.price FROM price_goods pg
             WHERE pg.is_active  = 2
    LOOP
        INSERT INTO price_goods (price, goods_id, date_start, date_end, is_active) VALUES(r.price-(r.price * random()/20),r.goods_id,d_start,d_end,is_active);
   null;
  END LOOP;
END$$;

-- генерация за +1 месяц
DO $$DECLARE r record;
d_start timestamp;
d_end timestamp;
is_active int4;
begin
	is_active := 4;
    d_start := date_trunc('month', current_date + INTERVAL '1  month');
    d_end := (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '2  month' - INTERVAL '1  day');
    FOR r IN SELECT pg.goods_id , pg.price FROM price_goods pg
             WHERE pg.is_active  = 1
    LOOP
        INSERT INTO price_goods (price, goods_id, date_start, date_end, is_active) VALUES(r.price+(r.price * random()/20),r.goods_id,d_start,d_end,is_active);
   null;
  END LOOP;
END$$;

-- Все цены не текущего месяца делаем не активными
UPDATE public.price_goods SET is_active=0 WHERE is_active <> 1;