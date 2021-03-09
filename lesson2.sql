/* Практическое задание #2. */

/* Задание # 2.
* Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.
*/
- создание базы данных example
CREATE database example;

- выбор активной БД
use example;

-создание таблицы
CREATE TABLE  users (Id INT, name VARCHAR(20));

/* Задание # 3.
 * Создайте дамп базы данных example из предыдущего задания, разверните содержимое дампа в новую базу данных sample.
 */
- создание базы данных sample
CREATE database sample;

- создаем дамп БД example в файл sample.sql (набираем из консоли)
mysqldump example > sample.sql

-делаем дамп БД example из файла sample.sql в БД sample
mysql sample < sample.sql

-переходим в mysql ->use sample; -> show tables; и видим users

/* Задание # 4.
* (по желанию) Ознакомьтесь более подробно с документацией утилиты mysqldump. Создайте дамп 
* единственной таблицы help_keyword базы данных mysql. 
* Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы.
*/
- создание базы данных copy_mysql 
create database copy_mysql;

- создаем дамп первых 100 строк таблицы help_keyword БД mysql в файл first_100.sql 
mysqldump mysql --where="true limit 100" help_keyword > first_100.sql

-заходим в mysql
-выбираем БД  copy_mysql
use copy_mysql;

-разворачиваем БД из файла first_100.sql
source first_100.sql;

mysqldump -u имя_пользователя -p имя_базы_данных имя_таблицы1, имя_таблицы2, ... > путь_и_имя_файла_дампа

