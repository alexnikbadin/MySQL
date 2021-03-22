
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
  ('Геннадий', '1990-10-05', now(), now()),
  ('Наталья', '1984-11-12', now(), now()),
  ('Александр', '1985-05-20', now(), now()),
  ('Сергей', '1988-02-14', now(), now()),
  ('Иван', '1998-01-12', now(), now()),
  ('Мария', '1992-08-29', now(), now());
  
 SELECT * FROM users;

/* 2. Таблица users была неудачно спроектирована. 
 Записи created_at и updated_at были заданы типом VARCHAR 
 и в них долгое время помещались значения в формате 20.10.2017 8:10. 
 Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения. */


 ALTER TABLE users MODIFY created_at varchar(145) NOT NULL;
 ALTER TABLE users MODIFY updated_at varchar(145) NOT NULL;
 DESCRIBE users;
 ALTER TABLE users MODIFY created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
 ALTER TABLE users MODIFY updated_at DATETIME DEFAULT CURRENT_TIMESTAMP;
 SELECT * FROM users;




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
SELECT value FROM storehouses_products ORDER BY value DESC; --  не могу докрутить до желаемого(


/* 4. (по желанию) Из таблицы users необходимо извлечь пользователей, 
 родившихся в августе и мае. 
 Месяцы заданы в виде списка английских названий (may, august)*/

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at VARCHAR(45) COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
  ('Геннадий', '1990 October 05', now(), now()),
  ('Наталья', '1984 November 12', now(), now()),
  ('Александр', '1985 May 20', now(), now()),
  ('Сергей', '1988 February 14', now(), now()),
  ('Иван', '1998 January 12', now(), now()),
  ('Мария', '1992 August 29', now(), now());
  


SELECT * FROM users;
SELECT name, birthday_at FROM users WHERE birthday_at LIKE '%may%' OR birthday_at LIKE '%august%'; 


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
 
SELECT ROUND(AVG(ROUND((UNIX_TIMESTAMP(now()) - UNIX_TIMESTAMP (birthday_at))/86400 / 365.25, 0)), 1) AS average_age
FROM users;

/* 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
 Следует учесть, что необходимы дни недели текущего года, а не года рождения.*/

SELECT COUNT(*) AS solution, DAYNAME(DATE_FORMAT(birthday_at, '%d.%m.%2021')) AS new_date 
FROM users GROUP BY new_date;


/* 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы.*/

SELECT (EXP (SUM(log(value)))) AS multiple_num FROM storehouses_products; 









 
 