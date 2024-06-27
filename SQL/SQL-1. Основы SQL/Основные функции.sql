/*markdown
# SQL: основные запросы
*/

/*markdown
**`ВИДЫ ОПЕРАТОРОВ SQL`** <br>
* операторы определения данных (Data Definition Language, DDL) — с их помощью создаются и изменяются объекты в БД (сама БД, таблицы, функции, процедуры, пользователи и т. д.);
* операторы манипуляции данными (Data Manipulation Language, DML) — с их помощью проводятся манипуляции с данными в таблицах;
* операторы определения доступа к данным (Data Control Language, DCL) — с их помощью, как следует из названия, создаются и изменяются разрешения на определённые операции с объектами в БД;
* операторы управления транзакциями (Transaction Control Language, TCL) — с их помощью осуществляется комплекс определённых действий, причём так, что либо все эти действия выполняются успешно, либо ни одно из них не выполняется вообще.
*/

/*markdown
### Фильтрация и арифметические операции
*/

SELECT /*выбор столбцов*/ 
    movie_title, /*столбец movie_title*/
    2020 - year, /*столбец, каждое из значений которого ровно разнице 2020 и соответствующего значения столбца year*/
    rating /*столбец rating*/
FROM sql.kinopoisk /*из таблицы sql.kinopoisk*/

/*markdown
Столбец с вычислениями в выводе называется ?column?, потому что Metabase не смог подобрать для него название. Определить название для столбца можно с помощью оператора `AS`:
*/

SELECT /*выбрать столбцы*/
    director, /*столбец director*/
    movie_title, /*столбец movie_title*/
    10 - rating AS difference /*столбец, значения в котором равны разнице 10 и каждого соответствующего значения столбца rating; присвоить столбцу алиас difference*/
FROM sql.kinopoisk /*из таблицы sql.kinopoisk*/

/*markdown
Для фильтрации данных пригодится ключевое слово `WHERE`.
*/

SELECT * /*выбор всех столбцов*/
FROM sql.kinopoisk /*из таблицы sql.kinopoisk*/
WHERE position = 1 /*с позицией 1*/

SELECT /*выбор всех полей*/
    position, /*столбец position*/
    movie_title, /*столбец movie_title*/
    year, /*столбец year*/
    director /*столбец director*/
FROM sql.kinopoisk /*из таблицы sql.kinopoisk*/
WHERE year < 1984 /*при условии, что год создания меньше 1984*/

/*markdown
### AND И OR
*/

# Мы хотим, чтобы фильм был относительно современным и с высоким рейтингом.

SELECT * /*выбор всех полей*/
FROM sql.kinopoisk /*из таблицы sql.kinopoisk*/
WHERE year >= 2000 /*при условии, что год создания больше или равен 2000*/
AND rating >= 8 /*и с рейтингом от 8 и выше*/

# Хотим получить информацию о фильмах, которые вышли между 1975 и 1985 годами включительно

SELECT * /*выбор всех полей*/
FROM sql.kinopoisk /*из таблицы sqk.kinopoisk*/
WHERE year >= 1975 /*при условии, что год создания 1975 и позднее*/
    AND year <= 1985 /*и ранее 1985*

/*markdown
### BETWEEN
*/

SELECT * /*выбор всех полей*/
FROM sql.kinopoisk /*из таблиц sql.kinopoisk*/
WHERE year BETWEEN 1975 AND 1985 /*при условии, что год создания лежит в промежутке между 1975 и 1985*/

/*markdown
### NOT
*/

#Выведем все фильмы, кроме тех, что вышли с 1965 по 1980 годы.

SELECT *
FROM sql.kinopoisk
WHERE year NOT BETWEEN 1965 AND 1980

SELECT /*выбор*/
    year, /*столбец year*/
    movie_title, /*столбец movie_title*/
    director /*столбец director*/
FROM sql.kinopoisk /*из таблицы sql.kinopoisk*/
WHERE (rating > 8.5 AND year < 2000) /*при условии, что рейтинг больше 8.5 и год создания до 2000*/
    OR year >= 2000 /*или год создания — 2000 и позднее*/

/*markdown
### IN
*/

/*markdown
Ещё один полезный оператор для фильтрации строк — `IN`.

Конструкции с IN имеют следующий вид:
*/

column IN (value1, value2, value3)

/*markdown
Эта запись аналогична следующей: `column = value1 OR column = value2 OR column = value3` — но выглядит проще и компактнее.
*/

/*markdown
### LIKE
*/

/*markdown
Чтобы получить все фильмы, название которых начинается на А (кириллическую), мы воспользуемся таким запросом:
*/

SELECT * /*выбор всех полей*/
FROM sql.kinopoisk /*из таблицы sql.kinopoisk*/
WHERE movie_title LIKE 'А%' /*если название фильма начинается на А*/

/*markdown
Знак процента (%) в примере показывает, что после A встречается ноль и более символов. Вы можете использовать % в любом месте внутри строки.
*/

/*markdown
Например, `movie_title LIKE '%а%б%'` выведет все фильмы, в названии которых встречается строчная буква а, а где-то после неё — б.
*/

SELECT 
  movie_title,
  year
FROM sql.kinopoisk
WHERE director LIKE 'Дэвид%'
  and rating > 8

/*markdown
### NULL
*/

/*markdown
Для пустых значений есть специальное обозначение — `NULL`.
*/

SELECT *
FROM sql.kinopoisk
WHERE overview is NULL

/*markdown
![Alt text](image.png)
*/

/*markdown
![Alt text](image-1.png)
*/

/*markdown
### ORDER BY
*/

/*markdown
Чтобы задать порядок вывода строк в запросе, применим новое ключевое слово `ORDER BY`.
*/

# Отсортируем фильмы по их названию в алфавитном порядке.

SELECT *
FROM sql.kinopoisk
ORDER BY movie_title ASC

/*markdown
`ASC` — явное указание порядка сортировки по возрастанию (англ. ascending)

`DESC` — явное указание порядка сортировки по убыванию (англ. ascending)
*/

# Выведем названия, имена режиссёров и сценаристов, а также год выхода в прокат фильмов, 
выпущенных в СССР, и отсортируем результат по убыванию рейтинга.

SELECT
    movie_title,
    director,
    screenwriter,
    year
FROM sql.kinopoisk
WHERE country = 'СССР'
ORDER BY rating DESC

/*markdown
Также в `ORDER BY` можно указывать, где должны идти пустые значения — в начале или в конце.

Такая настройка порядка вывода задаётся с помощью ключевых слов `NULLS FIRST / NULLS LAST`.
*/

SELECT
    movie_title,
    rating,
    overview,
    year
FROM sql.kinopoisk
ORDER BY overview NULLS FIRST

/*markdown
![Alt text](image-2.png)
*/

# Получили список всех режиссёров и фильмов из ТОП-250, отсортированных по году выхода в прокат, 
а внутри года — по рейтингу в порядке убывания.

SELECT
    director,
    movie_title
FROM sql.kinopoisk
ORDER BY year, rating DESC

# Для упрощения работы с ORDER BY можно использовать не названия столбцов, а их номера из вывода.

SELECT
    director,
    movie_title,
    year
FROM sql.kinopoisk
ORDER BY 1, 3 DESC

/*markdown
### LIMIT
*/

# Ограничим вывод первыми десятью строками и сможем легко понять, какие данные хранятся в таблице, 
не утяжеляя результат.

SELECT *
FROM sql.kinopoisk
LIMIT 10

Выведем ТОП-5 фильмов по рейтингу, сначала отсортировав их по убыванию, 
а потом оставив только верхние пять строк с помощью LIMIT.

SELECT
    movie_title,
    rating
FROM sql.kinopoisk 
ORDER BY rating DESC
LIMIT 5

/*markdown
![Alt text](image-3.png)
*/

/*markdown
### OFFSET
*/

/*markdown
Если `LIMIT` «оставляет» указанное число первых строк из вывода, то `OFFSET`, наоборот, «обрезает» указанное число первых строк.
*/

# Выведем название и рейтинг фильмов с четвёртого по восьмое место

SELECT
    movie_title,
    rating 
FROM sql.kinopoisk
ORDER BY rating DESC
OFFSET 3 LIMIT 5

/*markdown
Таким образом, `LIMIT` отсчитывает количество строк после указанной в `OFFSET` строки.
*/

/*markdown
запрос, чтобы вывести названия фильмов, которые вышли в прокат после 1990 года и были сняты не в России. Из этого списка оставьте только те фильмы, которые занимают с 20 по 47 места в рейтинге. Отсортируйте результат по убыванию рейтинга фильмов.
*/

SELECT
    movie_title
FROM sql.kinopoisk 
where year > 1990 and country <> 'Россия'
ORDER BY rating desc
offset 19 LIMIT 28

/*markdown
### Итоги
*/

/*markdown
Напоследок напомним структуру простого запроса:
*/

SELECT
    столбец1 AS новое_название,
    столбец2,    
    столбец3
FROM таблица
WHERE (условие1 OR условие2)    AND условие3
ORDER BY сортировка1, сортировка2
OFFSET 1 LIMIT 2

/*markdown
Напишите запрос, который выводит столбцы «Название фильма» (movie_title), «Режиссёр» (director), «Сценарист» (screenwriter), «Актёры» (actors). Оставьте только те фильмы, у которых:

* рейтинг между 8 и 8.5 (включительно) ИЛИ год выхода в прокат до 1990;
* есть описание;
* название начинается не с буквы 'Т';
* название состоит ровно из 12 символов.

Оставьте только топ-7 фильмов, отсортированных по рейтингу.
*/

SELECT
    movie_title as "Название фильма",
    director as Режиссёр,
    screenwriter as Сценарист,
    actors as Актёры
FROM sql.kinopoisk
where 
    ((rating between 8 and 8.5) or year < 1990) and
    (overview is not NULL) and
    (movie_title not LIKE 'T%') and
    (LENGTH(movie_title) = 12)
ORDER BY rating desc
limit 7