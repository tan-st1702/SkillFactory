/*markdown
![Alt text](image.png)
*/

/*markdown
> Укажите название города с максимальным весом единичной доставки.
*/

SELECT
    c.city_name,
    s.weight
FROM sql.shipment s 
    natural left join sql.city c
    order by s.weight desc

/*markdown
> Как зовут водителя (first_name), который совершил наибольшее количество доставок одному клиенту?
*/

SELECT
    d.first_name,
    c.cust_name,
    count(s.ship_id)
FROM sql.shipment s
    left join sql.driver d on d.driver_id = s.driver_id
    left join sql.customer c on c.cust_id = s.cust_id
    group by d.first_name, c.cust_name
    order by count(s.ship_id) desc

/*markdown
> Укажите имя клиента, получившего наибольшее количество доставок за 2017 год.
*/

SELECT
    c.cust_name,
    count(s.ship_id)
FROM sql.shipment s
    left join sql.customer c on c.cust_id = s.cust_id
    where EXTRACT(YEAR FROM s.ship_date) = 2017
    group by c.cust_name
    order by count(s.ship_id) desc

/*markdown
### ПРИНЦИП И УСЛОВИЯ РАБОТЫ UNION
*/

SELECT 
    book_name object_name, 
    'книга' object_description 
FROM public.books
UNION ALL
SELECT
    movie_title, 'фильм' 
FROM sql.kinopoisk

/*markdown
В запросе мы использовали оператор `UNION ALL` — он присоединяет любой результат запроса к другому «снизу» при условии, что у них **одинаковая структура**, а именно: <br>
**Одинаковый тип данных**
![Alt text](image-1.png)
**Одинаковое количество столбцов**
![Alt text](image-3.png)
**Одинаковый порядок столбцов согласно типу данных**
![Alt text](image-4.png)
*/

/*markdown
### ВИДЫ UNION
*/

/*markdown
Оператор присоединения существует в двух вариантах:

* `UNION` выводит только **уникальные** записи;
* `UNION ALL` присоединяет **все строки** последующих таблиц к предыдущим, без ограничений по уникальности.
*/

/*markdown
![Alt text](image-5.png)
*/

/*markdown
### СИНТАКСИС
*/

/*markdown
![Alt text](image-6.png)
*/

/*markdown
### UNION и ограничение типов данных
*/

/*markdown
Для типизации в Postgres составляется запрос по модели `column_name::column_type`.
*/

/*markdown
### ВОЗМОЖНОСТИ UNION
*/

/*markdown
> Обобщённые данные о населении по всем городам, с детализацией до конкретного города:
*/

SELECT
         c.city_name,
         c.population
FROM
         sql.city c
UNION ALL
SELECT
         'total',
         SUM(c.population)
FROM
         sql.city c
ORDER BY 2 DESC

/*markdown
Напишите запрос, который выводит общее число доставок `total_shipments`, а также количество доставок в каждый день. Необходимые столбцы: `date_period`, `cnt_shipment`. Не забывайте о единой типизации. Упорядочите по убыванию столбца `date_period`.
*/

(select s.ship_date::text date_period, count(s.ship_id) cnt_shipment
from sql.shipment s 
    group by s.ship_date::text)

union all

(select 'total_shipments', count(s.ship_id)
from sql.shipment s)

order by date_period

/*markdown
### UNION и дополнительные условия
*/

/*markdown
![Alt text](image-7.png)
*/

/*markdown
Например, с помощью UNION можно отобразить, у кого из водителей заполнен столбец с номером телефона.
*/

SELECT
         d.first_name,
         d.last_name,
         'телефон заполнен' phone_info
FROM
         sql.driver d
WHERE d.phone IS NOT NULL

UNION

SELECT
         d.first_name,
         d.last_name,
         'телефон не заполнен' phone_info
FROM
         sql.driver d
WHERE d.phone IS NULL

/*markdown
Напишите запрос, который выводит два столбца: `city_name` и `shippings_fake`. Выведите города, куда совершались доставки. Пусть первый столбец содержит название города, а второй формируется так:

* если в городе было более десяти доставок, вывести количество доставок в этот город как есть;
* иначе — вывести количество доставок, увеличенное на пять.

Отсортируйте по убыванию получившегося «нечестного» количества доставок, а затем — по имени в алфавитном порядке.
*/

SELECT
         c.city_name,
         count(s.ship_id) shippings_fake
FROM sql.city c
        LEFT JOIN sql.shipment s on c.city_id = s.city_id
        WHERE s.ship_id IS NOT NULL
        group by c.city_name, c.state
        having count(s.ship_id) > 10

union

SELECT
         c.city_name,
         count(s.ship_id) + 5 shippings_fake
FROM sql.city c
        LEFT JOIN sql.shipment s on c.city_id = s.city_id
        WHERE s.ship_id IS NOT NULL
        group by c.city_name, c.state
        having count(s.ship_id) <= 10
    
order by shippings_fake desc, city_name

/*markdown
### UNION и ручная генерация
*/

/*markdown
![Alt text](image-8.png)
*/

/*markdown
> Запрос, который выберет наибольшее из значений:
*/

SELECT  1000000 result
UNION ALL
SELECT  541
UNION ALL
SELECT  -500
UNION ALL
SELECT  100

ORDER BY 1 DESC 
LIMIT 1

/*markdown
### ИСКЛЮЧАЕМ ПОВТОРЯЮЩИЕСЯ ДАННЫЕ
*/

/*markdown
> Предположим, нам нужно узнать, в какие города осуществлялась доставка, за исключением тех, в которых проживают водители.
*/

SELECT
        c.city_name
FROM
        sql.shipment s
        JOIN sql.city c ON s.city_id = c.city_id
EXCEPT
SELECT
        cc.city_name
FROM
        sql.driver d 
JOIN sql.city cc ON d.city_id=cc.city_id
ORDER BY 1

/*markdown
![Alt text](image-9.png)
*/

/*markdown
Синтаксические правила для оператора EXCEPT такие же, как и для UNION:

* одинаковый тип данных;
* одинаковое количество столбцов;
* одинаковый порядок столбцов согласно типу данных.

Синтаксис выглядит следующим образом:
*/

SELECT 
         n columns
FROM 
         table_1
EXCEPT
SELECT 
         n columns
FROM 
         table_2

/*markdown
### ВЫБИРАЕМ ОБЩИЕ ДАННЫЕ
*/

/*markdown
 **INTERSECT** оставляет из результатов первого запроса все строки, которые совпали с результатом выполнения второго запроса.
*/

/*markdown
![Alt text](image-10.png)
*/

/*markdown
> Предположим, нам надо вывести совпадающие по названию города и штаты.
*/

SELECT  c.city_name object_name
FROM    sql.city c
        
INTERSECT

SELECT  cc.state
FROM    sql.city cc
        
ORDER BY 1

# New York, Washington и Wyoming

/*markdown
**Cтруктура запроса сложных объединений:**
*/

SELECT          N columns
FROM          table_1
UNION / UNION ALL / EXCEPT / INTERSECT 
SELECT          N columns
FROM          table_2