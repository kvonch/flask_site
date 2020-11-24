CREATE VIEW sum_mnt_sale AS 
select
types_shops types_shops_name, -- наименование типв магазина
to_char(sale_date, 'MM.YYYY') sale_date, -- месяц продаж
floor(sum_mnt_weight_sale) sum_mnt_weight_sale, -- проданный весовой товар
floor(sum_mnt_piece_sale) sum_mnt_piece_sale -- проданный штучный товар
from
(
SELECT 
(
select "name" from types_shops where id = stc.types_shops_id
) types_shops,
date_trunc('month', swg.date_create) sale_date,
sum(stc.weight_capacity - 
case 
  when swg.unit_id  = 1 then -- для весового товара
    swg.quantity 
  else
    0
end) sum_mnt_weight_sale,
sum(stc.piece_capacity - 
case 
  when swg.unit_id  > 1 then -- для штучного товара
    swg.quantity 
  else
    0
end) sum_mnt_piece_sale,
sum(sum(stc.weight_capacity - 
case 
  when swg.unit_id  = 1 then -- для весового товара
    swg.quantity 
  else
    0
end) +
sum(stc.piece_capacity - 
case 
  when swg.unit_id  > 1 then -- для штучного товара
    swg.quantity 
  else
    0
end)) over (partition by stc.types_shops_id, date_trunc('month', swg.date_create)) sum_mnt_all_sale,
max(sum(stc.weight_capacity - 
case 
  when swg.unit_id  = 1 then -- для весового товара
    swg.quantity 
  else
    0
end) +
sum(stc.piece_capacity - 
case 
  when swg.unit_id  > 1 then -- для штучного товара
    swg.quantity 
  else
    0
end)) over (partition by stc.types_shops_id)  max_sum_mnt_all_sale
FROM shops_wr_goods swg, goods g, shops s, shop_type_capacity stc
where
swg.good_id = g.id 
and g.type_goods_id  = stc.types_goods_id 
and swg.shop_id = s.id 
and s.type_shops_id  = stc.types_shops_id 
and swg.unit_id = stc.units_id
and (date_trunc('month', swg.date_create) between date_trunc('month', current_date - INTERVAL '3  month') and (date_trunc('month', current_date) - INTERVAL '1  day'))
group by 
stc.types_shops_id,
date_trunc('month', swg.date_create)
) a1
where a1.max_sum_mnt_all_sale = a1.sum_mnt_all_sale
order by a1.sum_mnt_weight_sale;