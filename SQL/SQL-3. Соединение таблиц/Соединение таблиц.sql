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