-- генерация движения товара за сегодня для гипермаркетов - овощи
DO $$DECLARE r record;
d_start TIMESTAMP;
d_end   TIMESTAMP;
is_active int4;
n_shop_id int4;
n_shop_max_id int4;
n_quantity_diff numeric(7,3);
n_quantity_max numeric(7,3);
n_quantity numeric(7,3);
factor int4;
d_start_day TIMESTAMP;
BEGIN
        n_shop_id      := 14; -- ID первого гипермаркета
        n_shop_max_id  := 18; -- ID последнего гипермаркета
        d_start        := date_trunc('day', CURRENT_DATE) + INTERVAL '9  hours';
        n_quantity_max := 40;
        d_start_day    := date_trunc('month', CURRENT_DATE - INTERVAL '3  month'); -- минус 3 месяца
		factor         := 4;
        -- отбор по магазинам
        <<shops>>
        LOOP
                EXIT WHEN n_shop_id > n_shop_max_id;
                -- отбор по дням
                <<days>> WHILE d_start_day <= date_trunc('day', CURRENT_DATE)
                LOOP
                        -- генерация количества товаров
                        <<goods>> FOR r IN
                        SELECT
                                a1.good_id  ,
                                a1.good_name,
                                a1.unit_id  ,
                                a1.price_id ,
                                rw          ,
                                (a1.max_id - a1.min_id + 1) cnt_rw
                        FROM
                                (
                                        SELECT
                                                g.id                            good_id  ,
                                                g."name"                        good_name,
                                                g.units_id                      unit_id  ,
                                                pg.id                           price_id ,
                                                COUNT(*) over ( ORDER BY g.id ) rw       ,
                                                MAX(g.id) over (
                                                        PARTITION BY
                                                                g.units_id) max_id,
                                                MIN(g.id) over (
                                                        PARTITION BY
                                                                g.units_id) min_id
                                        FROM
                                                goods       g,
                                                price_goods pg
                                        WHERE
                                                g.is_active = 1
                                        AND     g.id        = pg.goods_id
                                        AND     (
                                                        CURRENT_DATE BETWEEN pg.date_start AND     pg.date_end)
                                        AND     g.type_goods_id = 2 ) a1 LOOP n_quantity_diff := r.cnt_rw - 2;
                        
                        -- случайная генерация
                        n_quantity := (random() * n_quantity_max * factor);
                        CASE
                        WHEN r.good_name = 'Кабачки' THEN
                                n_quantity := (n_quantity * 0.5);
                        WHEN r.good_name = 'Баклажаны грунтовые' THEN
                                n_quantity := (n_quantity * 0.5);
                        WHEN r.good_name = 'Чеснок' THEN
                                n_quantity := (n_quantity * 0.3);
                        WHEN r.good_name = 'Редис' THEN
                                n_quantity := (n_quantity * 0.5);
                        WHEN r.good_name = 'Редька Дайкон' THEN
                                n_quantity := (n_quantity * 0.5);
                        WHEN r.good_name = 'Репа' THEN
                                n_quantity := (n_quantity * 0.5);
                        WHEN r.good_name = 'Имбирь' THEN
                                n_quantity := (n_quantity * 0.1);
                        WHEN r.good_name = 'Перец Ласточка' THEN
                                n_quantity := (n_quantity * 0.4);
                        WHEN r.good_name = 'Перец красный' THEN
                                n_quantity := (n_quantity * 0.4);
                        WHEN r.good_name = 'Томат сливовидный' THEN
                                n_quantity := (n_quantity * 0.6);
                        WHEN r.good_name = 'Томат' THEN
                                n_quantity := (n_quantity * 0.6);
                        WHEN r.good_name = 'Томат розовый' THEN
                                n_quantity := (n_quantity * 0.6);
                        ELSE
                                n_quantity := n_quantity;
                        END CASE;
                        INSERT INTO
                                shops_wr_goods
                                (
                                        date_create,
                                        shop_id    ,
                                        good_id    ,
                                        price_id   ,
                                        quantity   ,
                                        unit_id    ,
                                        is_active
                                )
                                VALUES
                                (
                                        d_start_day,
                                        n_shop_id  ,
                                        r.good_id  ,
                                        r.price_id ,
                                        n_quantity ,
                                        r.unit_id  ,
                                        1
                                );
                
                END LOOP goods;
                -- добавляем +1 день для цикла
                d_start_day := d_start_day + INTERVAL '1  day';
        END LOOP days;
        -- сбрасываем в начальный день
        d_start_day := date_trunc('month', CURRENT_DATE - interval '3  month');
        -- переход на следующий магазин
        n_shop_id := n_shop_id + 1;
END LOOP shops;
END$$;