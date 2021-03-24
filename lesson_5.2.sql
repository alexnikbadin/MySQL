
/* Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение» */
/* 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
Заполните их текущими датой и временем.*/

CREATE DATABASE notmy_shop1;

USE notmy_shop1;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
  ('Геннадий', '1990-10-05', NULL, NULL),
  ('Наталья', '1984-11-12', NULL, NULL),
  ('Александр', '1985-05-20', NULL, NULL),
  ('Сергей', '1988-02-14', NULL, NULL),
  ('Иван', '1998-01-12', NULL, NULL),
  ('Мария', '1992-08-29', NULL, NULL);
 
UPDATE users SET created_at = NOW() WHERE created_at IS NULL;
  
SELECT * FROM users;

/* 2. Таблица users была неудачно спроектирована. 
 Записи created_at и updated_at были заданы типом VARCHAR 
 и в них долгое время помещались значения в формате 20.10.2017 8:10. 
 Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения. */

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
  -- ('Геннадий', '1990-10-05', '20.10.2017 8:10', '20.10.2017 8:10');
 ('Геннадий', '1990-10-05', '20.10.2017 8:10', '20.10.2017 8:10');
  /*('Наталья', '1984-11-12', DEFAULT, DEFAULT),
  ('Александр', '1985-05-20', DEFAULT, DEFAULT),
  ('Сергей', '1988-02-14', DEFAULT, DEFAULT),
  ('Иван', '1998-01-12', DEFAULT, DEFAULT),
  ('Мария', '1992-08-29', DEFAULT, DEFAULT);*/

SELECT * FROM users;
DESCRIBE users;


ALTER TABLE users ADD COLUMN created_at_new DATETIME;
UPDATE users SET created_at_new = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i');
ALTER TABLE users DROP COLUMN created_at;
ALTER TABLE users RENAME COLUMN created_at_new TO created_at;


ALTER TABLE users ADD COLUMN updated_at_new DATETIME;
UPDATE users SET updated_at_new = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');
ALTER TABLE users DROP COLUMN updated_at;
ALTER TABLE users RENAME COLUMN updated_at_new TO updated_at;



/* 3. В таблице складских запасов storehouses_products в поле value могут встречаться 
 самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. 
 Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения 
 значения value. Однако нулевые запасы должны выводиться в конце, после всех записей. */

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO storehouses_products (value)
VALUES (0), (2500), (0), (30), (500), (1);
SELECT * FROM storehouses_products;
SELECT value FROM storehouses_products ORDER BY IF (value > 0, 0, 1), value; -- логику не совсем понял



/* 4. (по желанию) Из таблицы users необходимо извлечь пользователей, 
 родившихся в августе и мае. 
 Месяцы заданы в виде списка английских названий (may, august)*/

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
  ('Геннадий', '1990-10-05', DEFAULT, DEFAULT),
  ('Наталья', '1984-11-12', DEFAULT, DEFAULT),
  ('Александр', '1985-05-20', DEFAULT, DEFAULT),
  ('Сергей', '1988-02-14', DEFAULT, DEFAULT),
  ('Иван', '1998-01-12', DEFAULT, DEFAULT),
  ('Мария', '1992-08-29', DEFAULT, DEFAULT);
  


SELECT name, MONTHNAME (birthday_at) AS birthday_month FROM users WHERE MONTHNAME (birthday_at) = 'May'
OR MONTHNAME (birthday_at) = 'August';



/* 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. 
 
 SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
 Отсортируйте записи в порядке, заданном в списке IN.*/

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');
 
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(id, 5, 1, 2);





/* Практическое задание по теме «Агрегация данных»
 * 1. Подсчитайте средний возраст пользователей в таблице users.
 */

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
  ('Геннадий', '1990-10-05', now(), now()),
  ('Наталья', '1984-11-12', now(), now()),
  ('Александр', '1985-05-20', now(), now()),
  ('Сергей', '1988-02-14', now(), now()),
  ('Иван', '1998-01-12', now(), now()),
  ('Мария', '1992-08-29', now(), now());
 
SELECT name, ROUND((UNIX_TIMESTAMP(now()) - UNIX_TIMESTAMP (birthday_at))/86400 / 365.25, 1) AS average_age
FROM users;

SELECT ROUND(AVG(ROUND((UNIX_TIMESTAMP(now()) - UNIX_TIMESTAMP (birthday_at))/86400 / 365.25, 0)), 1) AS average_age
FROM users;

SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS average_age FROM users; -- этот вариант округляет до 
-- целых(например Марию он округлил до 28, имея на старте 28.6, что на мой вгляд не совсем корректно)

/* 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
 Следует учесть, что необходимы дни недели текущего года, а не года рождения.*/

-- SELECT COUNT(*) AS solution, DAYNAME(DATE_FORMAT(birthday_at, '%d.%m.%2021')) AS new_date 
-- FROM users GROUP BY new_date;

SELECT COUNT(*) AS solution, DAYNAME(DATE_FORMAT(birthday_at, '%2021-%m-%d')) AS new_date
FROM users GROUP BY new_date;


/* 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы.*/
SELECT * FROM storehouses_products;
SELECT (EXP (SUM(log(value)))) AS multiple_num FROM storehouses_products; 









 
 