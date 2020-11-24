CREATE VIEW max_over_shops_capacity AS
select
(select h1."name" from types_shops h1 where h1.id =  e1.types_shops_id) types_shops_name, -- наименование типов магазинов 
(select h1."name" from types_goods h1 where h1.id =  e1.types_goods_id) types_goods_name, -- наименование типов продуктов
floor(max(e1.max_over_weight_capacity)) max_over_weight_capacity, -- излишки на складах магазинов в кг
floor(max(e1.max_over_piece_capacity)) max_over_piece_capacity -- излишки на складах магазинов в единицах
from 
(
select
d1.mnt_balance,
d1.types_shops_id,
d1.types_goods_id,
d1.max_over_weight_capacity,
0 max_over_piece_capacity
from
(
select
b1.mnt_balance,
b1.types_shops_id,
b1.types_goods_id,
sum(b1.over_weight_capacity) over_weight_capacity,
sum(b1.over_piece_capacity) over_piece_capacity,
max(sum(b1.over_weight_capacity)) over (partition by b1.types_shops_id, b1.types_goods_id) max_over_weight_capacity,
max(sum(b1.over_piece_capacity)) over (partition by b1.types_shops_id, b1.types_goods_id) max_over_piece_capacity
from (
select
to_char(swg.date_create, 'MM.YYYY') mnt_balance,
stp.types_shops_id,
stp.types_goods_id,
case
 when stp.units_id = 1 then
  swg.quantity - stp.weight_capacity
 else
  0
end over_weight_capacity,
case
 when stp.units_id <> 1 then
  swg.quantity - stp.piece_capacity 
 else
  0
end over_piece_capacity
FROM 
shops_wr_goods swg,
shops s,
goods g,
shop_type_capacity stp
where
swg.shop_id = s.id
and swg.good_id = g.id
and swg.unit_id = g.units_id
and s.type_shops_id = stp.types_shops_id
and g.type_goods_id = stp.types_goods_id
and swg.unit_id = stp.units_id
and 
(
case
 when stp.units_id = 1 then
  swg.quantity - stp.weight_capacity
 else
  0
end > 0
or 
case
 when stp.units_id <> 1 then
  swg.quantity - stp.piece_capacity 
 else
  0
end > 0
)
and (date_trunc('month', swg.date_create) between date_trunc('month', current_date - INTERVAL '3  month') and (date_trunc('month', current_date) - INTERVAL '1  day'))
) b1
group by
b1.mnt_balance,
b1.types_shops_id,
b1.types_goods_id
) d1
where
d1.over_weight_capacity = d1.max_over_weight_capacity
union all
select
d1.mnt_balance,
d1.types_shops_id,
d1.types_goods_id,
0 max_over_weight_capacity,
d1.max_over_piece_capacity
from
(
select
b1.mnt_balance,
b1.types_shops_id,
b1.types_goods_id,
sum(b1.over_weight_capacity) over_weight_capacity,
sum(b1.over_piece_capacity) over_piece_capacity,
max(sum(b1.over_weight_capacity)) over (partition by b1.types_shops_id, b1.types_goods_id) max_over_weight_capacity,
max(sum(b1.over_piece_capacity)) over (partition by b1.types_shops_id, b1.types_goods_id) max_over_piece_capacity
from (
select
to_char(swg.date_create, 'MM.YYYY') mnt_balance,
stp.types_shops_id,
stp.types_goods_id,
case
 when stp.units_id = 1 then
  swg.quantity - stp.weight_capacity
 else
  0
end over_weight_capacity,
case
 when stp.units_id <> 1 then
  swg.quantity - stp.piece_capacity 
 else
  0
end over_piece_capacity
FROM 
shops_wr_goods swg,
shops s,
goods g,
shop_type_capacity stp
where
swg.shop_id = s.id
and swg.good_id = g.id
and swg.unit_id = g.units_id
and s.type_shops_id = stp.types_shops_id
and g.type_goods_id = stp.types_goods_id
and swg.unit_id = stp.units_id
and 
(
case
 when stp.units_id = 1 then
  swg.quantity - stp.weight_capacity
 else
  0
end > 0
or 
case
 when stp.units_id <> 1 then
  swg.quantity - stp.piece_capacity 
 else
  0
end > 0
)
and (date_trunc('month', swg.date_create) between date_trunc('month', current_date - INTERVAL '3  month') and (date_trunc('month', current_date) - INTERVAL '1  day'))
) b1
group by
b1.mnt_balance,
b1.types_shops_id,
b1.types_goods_id
) d1
where
d1.over_piece_capacity = d1.max_over_piece_capacity
) e1
group by
e1.types_shops_id,
e1.types_goods_id
order by
e1.types_shops_id,
e1.types_goods_id