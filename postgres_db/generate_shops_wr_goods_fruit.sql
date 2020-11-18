-- генерация движения товара за сегодня для обычных магазинов - фрукты
DO $$DECLARE r record;  -- Объявляем переменные
d_start timestamp;
d_end   timestamp;
is_active int4;
n_shop_id int4;
n_shop_max_id int4;
n_quantity_diff numeric(7,3);
n_quantity_max numeric(7,3);
n_quantity numeric(7,3);
d_start_day timestamp;
begin -- Начало блока 
    n_shop_id      := 1; -- ID первого магазина
    n_shop_max_id  := 8; -- ID последнего магазина
    d_start        := date_trunc('day', current_date) + INTERVAL '9  hours';
    n_quantity_max := 40; -- Максимальный объем
    d_start_day    := date_trunc('month', current_date - INTERVAL '3  month'); -- минус 3 месяца
    -- отбор по магазинам
    <<shops>> -- метка
    loop -- цикл по магазинам
        EXIT WHEN n_shop_id > n_shop_max_id; -- условие цикла
        -- отбор по дням
        <<days>> while d_start_day <= date_trunc('day', current_date)
        loop -- цикл по дням
            -- генерация количества товаров
            <<goods>> FOR r IN -- цикл по товарам(перебирает каждую строчку)
            select
                   a1.good_id
                 , a1.good_name
                 , a1.unit_id
                 , a1.price_id
                 , rw -- порядковый номер строки
                 , (a1.max_id - a1.min_id + 1) cnt_rw -- общее количество выбранных строк
            from
                   (
                                select
                                             g.id                            good_id
                                           , g."name"                        good_name
                                           , g.units_id                      unit_id
                                           , pg.id                           price_id
                                           , count(*) over ( order by g.id ) rw -- Возвращает количество строк по сортировке по айди
                                           , max(g.id) over ( -- оконная функция
                                                partition by g.units_id) max_id -- группирует строки по максимальному значению(кг, шт. и т.д.)
                                           , min(g.id) over ( -- оконная функция
                                                partition by g.units_id) min_id -- группирует строки по минимальному значению(кг, шт. и т.д.)
                                from
                                             goods       g
                                           , price_goods pg
                                where
                                             g.is_active = 1
                                             and g.id    = pg.goods_id
                                             and
                                             (
                                                          current_date between pg.date_start and pg.date_end -- текущая дата удовлетворяла условию начальной дате и дате когда товар уже продали
                                             )
                                             and g.type_goods_id = 1 -- тип продукта фрукты
                   )
                   a1 loop n_quantity_diff := r.cnt_rw - 2
            ;
            
            -- случайная генерация
            n_quantity := (random() * n_quantity_max); -- рандомно генерирую вес прибывшего товара в магазин
            -- исключение по товарам
			case -- возвращает значение товара представленного ниже, умноженное на определенный коэфициент
            when r.good_name = 'Киви' then
                n_quantity := (n_quantity * 0.8);
            when r.good_name = 'Помело' then
                n_quantity := (n_quantity * 0.7);
            when r.good_name = 'Апельсин отборный' then
                n_quantity := (n_quantity * 0.7);
            when r.good_name = 'Апельсин для сока' then
                n_quantity := (n_quantity * 0.7);
            when r.good_name = 'Апельсин' then
                n_quantity := (n_quantity * 0.7);
            when r.good_name = 'Грейпфрут' then
                n_quantity := (n_quantity * 0.7);
            when r.good_name = 'Лайм' then
                n_quantity := (n_quantity * 0.7);
            when r.good_name = 'Мандарин' then
                n_quantity := (n_quantity * 0.7);
            when r.good_name = 'Лимон' then
                n_quantity := (n_quantity * 0.7);
            when r.good_name = 'Хурма' then
                n_quantity := (n_quantity * 1.2);
            when r.good_name = 'Хурма Свечка' then
                n_quantity := (n_quantity * 1.2);
            when r.good_name = 'Хурма Королек' then
                n_quantity := (n_quantity * 1.2);
			when r.good_name = 'Виноград Киш-миш розовый' then
                n_quantity := (n_quantity * 0.6);
			when r.good_name = 'Виноград красный' then
                n_quantity := (n_quantity * 0.6);
			when r.good_name = 'Виногорад Ред Глоб' then
                n_quantity := (n_quantity * 0.6);
			when r.good_name = 'Виногорад Тайфи' then
                n_quantity := (n_quantity * 0.6);
			when r.good_name = 'Виногорад зеленый' then
                n_quantity := (n_quantity * 0.6);
			when r.good_name = 'Виноград Киш-миш зеленый' then
                n_quantity := (n_quantity * 0.6);
			when r.good_name = 'Виногорад черный' then
                n_quantity := (n_quantity * 0.6);
			when r.good_name = 'Дыня Гулаба' then
                n_quantity := (n_quantity * 1.4);
			when r.good_name = 'Дыня Колхозница' then
                n_quantity := (n_quantity * 1.4);
			when r.good_name = 'Арбуз' then
                n_quantity := (n_quantity * 1.4);
			when r.good_name = 'Слива красная' then
                n_quantity := (n_quantity * 0.8);
			when r.good_name = 'Киви Голд' then
                n_quantity := ceil(n_quantity * 3);
			when r.good_name = 'Кокос' then
                n_quantity := ceil(n_quantity * 0.3);
			when r.good_name = 'Авокадо' then
                n_quantity := ceil(n_quantity * 0.7);
            else -- иначе вес остается не изменным
                n_quantity := n_quantity;
            end case; -- закрываем кейс
            INSERT INTO shops_wr_goods
                   (date_create
                        , shop_id
                        , good_id
                        , price_id
                        , quantity
                        , unit_id
                        , is_active
                   )
                   VALUES -- значение
                   (d_start_day
                        , n_shop_id
                        , r.good_id
                        , r.price_id
                        , n_quantity
                        , r.unit_id
                        , 1
                   )
            ;
        
        END loop goods; -- закрытие цикла по продуктам
        -- добавляем +1 день для цикла
        d_start_day := d_start_day + INTERVAL '1  day';
    END loop days; -- закрытие цикла по дням
    -- сбрасываем в начальный день
    d_start_day := date_trunc('month', current_date - interval '3  month'); -- минус 3 месяца (сбрасывается на начало, для следущего магазина)
    -- переход на следующий магазин
    n_shop_id := n_shop_id + 1;
END loop shops; -- закрытие цикла по магазинам
END$$; -- Конец блока