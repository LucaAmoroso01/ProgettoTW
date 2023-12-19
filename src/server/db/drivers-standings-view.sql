CREATE VIEW drivers_teams_standings AS
SELECT a.driver_number,
       MIN(p.driver_first_name) AS driver_first_name,
       MIN(p.driver_last_name) AS driver_last_name,
       MIN(p.team_name) AS team_name,
       SUM(points) AS total_points
FROM (
    SELECT DISTINCT g.race_date,
                    g.driver_number,
                    dg.final_race_position,
                    'giro veloce' AS race_type,
                    1 AS points
    FROM race g
    JOIN retire sr ON g.race_date = sr.race_date AND g.driver_number <> sr.driver_number
    JOIN race_dispute dg ON g.race_date = dg.race_date AND g.driver_number = dg.driver_number
    WHERE dg.final_race_position <= 10

    UNION

    SELECT dg.race_date,
           dg.driver_number,
           dg.final_race_position,
           g.race_type,
           CASE
               WHEN dg.final_race_position <= 8 THEN
                   CASE dg.final_race_position
                       WHEN 1 THEN 8
                       WHEN 2 THEN 7
                       WHEN 3 THEN 6
                       WHEN 4 THEN 5
                       WHEN 5 THEN 4
                       WHEN 6 THEN 3
                       WHEN 7 THEN 2
                       WHEN 8 THEN 1
                       ELSE 0
                   END
               ELSE 0
           END AS points
    FROM race_dispute dg
    JOIN race g ON dg.race_date = g.race_date
    WHERE race_type = 'Sprint'

    UNION

    SELECT dg.race_date,
           dg.driver_number,
           dg.final_race_position,
           g.race_type,
           CASE
               WHEN dg.final_race_position <= 10 THEN
                   CASE dg.final_race_position
                       WHEN 1 THEN 25
                       WHEN 2 THEN 18
                       WHEN 3 THEN 15
                       WHEN 4 THEN 12
                       WHEN 5 THEN 10
                       WHEN 6 THEN 8
                       WHEN 7 THEN 6
                       WHEN 8 THEN 4
                       WHEN 9 THEN 2
                       WHEN 10 THEN 1
                       ELSE 0
                   END
               ELSE 0
           END AS points
    FROM race_dispute dg
    JOIN race g ON dg.race_date = g.race_date
    WHERE race_type = 'Completa'
) a
JOIN driver p ON a.driver_number = p.driver_number
GROUP BY a.driver_number
ORDER BY total_points DESC;
