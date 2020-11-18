-- заполняем движение товаров со склада в магазины(товар в магазины уезжает в 9 часов утра)
insert into move_goods
(goods_id,
warehouse_id,
shops_id,
goods_move_type_id,
quantity,
unit_id,
date_create)
SELECT 
swg.good_id ,
1 warehouse_id,
swg.shop_id,
2 goods_move_type_id,
-- вычисляем кол-во товара которое нужно магазину
case
  when 
  (
   (case
   when unit_id = 1 then
     sc.weight_capacity -- вместимость класса по весу
   else
     sc.piece_capacity -- штучная вместимость
   end) - floor(swg.quantity) -- округление до ближайшего целого числа равного quantity в меньшую сторону
  ) <= 0 then -- если у нас товара хватает и даже перебор - то ничего не везем 
    0
  else -- считвем сколько привезти товара
     (case
      when unit_id = 1 then
       sc.weight_capacity
      else
       sc.piece_capacity
     end) - floor(swg.quantity)
end quantity, -- расчетное кол-во товара что везем в магазин
/*(case
  when unit_id = 1 then
    sc.weight_capacity
  else
    sc.piece_capacity
end)
- floor(swg.quantity) 
diff_enb_qnt,*/ -- разница того что есть и сколько помещается в магазине 
unit_id,
swg.date_create + INTERVAL '9  hours' dt_create
FROM 
shops_wr_goods swg,
shops s,
shop_type_capacity sc,
goods g
where
swg.shop_id = s.id
and s.type_shops_id  = sc.types_shops_id 
and swg.good_id  = g.id 
and g.type_goods_id  = sc.types_goods_id 
and swg.unit_id = sc.units_id 
and sc.is_active = 1

