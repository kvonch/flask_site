-- Найти строку с нулевой ценой
select g2."name" 
from price_goods pg, goods g2 
where pg.goods_id = g2.id 
and pg.price IS null;
-- Найти нулевое поле
select *
from goods g 
left join price_goods pg 
on g.id = pg.goods_id 
where pg.id is null;