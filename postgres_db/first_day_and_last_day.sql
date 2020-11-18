select date_trunc('month', current_date); -- Первый день текущего месяца
SELECT (DATE_TRUNC('month', CURRENT_DATE + INTERVAL '1  month') - INTERVAL '1  day'); -- Текущий день текущего месяца