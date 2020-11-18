-- генерация движения товара за сегодня для супермаркетов - овощи
DO $$DECLARE r record;
d_start timestamp;
d_end   timestamp;
is_active int4;
n_shop_id int4;
n_shop_max_id int4;
n_quantity_diff numeric(7,3);
n_quantity_max numeric(7,3);
n_quantity numeric(7,3);
factor int4;
d_start_day timestamp;
begin
    n_shop_id      := 9;  -- ID первого супермаркета
    n_shop_max_id  := 13; -- ID последнего супермаркета
    d_start        := date_trunc('day', current_date) + INTERVAL '9  hours';
    n_quantity_max := 40;
    d_start_day    := date_trunc('month', current_date - INTERVAL '3  month'); -- минус 3 месяца
	factor 		   := 2;
    -- отбор по магазинам
    <<shops>>
    loop
        EXIT WHEN n_shop_id > n_shop_max_id;
        -- отбор по дням
        <<days>> while d_start_day <= date_trunc('day', current_date)
        loop
            -- генерация количества товаров
            <<goods>> FOR r IN
            select
                   a1.good_id
                 , a1.good_name
                 , a1.unit_id
                 , a1.price_id
                 , rw
                 , (a1.max_id - a1.min_id + 1) cnt_rw
            from
                   (
                                select
                                             g.id                            good_id
                                           , g."name"                        good_name
                                           , g.units_id                      unit_id
                                           , pg.id                           price_id
                                           , count(*) over ( order by g.id ) rw
                                           , max(g.id) over (
                                                partition by g.units_id) max_id
                                           , min(g.id) over (
                                                partition by g.units_id) min_id
                                from
                                             goods       g
                                           , price_goods pg
                                where
                                             g.is_active = 1
                                             and g.id    = pg.goods_id
                                             and
                                             (
                                                          current_date between pg.date_start and pg.date_end
                                             )
                                             and g.type_goods_id = 2
                   )
                   a1 loop n_quantity_diff := r.cnt_rw - 2
            ;
            
            -- случайная генерация
            n_quantity := (random() * n_quantity_max * factor);
            case
            when r.good_name = 'Кабачки' then
                n_quantity := (n_quantity * 0.5);
            when r.good_name = 'Баклажаны грунтовые' then
                n_quantity := (n_quantity * 0.5);
            when r.good_name = 'Чеснок' then
                n_quantity := (n_quantity * 0.3);
            when r.good_name = 'Редис' then
                n_quantity := (n_quantity * 0.5);
            when r.good_name = 'Редька Дайкон' then
                n_quantity := (n_quantity * 0.5);
            when r.good_name = 'Репа' then
                n_quantity := (n_quantity * 0.5);
            when r.good_name = 'Имбирь' then
                n_quantity := (n_quantity * 0.1);
            when r.good_name = 'Перец Ласточка' then
                n_quantity := (n_quantity * 0.4);
            when r.good_name = 'Перец красный' then
                n_quantity := (n_quantity * 0.4);
            when r.good_name = 'Томат сливовидный' then
                n_quantity := (n_quantity * 0.6);
            when r.good_name = 'Томат' then
                n_quantity := (n_quantity * 0.6);
            when r.good_name = 'Томат розовый' then
                n_quantity := (n_quantity * 0.6);
            else
                n_quantity := n_quantity;
            end case;
            INSERT INTO shops_wr_goods
                   (date_create
                        , shop_id
                        , good_id
                        , price_id
                        , quantity
                        , unit_id
                        , is_active
                   )
                   VALUES
                   (d_start_day
                        , n_shop_id
                        , r.good_id
                        , r.price_id
                        , n_quantity
                        , r.unit_id
                        , 1
                   )
            ;
        
        END loop goods;
        -- добавляем +1 день для цикла
        d_start_day := d_start_day + INTERVAL '1  day';
    END loop days;
    -- сбрасываем в начальный день
    d_start_day := date_trunc('month', current_date - interval '3  month');
    -- переход на следующий магазин
    n_shop_id := n_shop_id + 1;
END loop shops;
END$$;