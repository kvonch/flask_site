CREATE VIEW diff_mnt_sale AS 
select
b1.types_shops_name, -- наименование типов магазина
max(b1.sum_mnt_weight_sale) sum_mnt_weight_sale, -- максимальный проданный весовой товар
max(b1.sum_mnt_piece_sale) sum_mnt_piece_sale, -- максимальный проданный штучный товар
max(b1.sum_current_weight_sales) sum_current_weight_sales, -- продажи текущего месяца весовой товар
max(b1.sum_current_piece_sales) sum_current_piece_sales -- продажи текущего месяца штучный товар
from
(
select
types_shops types_shops_name, 
to_char(sale_date, 'MM.YYYY') max_sale_date, -- месяц продаж
floor(sum_mnt_weight_sale) sum_mnt_weight_sale, 
floor(sum_mnt_piece_sale) sum_mnt_piece_sale, 
0 sum_current_weight_sales, 
0 sum_current_piece_sales 
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
group by 
stc.types_shops_id,
date_trunc('month', swg.date_create)
) a1
where a1.max_sum_mnt_all_sale = a1.sum_mnt_all_sale
union all
SELECT 
(
select "name" from types_shops where id = stc.types_shops_id
) types_shops_name,
'01.1990' max_sale_date,
0 sum_mnt_weight_sale,
0 sum_mnt_piece_sale,
floor(sum(stc.weight_capacity - 
case 
  when swg.unit_id  = 1 then -- для весового товара
    swg.quantity 
  else
    0
end)) sum_current_weight_sales,
floor(sum(stc.piece_capacity - 
case 
  when swg.unit_id  > 1 then -- для штучного товара
    swg.quantity 
  else
    0
end)) sum_current_piece_sales
FROM shops_wr_goods swg, goods g, shops s, shop_type_capacity stc
where
swg.good_id = g.id 
and g.type_goods_id  = stc.types_goods_id 
and swg.shop_id = s.id 
and s.type_shops_id  = stc.types_shops_id 
and swg.unit_id = stc.units_id
and date_trunc('month', swg.date_create) = to_date('2020-10-01 00:00:00','YYYY-MM-DD')
group by 
stc.types_shops_id,
date_trunc('month', swg.date_create)
) b1
group by 
b1.types_shops_name
order by 2;

