/*markdown
# Соединение таблиц по ключу
*/

/*markdown
### ОБЪЕДИНЯЕМ ТАБЛИЦЫ БЕЗ ОПЕРАТОРОВ
*/

/*markdown
Чтобы соединить таблицы и получить данные о домашней команде по каждому матчу, добавим условие
`where home_team_api_id = api_id`.
*/

SELECT *
FROM
    sql.teams,
    sql.matches
WHERE home_team_api_id = api_id

/*markdown
### JOIN
*/

SELECT 
    long_name,
    home_team_goals,
    away_team_goals
FROM
    sql.teams,
    sql.matches
WHERE home_team_api_id = api_id

/*markdown
В качестве примера используем запрос из предыдущего юнита.

и запишем его с использованием `JOIN`.
*/

SELECT 
    long_name,
    home_team_goals,
    away_team_goals
FROM    
    sql.teams
JOIN sql.matches on home_team_api_id = api_id

/*markdown
Оператор `JOIN` упрощает процесс соединения таблиц.

Его синтаксис можно представить следующим образом:
*/

SELECT
        столбец1,
	столбец2,
	...
FROM
	таблица1
JOIN таблица2 ON условие

/*markdown
С помощью `JOIN` можно соединить и более двух таблиц.
*/

SELECT
        столбец1,
	столбец2,
	...
FROM
	таблица1
JOIN таблица2 ON условие
JOIN таблица3 ON условие

/*markdown
![Alt text](image.png)
*/

SELECT
        столбец1 новое_название_столбца,
	столбец2 новое_название_столбца,
	...
FROM
	таблица1 короткое_название_1
JOIN таблица2 короткое_название_2 ON условие

/*markdown
Напишите запрос, который выведет столбцы:

* id матча,
* короткое название домашней команды (home_short),
* короткое название гостевой команды (away_short).

Отсортируйте запрос по возрастанию id матча.
*/

SELECT
    h.long_name "домашняя команда", /*столбец long_name таблицы h*/
    m.home_team_goals "голы домашней команды", /*столбец home_team_goals таблицы m*/
    m.away_team_goals "голы гостевой команды", /*столбец away_team_goals таблицы m*/
    a.long_name "гостевая команда" /*столбец long_name таблицы a*/
FROM
    sql.matches m /*таблица matches с алиасом m*/
    JOIN sql.teams h ON m.home_team_api_id = h.api_id /*оператор соединения таблиц; таблица teams с алиасом h; условие: home_team_api_id таблицы m равен api_id таблицы h*/
    JOIN sql.teams a ON m.away_team_api_id = a.api_id /*оператор соединения таблиц; таблица teams с алиасом a; условие: away_team_api_id таблицы m равен api_id таблицы a*/

/*markdown
# Фильтрация и агрегатные функции
*/

/*markdown
### ФИЛЬТРАЦИЯ ДАННЫХ
*/

/*markdown
К соединённым таблицам применимы функции фильтрации данных.

Например, можно вывести `id` матчей, в которых команда `Arsenal` была гостевой.
*/

SELECT 
    m.id /*столбец id таблицы m*/
FROM
    sql.teams t /*таблица teams с алиасом t*/
    JOIN sql.matches m ON m.away_team_api_id = t.api_id /*оператор соединения таблиц; таблица matches с алиасом m; условие: away_team_api_id таблицы m равен api_id таблицы t*/
WHERE long_name = 'Arsenal' /*long_name таблицы teams имеет значение Arsenal*/

/*markdown
Напишите запрос, который выведет полное название домашней команды (`long_name`), количество голов домашней команды (`home_goal`) и количество голов гостевой команды (`away_goal`) в матчах, где домашней командой были команды с коротким названием `'GEN'`. Отсортируйте запрос по `id` матча в порядке возрастания.
*/

SELECT 
    h.long_name,
    home_team_goals as home_goal,
    away_team_goals as away_goal
FROM
	sql.matches m
    JOIN sql.teams a ON m.away_team_api_id = a.api_id
    JOIN sql.teams h ON m.home_team_api_id = h.api_id
where h.short_name = 'GEN'
order by m.id

/*markdown
### АГРЕГАЦИЯ ДАННЫХ
*/

/*markdown
> Сумма голов матча, забитых командами, агрегированную по гостевым командам (совокупное количество голов в матче, забитых обеими командами, суммированное в разрезе гостевых команд)
*/

SELECT
    t.long_name, /*столбец long_name таблицы t*/
    SUM(m.home_team_goals) + SUM(m.away_team_goals) match_goals /*функция суммирования; столбец home_team_goals таблицы m; функция суммирования; столбец away_team_goals таблицы m; новое название столбца*/
FROM
    sql.matches m /*таблица matches с алиасом m*/
    JOIN sql.teams t ON m.away_team_api_id = t.api_id /*оператор соединения таблиц; таблица teams с алиасом t; условие: away_team_api_id таблицы m равен api_id таблицы t*/
GROUP BY t.id /*группировка по столбцу id таблицы t*/

/*markdown
![Alt text](image-1.png)
*/

/*markdown
Также, применяя агрегатные функции к соединённым таблицам, обращайте внимание на указание алиасов (или таблиц) при группировке и указании столбцов агрегатных функций. В нашей соединённой таблице есть два столбца с названием id, и если бы мы сформировали запрос без указания таблицы, как указано ниже, то...
*/

SELECT
    m.season, /*столбец season таблицы m*/
    t.long_name, /*столбец long_name таблицы t*/
    SUM(m.home_team_goals) + SUM(m.away_team_goals) total_goals /*функция суммирования; столбец home_team_goals таблицы m; функция суммирования; столбец away_team_goals таблицы m; новое название столбца*/
FROM sql.matches m /*таблица matches с алиасом m*/
JOIN sql.teams t ON t.api_id = m.home_team_api_id OR t.api_id = m.away_team_api_id /*оператор соединения таблиц; таблица teams с алиасом t; условие: home_team_api_id таблицы m равен api_id таблицы t или away_team_api_id таблицы m равен api_id таблицы t*/
GROUP BY m.season, t.id /*группировка по столбцам season таблицы m и id таблицы t*/
HAVING SUM(m.home_team_goals) + SUM(m.away_team_goals) > 100 /*оператор фильтрации сгруппированных данных; функция суммирования; home_team_goals таблицы m; функция суммирования; away_team_goals таблицы m; больше 100*/

/*markdown
# Способы соединения таблиц
*/

/*markdown
### ОПЕРАТОРЫ
*/

/*markdown
**INNER JOIN** - это тот же JOIN (слово inner в операторе можно опустить).
*/

/*markdown
![Alt text](dst3-u2-md3_5_1.gif)
*/

/*markdown
![Alt text](image-4.png)
*/

/*markdown
В таблице teams есть данные о 299 различных командах — можем проверить это с помощью запроса.
*/

SELECT 
COUNT(DISTINCT id) /*оператор подсчёта строк; оператор исключения повторяющихся строк; столбец id*/
FROM sql.teams /*таблица teams*/

/*markdown
Теперь добавим к teams таблицу с матчами.
*/

SELECT 
COUNT(DISTINCT t.id) /*оператор подсчёта строк; оператор исключения повторяющихся строк; столбец id*/
FROM 
sql.teams t /*таблица teams с алиасом t*/
JOIN sql.matches m ON t.api_id = m.home_team_api_id OR t.api_id = m.away_team_api_id /*оператор соединения inner JOIN; таблица teams с алиасом t; условие: home_team_api_id таблицы m равен api_id таблицы t или away_team_api_id таблицы m равен api_id таблицы t*/

/*markdown
### LEFT OUTER JOIN И RIGHT OUTER JOIN
*/

/*markdown
![Alt text](dst3-u2-md3_5_2.gif)
*/

/*markdown
![Alt text](image-6.png)
*/

/*markdown
вывести полные названия команд, данных по которым нет в таблице matches.
*/

SELECT
    t.long_name,
    m.id
FROM sql.teams t
LEFT JOIN sql.matches m ON t.api_id = m.home_team_api_id OR t.api_id = m.away_team_api_id
ORDER BY m.id DESC

/*markdown
Теперь, чтобы выбрать такие команды, которые не принимали участия в матчах, достаточно добавить условие where m.id is null (или любое другое поле таблицы matches).
*/

SELECT
    t.long_name
FROM 
    sql.teams t
LEFT JOIN sql.matches m ON t.api_id = m.home_team_api_id OR t.api_id = m.away_team_api_id
WHERE m.id IS NULL

SELECT
    t.long_name FROM sql.teams t
LEFT JOIN sql.matches m ON t.api_id = m.home_team_api_id OR t.api_id = m.away_team_api_id
WHERE
    m.season = '2008/2009'
AND t.long_name = 'KAS Eupen'

/*markdown
> В ответе Metabase получим No results!, так как вместе с фильтром m.season = '2008/2009' исчезли все строки, значения которых NULL.
*/

/*markdown
### FULL OUTER JOIN
*/

/*markdown
![Alt text](image-7.png)
*/

/*markdown
![Alt text](image-8.png)
*/

/*markdown
### CROSS JOIN
*/

/*markdown
![Alt text](image-9.png)
*/

SELECT * /*выбор всех полей*/
FROM
    sql.teams /*таблица teams*/
    CROSS JOIN sql.matches /*таблица matches*/

/*markdown
Также этот запрос можно записать с помощью INNER JOIN с условием on true — результат будет тот же.
*/

SELECT * /*выбор всех полей*/
FROM
    sql.teams /*таблица teams*/
    JOIN sql.matches ON TRUE /*оператор соединения INNER JOIN; таблица matches; условие: для всех случаев*/

/*markdown
### NATURAL JOIN
*/

/*markdown
> Ключевое слово **`natural`** в начале оператора **`JOIN`** позволяет не указывать условие соединения таблиц — для соединения будут использованы столбцы с одинаковым названием из этих таблиц.
*/

/*markdown
![Alt text](image-10.png)
*/

/*markdown
### ОБЩАЯ ЛОГИКА ПОСТРОЕНИЯ ЗАПРОСА С JOIN
*/

/*markdown
<div style="width: 100%;"><div style="position: relative; padding-bottom: 55.00000000000001%; padding-top: 0; height: 0;"><iframe title="Модуль SQL-3" frameborder="0" width="2000px" height="1100px" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;" src="https://view.genial.ly/617fe0627516f70d8cd39fb0" type="text/html" allowscriptaccess="always" allowfullscreen="true" scrolling="yes" allownetworking="all"></iframe> </div> </div>
*/