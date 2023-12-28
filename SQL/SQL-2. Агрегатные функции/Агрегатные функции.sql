/*markdown
### Убираем повторяющиеся значения
*/

# Получим, например, все уникальные пары основного и дополнительного типов для покемонов

SELECT DISTINCT
    type1,
    type2
FROM sql.pokemon

/*markdown
![Alt text](image.png)
*/

/*markdown
### Агрегатные функции
*/

# Давайте посчитаем количество строк в таблице. Для этого применим агрегатную функцию COUNT.

SELECT
    COUNT(*)
FROM sql.pokemon

/*markdown
![Alt text](image-1.png)
*/

/*markdown
Внутри функции `COUNT` мы можем также применять `DISTINCT`, чтобы вычислить количество уникальных значений.
*/

SELECT
    COUNT(DISTINCT type1)
FROM sql.pokemon

/*markdown
##### ОСНОВНЫЕ АГРЕГАТНЫЕ ФУНКЦИИ
*/

/*markdown
* `COUNT` — вычисляет число непустых строк;
* `SUM` — вычисляет сумму;
* `AVG` — вычисляет среднее;
* `MAX` — вычисляет максимум;
* `MIN` — вычисляет минимум.
*/

# Найдите максимальное значение атаки среди всех покемонов

SELECT
    max(attack)
FROM sql.pokemon

# Какое среднее количество очков здоровья у покемонов-драконов (то есть тех, у кого основной тип — Dragon)?

SELECT
    avg(hp)
FROM sql.pokemon
where type1 = 'Dragon'

/*markdown
Кроме того, мы можем применять несколько агрегатных функций в одном запросе.
*/

SELECT
    COUNT(*) AS "всего травяных покемонов",
    COUNT(type2) AS "покемонов с дополнительным типом",
    AVG(attack) AS "средняя атака",
    AVG(defense) AS "средняя защита"
FROM sql.pokemon
WHERE type1 = 'Grass'

/*markdown
В результате получим следующий вывод:
![Alt text](image-2.png)
*/

/*markdown
### Группировка
*/

/*markdown
`GROUP BY` используется для определения групп выходных строк, к которым могут применяться агрегатные функции.
*/

# Выведем число покемонов каждого типа

SELECT /*выбор*/
    type1 AS pokemon_type, /*столбец type1; присвоить алиас pokemon_type*/
    COUNT(*) AS pokemon_count /*подсчёт всех строк; присвоить алиас pokemon_count*/
FROM sql.pokemon /*из таблицы sql.pokemon*/
GROUP BY type1 /*группировка по столбцу type1*/
ORDER BY type1 /*сортировка по столбцу type1*/

/*markdown
![Alt text](image-3.png)
*/

SELECT
    type1 AS pokemon_type,
    COUNT(*) AS pokemon_count
FROM sql.pokemon
GROUP BY pokemon_type
ORDER BY COUNT(*) DESC

/*markdown
![Alt text](image-5.png)
*/

/*markdown
![Alt text](image-4.png)
*/

SELECT
    type1 AS primary_type,
    type2 AS additional_type,
    COUNT(*) AS pokemon_count
FROM sql.pokemon
GROUP BY 1, 2
ORDER BY 1, 2 NULLS FIRST

/*markdown
![Alt text](image-6.png)
*/

/*markdown
`GROUP BY` можно использовать и без агрегатных функций. Тогда его действие будет равносильно действию `DISTINCT`.
*/

/*markdown
# Фильтрация агрегированных строк
*/

/*markdown
 Если ключевое слово `WHERE` определяет фильтрацию строк до агрегирования, то для фильтрации уже агрегированных данных применяется ключевое слово `HAVING`.
*/

/*markdown
![Alt text](image-7.png)
*/

# Выведем типы покемонов и их средний показатель атаки, 
при этом оставим только тех, у кого средняя атака больше 90.

SELECT /*выбор*/
    type1 AS primary_type, /*таблица type1; присвоить алиас primary_type*/
    AVG(attack) AS avg_attack /*расчёт среднего по столбцу attack; присвоить алиас avg_attack*/
FROM sql.pokemon /*из таблицы sql.pokemon*/
GROUP BY primary_type /*группировать по столбцу primary_type*/
HAVING AVG(attack) > 90 /*фильтровать по среднему значению attack, превышающему 90*/

/*markdown
![Alt text](image-8.png)
*/

/*markdown
# РЕЗЮМЕ
*/

/*markdown
В общем виде синтаксис оператора `SELECT`, с учётом имеющихся на данный момент знаний, представляем следующим образом:
*/

SELECT [ALL | DISTINCT] список_столбцов|*
FROM список_имён_таблиц
[WHERE условие_поиска]
[GROUP BY список_имён_столбцов]
[HAVING условие_поиска]
[ORDER BY имя_столбца [ASC | DESC],…]

/*markdown
![Alt text](image-9.png)
*/

/*markdown
Напишите запрос, который выведет основной и дополнительный типы покемонов (столбцы primary_type и additional_type) для тех, у кого средний показатель атаки больше 100 и максимальный показатель очков здоровья меньше 80.
*/

SELECT
    type1 AS primary_type,
    type2 AS additional_type
FROM sql.pokemon
group by primary_type, additional_type
HAVING AVG(attack) > 100 and max(hp) < 80

/*markdown
Общая струткура
*/

SELECT
    столбец1 AS новое_название,
    столбец2,
    АГРЕГАТ(столбец3)
FROM таблица
WHERE (условие1 OR условие2)
    AND условие3
GROUP BY столбец1, столбец2
HAVING АГРЕГАТ(столбец3) > 5
ORDER BY сортировка1, сортировка2
OFFSET 1 LIMIT 2