select g."name" , g."comment" , tg."comment" , u."name" from 
goods g,
types_goods tg,
units u 
where
g.type_goods_id = tg.id 
and g.units_id  = u.id 