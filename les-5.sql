-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

UPDATE users SET created_at = now() WHERE created_at IS NULL;
UPDATE users SET updated_at = now() WHERE updated_at IS NULL;

-- 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время 
-- помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.

UPDATE users SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %h:%m');
UPDATE users SET updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %h:%m');

ALTER TABLE users MODIFY COLUMN created_at datetime;
ALTER TABLE users MODIFY COLUMN updated_at datetime;

-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, 
-- если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, 
-- чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех 

SELECT * FROM storehouses_products ORDER BY
CASE
 WHEN value = 0 THEN 'a'
 ELSE value
 END,
value;

-- 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august)

SELECT name FROM users WHERE m = may OR m = august; -- где "m" - это столбец с месяцем рождения, а "name" столбец с именем

-- 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.

SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY
CASE
 WHEN id = 5 THEN 1
 WHEN id = 1 THEN 2
 WHEN id = 2 THEN 3
 ELSE id
 END,
id;

-- Практическое задание теме «Агрегация данных»

-- 1. Подсчитайте средний возраст пользователей в таблице users.

SELECT avg(floor((TO_days(now()) - to_days(birthday_at)) / 365.25)) AS age FROM users;

-- или более точное значение:

SELECT avg(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS age FROM users;

-- 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.

SELECT DAYNAME(DATE_FORMAT(birthday_day, '%2021-%m.%d.')) AS week_day, count(created_at) AS total FROM users GROUP BY DAYNAME(DATE_FORMAT(birthday_day, '%2021-%m.%d.'));

-- 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы.

select exp(sum(ln(value))) from table1;
