CREATE DATABASE sample;

USE sample;

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

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  desription TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, desription, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = 'Скидки';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';





/*
 * Практическое задание по теме “Транзакции, переменные, представления”
 * 
 * 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. 
Используйте транзакции.
 * 
 */



USE shop;
USE sample;
SHOW tables;

SELECT * FROM users;

-- 1 вариант. Не работает
START TRANSACTION;

UPDATE sample.users 
SET id = last_insert_id(), 
	name = (SELECT u.name FROM shop.users u WHERE id = 1), 
	birthday_at = (SELECT u.birthday_at FROM shop.users u WHERE id = 1), 
	created_at = NOW(), 
	updated_at = now();
COMMIT;


-- 2 вариант. Не работает
START TRANSACTION;
INSERT INTO sample.users SELECT * FROM shop.users WHERE id = 1;
COMMIT;

-- 3 вариант. Работает, но не знаю насколько правильно
START TRANSACTION;

INSERT INTO users (id, name, birthday_at, created_at, updated_at)
  VALUES (last_insert_id(), 'Геннадий', '1990-10-05', now(), now());
 
COMMIT;


/*
 * 2. Создайте представление, которое выводит название name товарной позиции 
 * из таблицы products и соответствующее название каталога name из таблицы catalogs.
 */


USE shop;

SELECT * FROM products;
SELECT * FROM catalogs;


CREATE or replace VIEW view_names
AS 
SELECT p.name AS product_name, c.name AS catalog_name 
FROM products p
	JOIN catalogs c ON p.catalog_id = c.id;

SELECT * FROM view_names;


-- к заданию 3 я даже не понял как подступиться(

/*
 * 4. (по желанию) Пусть имеется любая таблица с календарным полем created_at. 
 * Создайте запрос, который удаляет устаревшие записи из таблицы, 
 * оставляя только 5 самых свежих записей.
 * 
 */
DROP TABLE dates;
CREATE TABLE dates(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
created_at DATE
);

INSERT INTO dates (id, created_at)
VALUES (DEFAULT, '2018-08-01'),
	   (DEFAULT, '2018-08-02'),
	   (DEFAULT, '2018-08-03'),
	   (DEFAULT, '2018-08-04'),
	   (DEFAULT, '2018-09-01'),
	   (DEFAULT, '2018-09-02'),
	   (DEFAULT, '2018-10-02'),
	   (DEFAULT, '2018-11-02');
	  

DELETE FROM dates d1
		JOIN dates d2
WHERE d1.created_at != (SELECT d2.created_at FROM d2 ORDER BY d2.created_at DESC LIMIT 5); -- не работает

SELECT * FROM dates;



CREATE or replace VIEW view_dates
AS 
SELECT created_at FROM dates ORDER BY created_at DESC LIMIT 5;


SELECT * FROM view_dates;

DELETE FROM dates WHERE created_at != (SELECT created_at FROM view_dates); -- не работает



/*
 * Практическое задание по теме “Хранимые процедуры и функции, триггеры"
   
   1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
   в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро"
   , с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
    с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

 */


DROP FUNCTION IF EXISTS hello;

DELIMITER //

CREATE FUNCTION hello()
RETURNS VARCHAR(25) READS SQL DATA

BEGIN
	IF time(now()) BETWEEN CAST('06:00:01' AS time) AND CAST('12:00:00' AS Time)
		THEN RETURN 'Доброе утро';
	
	ELSEIF time(now()) BETWEEN CAST('12:00:01' AS time) AND CAST('18:00:00' AS Time)
		THEN RETURN 'Добрый день';
	
	ELSEIF time(now()) BETWEEN CAST('18:00:01' AS time) AND CAST('00:00:00' AS Time)
		THEN RETURN 'Добрый вечер';
	
    ELSE 
    	RETURN 'Доброй ночи';
    
    END IF;
    
END //

DELIMITER ;

SELECT hello();



/*
 * 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
 *  Допустимо присутствие обоих полей или одно из них. 
 * Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
 * Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
 * При попытке присвоить полям NULL-значение необходимо отменить операцию.
 
 */ -- Надеюсь, я правильно понял задание)
 *
 
SELECT * FROM products;

DROP TRIGGER IF EXISTS null_caution;

DELIMITER //

CREATE TRIGGER null_caution BEFORE UPDATE ON products

FOR EACH ROW 

BEGIN 
	IF NEW.name IS NULL AND NEW.desription IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Warning! Both column are trying to get NULL value!';
	END IF;

END //

DELIMITER ;


UPDATE products 
SET name = 'AMD FX-8321' , desription = NULL, 
price = 10000, catalog_id = 1, created_at = NOW(), updated_at = NOW()
WHERE name = 'AMD FX-8320';


UPDATE products 
SET name =  NULL, desription = NULL, 
price = 10000, catalog_id = 1, created_at = NOW(), updated_at = NOW()
WHERE name = 'Intel Core i3-8100'; 


/*
 * 
 * 3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
 * Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел.
 *  Вызов функции FIBONACCI(10) должен возвращать число 55. 
 */

/*DROP FUNCTION IF EXISTS fibo;

DELIMITER //

CREATE FUNCTION fibo(x int)
RETURNS int READS SQL DATA  нет вариантов решения

BEGIN
	DECLARE fibo_9 int
	SET fibo_9 = 

   
    
END //

