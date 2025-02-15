SET SQL_SAFE_UPDATES = 1; -- change to 0 to disable safe mode

CREATE TABLE album_table (
    album_id VARCHAR(255),
    album_name VARCHAR(255),
    artist_band VARCHAR(255),
    album_image_1_url TEXT,
    album_image_2_url TEXT
);

INSERT INTO album_table (album_id, album_name, artist_band, album_image_1_url, album_image_2_url)
SELECT DISTINCT 
    track_album_id AS album_id, 
    track_album_name AS album_name, 
    track_album_artists_0_name AS artist_band, 
    track_album_images_1_url AS album_image_1_url, 
    track_album_images_2_url AS album_image_2_url
FROM raw_data;

UPDATE album_table a
JOIN raw_data r ON a.album_id = r.track_album_id
SET a.artists_band_id = r.track_album_artists_0_name;

UPDATE album_table a
JOIN raw_data r ON a.album_id = r.track_album_id
SET a.artist_band = r.track_artists_0_id;

ALTER TABLE album_table 
CHANGE COLUMN artist_band artist_band_id VARCHAR(255)
;


SELECT * FROM album_table LIMIT 5;

SELECT album_id, COUNT(*) AS count
FROM album_table
GROUP BY album_id
HAVING COUNT(*) > 1;


SELECT count(*) FROM album_table;
-- 2159

SELECT COUNT(DISTINCT album_name) AS unique_album_count
FROM album_table;
-- 1900

SELECT album_name, COUNT(*) AS count
FROM album_table
GROUP BY album_name
HAVING COUNT(*) > 1;
-- check dupes in album_name

SELECT album_id, album_name, artist_band_name, COUNT(*) AS duplicate_count
FROM album_table
GROUP BY album_id, album_name, artist_band_name
HAVING COUNT(*) > 1;


SELECT album_name, album_id, COUNT(*) AS count
FROM album_table
GROUP BY album_name
HAVING COUNT(*) > 1;

SELECT t1.album_id, t2.album_id FROM album_table t1
INNER JOIN album_table t2 
ON t1.album_id = t2.album_id AND t1.album_name = t2.album_name
WHERE t1.album_id > t2.album_id;

DELETE t1 FROM album_table t1
JOIN album_table t2 
ON t1.album_id = t2.album_id AND t1.album_name = t2.album_name
WHERE t1.album_id > t2.album_id;

ALTER TABLE album_table 
ADD CONSTRAINT fk_artist_band 
FOREIGN KEY (artist_band_id) 
REFERENCES artist_band_table(id) 
ON DELETE CASCADE ON UPDATE CASCADE;

SELECT * FROM album_table;
