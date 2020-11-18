select random()/8
select date_trunc('month', current_date + INTERVAL '1  month'); -- Первый день текущего месяца
select date_trunc('day', current_date) + INTERVAL '9  hours';
SELECT (DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1  day'); 
SELECT (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '2  month' - INTERVAL '1  day'); 
select nextval('price_goods_seq'::regclass);

select date_trunc('month', current_date - INTERVAL '3  month');

select COUNT(g.id) from goods g where g.type_goods_id = 3;

select DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1  day';

delete from price_goods pg where pg.is_active = 2 ;
ALTER SEQUENCE price_goods_seq RESTART WITH 1; -- Сбросить sequence


create function pg_temp.temp_func(int, text, bool, numeric) returns void as $$
begin
    insert into foo values ($1, $2, $3, $4);
    return;
end
$$ language plpgsql;

pg_temp.tfunc(1, 'Hunter Valley', 't', 200.00);
pg_temp.tfunc(2, 'Something Else', 'f', 300.00);

INSERT INTO public.price_goods (price, goods_id, date_start, date_end, is_active) VALUES(0, 0, (date_trunc('month', current_date - INTERVAL '1  month')), (DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1  day'), 0);


DO $$DECLARE r record;
BEGIN
    FOR r IN SELECT pg.goods_id , pg.price FROM price_goods pg
             WHERE pg.is_active  = 1
    LOOP
        EXECUTE 'INSERT INTO public.price_goods (price, goods_id, date_start, date_end, is_active) VALUES( ' || r.price || ',' || r.goods_id || ' , (date_trunc(''month'', current_date - INTERVAL ''1  month'')), (DATE_TRUNC(''month'', CURRENT_DATE) - INTERVAL ''1  day''), 0)';
    END LOOP;
END$$;



select
a1.good_id, a1.units_id, a1.price, rw, (a1.max_id - a1.min_id + 1) cnt_rw 
from 
(
SELECT 
g.id good_id, g.units_id, pg.price, count(*) OVER (ORDER BY g.id ) rw, max(g.id) OVER (partition by g.units_id) max_id, min(g.id) OVER (partition by g.units_id) min_id   
FROM goods g, price_goods pg
WHERE g.is_active  = 1 and g.id  = pg.goods_id and (current_date between pg.date_start and pg.date_end) and g.type_goods_id = 2
) a1


SELECT sum(quantity) FROM public.shops_wr_goods;
SELECT sg.shop_id, sg.date_create, g."name" , sg.quantity FROM shops_wr_goods sg, goods g  where sg.good_id  = g.id order by sg.shop_id desc, sg.good_id, sg.date_create  ;


delete FROM public.shops_wr_goods;

SELECT count(id) FROM public.shops_wr_goods;