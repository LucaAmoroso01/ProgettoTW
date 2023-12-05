CREATE VIEW Vista_Punteggio AS
SELECT a.numero_pilota,
       MIN(p.nome_pilota) AS nome_pilota,
       MIN(p.cognome_pilota) AS cognome_pilota,
       MIN(p.nome_scuderia) AS nome_scuderia,
       SUM(punti) AS punteggio_totale
FROM (
    SELECT DISTINCT g.data_gara,
                    g.numero_pilota,
                    dg.posizione_finale_gara,
                    'giro veloce' AS discriminatore_gara,
                    1 AS punti
    FROM Gara g
    JOIN Si_Ritira sr ON g.data_gara = sr.data_gara AND g.numero_pilota <> sr.numero_pilota
    JOIN Disputa_Gara dg ON g.data_gara = dg.data_gara AND g.numero_pilota = dg.numero_pilota
    WHERE dg.posizione_finale_gara <= 10

    UNION

    SELECT dg.data_gara,
           dg.numero_pilota,
           dg.posizione_finale_gara,
           g.discriminatore_gara,
           CASE
               WHEN dg.posizione_finale_gara <= 8 THEN
                   CASE dg.posizione_finale_gara
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
           END AS punti
    FROM Disputa_Gara dg
    JOIN Gara g ON dg.data_gara = g.data_gara
    WHERE discriminatore_gara = 'Sprint'

    UNION

    SELECT dg.data_gara,
           dg.numero_pilota,
           dg.posizione_finale_gara,
           g.discriminatore_gara,
           CASE
               WHEN dg.posizione_finale_gara <= 10 THEN
                   CASE dg.posizione_finale_gara
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
           END AS punti
    FROM Disputa_Gara dg
    JOIN Gara g ON dg.data_gara = g.data_gara
    WHERE discriminatore_gara = 'Completa'
) a
JOIN Pilota p ON a.numero_pilota = p.numero_pilota
GROUP BY a.numero_pilota
ORDER BY punteggio_totale DESC;
