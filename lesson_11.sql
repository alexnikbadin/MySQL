/*
 * Создайте таблицу logs типа Archive. Пусть при каждом создании 
 * записи в таблицах users, catalogs и products в таблицу logs 
 * помещается время и дата создания записи, название таблицы, 
 * идентификатор первичного ключа и содержимое поля name.
 * 
 */

USE shop;

SHOW tables ;

SELECT * FROM users;

DESCRIBE users;

SELECT * FROM catalogs;

SELECT * FROM products;
/*
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
  ('Мария', '1992-08-29', now(), now());*/

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	created_at TIMESTAMP NOT NULL,
	table_name VARCHAR(45) NOT NULL,
	pr_key_id BIGINT(20) NOT NULL,
	name_value VARCHAR(45) NOT NULL
) ENGINE = ARCHIVE;

SELECT * FROM logs;



DROP TRIGGER IF EXISTS logs_users; -- создаем триггер для заполнения logs при заполнении users

DELIMITER //

CREATE TRIGGER logs_users AFTER UPDATE ON users

FOR EACH ROW

BEGIN
	
	INSERT INTO logs (created_at, table_name, pr_key_id, name_value)
	VALUES (NOW(), 'users', NEW.id, NEW.name);

END //

DELIMITER ;


UPDATE users -- проверяем работу триггера

SET name = 'Андрей', birthday_at = '1989-11-23', 
created_at = NOW(), updated_at = NOW()
WHERE id = LAST_INSERT_ID() ; 




DROP TRIGGER IF EXISTS logs_catalogs; -- создаем триггер для заполнения logs при заполнении catalogs

DELIMITER //

CREATE TRIGGER logs_catalogs AFTER UPDATE ON catalogs

FOR EACH ROW

BEGIN
	
	INSERT INTO logs (created_at, table_name, pr_key_id, name_value)
	VALUES (NOW(), 'catalogs', NEW.id, NEW.name);

END //

DELIMITER ;

UPDATE catalogs -- проверяем работу триггера

SET name = 'Мониторы'
WHERE id = LAST_INSERT_ID(); 


DROP TRIGGER IF EXISTS logs_products; -- создаем триггер для заполнения logs при заполнении products

DELIMITER //

CREATE TRIGGER logs_products AFTER UPDATE ON products

FOR EACH ROW

BEGIN
	
	INSERT INTO logs (created_at, table_name, pr_key_id, name_value)
	VALUES (NOW(), 'products', NEW.id, NEW.name);

END //

DELIMITER ;

UPDATE products -- проверяем работу триггера

SET name = 'Intel Core i3-8110', desription = NULL, price = 12000, 
catalog_id = 1, created_at = NOW(), updated_at = NOW() 
WHERE id = LAST_INSERT_ID(); 


/*
 * 2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.
 * 
 */

SELECT * FROM users u1 -- если я правильно понял задание, с вашей подсказки на уроке), получаем 823543 записи
	 JOIN users u2
	 JOIN users u3
	 JOIN users u4
	 JOIN users u5
	 JOIN users u6 
	 JOIN users u7;

