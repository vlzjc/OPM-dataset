CREATE TABLE opm_db.songlists AS
SELECT 
    track_id AS song_id, 
    track_name AS song_title, 
    track_album_artists_0_name AS artist_band, 
    CONCAT(FLOOR(track_duration_ms / 60000), ':', LPAD(FLOOR((track_duration_ms % 60000) / 1000), 2, '0')) AS duration,
    -- This convert milliseconds to minute seconds format  MM:SS 
    track_external_urls_spotify AS spotify_url, 
    track_uri AS spotify_uri
FROM opm_db.raw_data;


SELECT * FROM songlists LIMIT 10;
SELECT count(*) from songlists where not duration = "0:00";

SET SQL_SAFE_UPDATES = 1; -- change to 0 to disable safe mode
DELETE FROM songlists WHERE duration = "0:00";

SELECT * FROM songlists;
