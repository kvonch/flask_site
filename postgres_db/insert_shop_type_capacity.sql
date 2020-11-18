insert into shop_type_capacity (types_shops_id, types_goods_id, weight_capacity, piece_capacity, units_id, is_active, date_create)
select s.type_shops_id, g.type_goods_id,
ceil(sum(case -- округление до ближайшего целого числа в большую сторону
  when swg.unit_id = 1 then
    swg.quantity
  else
    0
end)*1.2/count(swg.id))  weight_capacity, -- среднее значение по весу(count)
ceil(sum(case
  when swg.unit_id = 2 then
    swg.quantity
  when swg.unit_id = 3 then
    swg.quantity
  when swg.unit_id = 4 then
      swg.quantity
  else
    0
end)*1.2/count(swg.id))  piece_capacity, -- штучная вместимость
(case
  when swg.unit_id = 1 then
    swg.unit_id
  when swg.unit_id = 2 then
    swg.unit_id
  when swg.unit_id = 3 then
    swg.unit_id
  when swg.unit_id = 4 then
      swg.unit_id
  else
    0
end)  units_id,
min(1) is_active, -- групповая функция
min(swg.date_create) -- начальная дата работы складов магазинов
from shops_wr_goods swg, shops s, types_shops ts, goods g
where
swg.shop_id = s.id 
and s.type_shops_id = ts.id 
and swg.good_id  = g.id
group by -- групируем
s.type_shops_id, g.type_goods_id, swg.unit_id