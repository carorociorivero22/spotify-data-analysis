-- ============================================================
-- PROYECTO: ANÁLISIS DE DATOS DE SPOTIFY
-- Herramientas: MySQL / SQL / Power BI
-- Base de datos: spotify_artist_streaming
-- Tabla principal: spotify_tracks
-- ============================================================

-- ============================================================
-- 1. ESTRUCTURA DE LA TABLA
-- ============================================================

-- La siguiente estructura corresponde a la tabla principal
-- utilizada para almacenar la información de las canciones.

-- DROP TABLE IF EXISTS spotify_tracks;

-- CREATE TABLE spotify_tracks (
--     track_id VARCHAR(36),
--     track_name VARCHAR(255),
--     artist_name VARCHAR(255),
--     album_name VARCHAR(255),
--     release_date DATE,
--     genre VARCHAR(100),
--     duration_ms INT,
--     popularity INT,
--     danceability DECIMAL(5,4),
--     energy DECIMAL(5,4),
--     `key` INT,
--     loudness DECIMAL(6,2),
--     mode INT,
--     instrumentalness DECIMAL(10,8),
--     tempo DECIMAL(7,2),
--     stream_count BIGINT,
--     country VARCHAR(10),
--     explicit VARCHAR(5),
--     label VARCHAR(255),
--     release_year INT,
--     release_month INT,
--     release_day_of_week VARCHAR(20),
--     duration_minutes DECIMAL(10,2),
--     popularity_category VARCHAR(20),
--     loudness_category VARCHAR(20),
--     key_name VARCHAR(5),
--     mode_name VARCHAR(10),
--     is_explicit_bool VARCHAR(5),
--     release_quarter VARCHAR(2),
--     is_weekend_release VARCHAR(5),
--     log_stream_count DECIMAL(12,4),
--     upbeat_score DECIMAL(10,4),
--     artist_track_count INT
-- );

-- ============================================================
-- 2. CONTROL INICIAL DE REGISTROS
-- ============================================================

-- Cantidad total de canciones/registros.

SELECT
COUNT(*) AS cantidad_registros
FROM spotify_artist_streaming.spotify_tracks;

-- ============================================================
-- 3. CONTROL DE VALORES NULL
-- ============================================================

-- Se verifica la presencia de valores NULL en las principales
-- variables utilizadas en el análisis.

SELECT
SUM(track_id IS NULL) AS track_id_null,
SUM(track_name IS NULL) AS track_name_null,
SUM(artist_name IS NULL) AS artist_name_null,
SUM(album_name IS NULL) AS album_name_null,
SUM(release_date IS NULL) AS release_date_null,
SUM(genre IS NULL) AS genre_null,
SUM(stream_count IS NULL) AS stream_count_null,
SUM(popularity IS NULL) AS popularity_null,
SUM(danceability IS NULL) AS danceability_null,
SUM(energy IS NULL) AS energy_null,
SUM(`key` IS NULL) AS key_null,
SUM(loudness IS NULL) AS loudness_null,
SUM(mode IS NULL) AS mode_null,
SUM(instrumentalness IS NULL) AS instrumentalness_null,
SUM(tempo IS NULL) AS tempo_null
FROM spotify_artist_streaming.spotify_tracks;

-- ============================================================
-- 4. CONTROL DE CAMPOS VACÍOS
-- ============================================================

-- Se verifica que las variables de tipo texto no contengan
-- cadenas vacías.

SELECT *
FROM spotify_artist_streaming.spotify_tracks
WHERE track_name = ''
OR artist_name = ''
OR album_name = ''
OR genre = ''
OR country = ''
OR explicit = ''
OR label = ''
OR popularity_category = ''
OR loudness_category = ''
OR key_name = ''
OR mode_name = ''
OR is_explicit_bool = ''
OR release_quarter = ''
OR is_weekend_release = '';

-- ============================================================
-- 5. CONTROL DE DUPLICADOS
-- ============================================================

-- Se comprueba la cantidad de identificadores de canción únicos
-- y se compara con la cantidad total de registros.

SELECT
COUNT(*) AS total_registros,
COUNT(DISTINCT track_id) AS track_id_unicos
FROM spotify_artist_streaming.spotify_tracks;

-- ============================================================
-- 6. EXPLORACIÓN DE CATEGORÍAS
-- ============================================================

-- Cantidad de géneros diferentes.

SELECT
COUNT(DISTINCT genre) AS generos_unicos
FROM spotify_artist_streaming.spotify_tracks;

-- Cantidad de artistas diferentes.

SELECT
COUNT(DISTINCT artist_name) AS artistas_unicos
FROM spotify_artist_streaming.spotify_tracks;

-- Cantidad de países diferentes.

SELECT
COUNT(DISTINCT country) AS paises_unicos
FROM spotify_artist_streaming.spotify_tracks;

-- Años disponibles en el dataset.

SELECT DISTINCT
release_year
FROM spotify_artist_streaming.spotify_tracks
ORDER BY release_year;

-- ============================================================
-- 7. CONTROL DE CALIDAD DE LOS DATOS
-- ============================================================

-- Popularidad: rango esperado entre 0 y 100.

SELECT *
FROM spotify_artist_streaming.spotify_tracks
WHERE popularity < 0
OR popularity > 100;

-- Danceability: rango esperado entre 0 y 1.

SELECT *
FROM spotify_artist_streaming.spotify_tracks
WHERE danceability < 0
OR danceability > 1;

-- Energy: rango esperado entre 0 y 1.

SELECT *
FROM spotify_artist_streaming.spotify_tracks
WHERE energy < 0
OR energy > 1;

-- Instrumentalness: rango esperado entre 0 y 1.

SELECT *
FROM spotify_artist_streaming.spotify_tracks
WHERE instrumentalness < 0
OR instrumentalness > 1;

-- Mode: valores esperados 0 o 1.

SELECT *
FROM spotify_artist_streaming.spotify_tracks
WHERE mode NOT IN (0, 1);

-- Key: valores esperados entre 0 y 11.

SELECT *
FROM spotify_artist_streaming.spotify_tracks
WHERE `key` < 0
OR `key` > 11;

-- Duración: debe ser mayor que cero.

SELECT *
FROM spotify_artist_streaming.spotify_tracks
WHERE duration_ms <= 0;

-- Tempo: debe ser mayor que cero.

SELECT *
FROM spotify_artist_streaming.spotify_tracks
WHERE tempo <= 0;

-- Stream count: no debe contener valores negativos.

SELECT *
FROM spotify_artist_streaming.spotify_tracks
WHERE stream_count < 0;

-- Rango de años de lanzamiento.

SELECT
MIN(release_year) AS año_minimo,
MAX(release_year) AS año_maximo
FROM spotify_artist_streaming.spotify_tracks;

-- ============================================================
-- 8. ESTADÍSTICAS GENERALES DEL DATASET
-- ============================================================

-- Resumen general utilizado para conocer el tamaño del catálogo,
-- el alcance geográfico y las principales estadísticas de streaming
-- y popularidad.

SELECT
COUNT(*) AS total_canciones,
COUNT(DISTINCT artist_name) AS artistas_unicos,
COUNT(DISTINCT genre) AS generos_unicos,
COUNT(DISTINCT country) AS paises_unicos,
MIN(stream_count) AS streams_minimos,
MAX(stream_count) AS streams_maximos,
ROUND(AVG(stream_count), 0) AS promedio_streams,
MIN(popularity) AS popularidad_minima,
MAX(popularity) AS popularidad_maxima,
ROUND(AVG(popularity), 2) AS promedio_popularidad
FROM spotify_artist_streaming.spotify_tracks;

-- ============================================================
-- 9. VISTA: CANCIONES MÁS ESCUCHADAS
-- ============================================================

-- Permite identificar las 10 canciones con mayor cantidad
-- de reproducciones.

CREATE OR REPLACE VIEW vw_canciones_mas_escuchadas AS
SELECT
track_name,
artist_name,
genre,
country,
stream_count,
popularity,
danceability,
energy,
loudness,
instrumentalness,
tempo,
duration_minutes,
release_year
FROM spotify_artist_streaming.spotify_tracks
ORDER BY stream_count DESC
LIMIT 10;

-- ============================================================
-- 10. ANÁLISIS POR GÉNERO
-- ============================================================

-- Permite analizar:
-- - cantidad de canciones por género;
-- - streams totales;
-- - promedio de streams;
-- - máximo de streams alcanzado por una canción;
-- - popularidad promedio.

CREATE OR REPLACE VIEW vw_analisis_genero AS
SELECT
genre,
COUNT(*) AS cantidad_canciones,
SUM(stream_count) AS streams_totales,
ROUND(AVG(stream_count), 0) AS promedio_streams,
MAX(stream_count) AS maximo_streams,
ROUND(AVG(popularity), 2) AS promedio_popularidad
FROM spotify_artist_streaming.spotify_tracks
GROUP BY genre
ORDER BY streams_totales DESC;

-- ============================================================
-- 11. ANÁLISIS POR ARTISTA
-- ============================================================

-- Permite comparar la cantidad de canciones de cada artista
-- con sus streams totales, promedio de streams, popularidad
-- promedio y máximo de reproducciones alcanzado.

CREATE OR REPLACE VIEW vw_analisis_artistas AS
SELECT
artist_name,
COUNT(*) AS cantidad_canciones,
SUM(stream_count) AS streams_totales,
ROUND(AVG(stream_count), 0) AS promedio_streams,
ROUND(AVG(popularity), 2) AS promedio_popularidad,
MAX(stream_count) AS maximo_streams
FROM spotify_artist_streaming.spotify_tracks
GROUP BY artist_name
ORDER BY streams_totales DESC
LIMIT 10;

-- ============================================================
-- 12. EVOLUCIÓN ANUAL
-- ============================================================

-- Permite analizar la evolución de las reproducciones y
-- la popularidad según el año de lanzamiento.

CREATE OR REPLACE VIEW vw_analisis_anual AS
SELECT
release_year,
COUNT(*) AS cantidad_canciones,
SUM(stream_count) AS streams_totales,
ROUND(AVG(stream_count), 0) AS promedio_streams,
ROUND(AVG(popularity), 2) AS promedio_popularidad
FROM spotify_artist_streaming.spotify_tracks
GROUP BY release_year
ORDER BY release_year;

-- ============================================================
-- 13. ANÁLISIS MENSUAL
-- ============================================================

-- Permite analizar si existen diferencias en el rendimiento
-- de las canciones según el mes de lanzamiento.

CREATE OR REPLACE VIEW vw_analisis_mensual AS
SELECT
release_month,
COUNT(*) AS cantidad_canciones,
SUM(stream_count) AS streams_totales,
ROUND(AVG(stream_count), 0) AS promedio_streams,
ROUND(AVG(popularity), 2) AS promedio_popularidad
FROM spotify_artist_streaming.spotify_tracks
GROUP BY release_month
ORDER BY release_month;

-- ============================================================
-- 14. SEMANA VS. FIN DE SEMANA
-- ============================================================

-- Permite comparar las canciones lanzadas durante los días
-- de semana y durante el fin de semana.

CREATE OR REPLACE VIEW vw_analisis_fin_semana AS
SELECT
is_weekend_release,
COUNT(*) AS cantidad_canciones,
SUM(stream_count) AS streams_totales,
ROUND(AVG(stream_count), 0) AS promedio_streams,
ROUND(AVG(popularity), 2) AS promedio_popularidad
FROM spotify_artist_streaming.spotify_tracks
GROUP BY is_weekend_release;

-- ============================================================
-- 15. ANÁLISIS POR PAÍS
-- ============================================================

-- Permite analizar el volumen de canciones, streams totales,
-- promedio de streams y popularidad promedio de cada país.
-----------------------------------------------------------

-- Se mantiene la vista sin LIMIT para permitir el análisis
-- completo de los países del dataset.

CREATE OR REPLACE VIEW vw_analisis_pais AS
SELECT
country,
COUNT(*) AS cantidad_canciones,
SUM(stream_count) AS streams_totales,
ROUND(AVG(stream_count), 0) AS promedio_streams,
ROUND(AVG(popularity), 2) AS promedio_popularidad
FROM spotify_artist_streaming.spotify_tracks
GROUP BY country
ORDER BY streams_totales DESC;

-- ============================================================
-- 16. RELACIÓN ENTRE PAÍS Y GÉNERO
-- ============================================================

-- Permite analizar qué géneros predominan en cada país
-- y comparar cantidad de canciones, streams y popularidad.

CREATE OR REPLACE VIEW vw_genero_por_pais AS
SELECT
country,
genre,
COUNT(*) AS cantidad_canciones,
SUM(stream_count) AS streams_totales,
ROUND(AVG(popularity), 2) AS promedio_popularidad
FROM spotify_artist_streaming.spotify_tracks
GROUP BY country, genre
ORDER BY country, cantidad_canciones DESC;

-- ============================================================
-- 17. COMPARACIÓN: TOP 10% VS. RESTO DEL CATÁLOGO
-- ============================================================

-- Se compara el 10% de canciones con mayor cantidad de streams
-- frente al resto del catálogo.
--------------------------------

-- Además de streams y popularidad, se comparan características
-- musicales como danceability, energy, loudness, instrumentalness,
-- tempo, duración y upbeat_score.

SELECT
CASE
WHEN stream_count >= (
SELECT stream_count
FROM spotify_artist_streaming.spotify_tracks
ORDER BY stream_count DESC
LIMIT 1 OFFSET 200
)
THEN 'Top 10%'
ELSE 'Resto'
END AS grupo,

```
COUNT(*) AS cantidad_canciones,
ROUND(AVG(stream_count), 0) AS promedio_streams,
ROUND(AVG(popularity), 2) AS promedio_popularidad,
ROUND(AVG(danceability), 4) AS promedio_danceability,
ROUND(AVG(energy), 4) AS promedio_energy,
ROUND(AVG(loudness), 2) AS promedio_loudness,
ROUND(AVG(instrumentalness), 4) AS promedio_instrumentalness,
ROUND(AVG(tempo), 2) AS promedio_tempo,
ROUND(AVG(duration_minutes), 2) AS promedio_duracion,
ROUND(AVG(upbeat_score), 4) AS promedio_upbeat_score
```

FROM spotify_artist_streaming.spotify_tracks
GROUP BY grupo;

-- ============================================================
-- FIN DEL ANÁLISIS SQL
-- ============================================================
