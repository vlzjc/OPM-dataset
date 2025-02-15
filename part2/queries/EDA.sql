USE opm_db;

DESCRIBE raw_data;

SELECT * FROM raw_data LIMIT 10;

SELECT count(id) FROM opm_db.raw_data;
-- counts how many songs in the table which is 3746

SELECT COUNT(DISTINCT track_name) FROM opm_db.raw_data;
-- counts distinct songs in the table which are 2249


SELECT track_id, track_name, track_external_urls_spotify, track_uri
FROM opm_db.raw_data
WHERE track_name = "0";
-- when I was uploading the output.csv I came accross an error which didn't like nulls or NAN so I bypassed it by replacing it all with "0"
-- assuming track_id track_name, track_uri is 0  then it is safe to drop the rows containing these 0

SELECT track_name, COUNT(*) FROM opm_db.raw_data GROUP BY track_name HAVING COUNT(*) > 1;
-- check all the duplicates in the songs

SELECT track_artists_0_name, COUNT(*) FROM opm_db.raw_data HAVING COUNT(*) > 1;
-- check all the duplicates of artists

WITH DUPES AS(
SELECT track_name, COUNT(*) AS SongCount
FROM opm_db.raw_data
GROUP BY track_name
HAVING COUNT(*) > 1
)
SELECT opm.track_name, opm.track_artists_0_name, ds.SongCount
FROM opm_db.raw_data opm
INNER JOIN DUPES ds ON opm.track_name = ds.track_name;
-- gets a list of duplicated songs and artists 


SELECT *
FROM opm_db.raw_data
WHERE track_external_urls_spotify = "spotify:artist:0rZRTXEmmPmx6gt92tBqIc";

SELECT track_name, track_artists_0_name, track_external_urls_spotify, track_uri
FROM opm_db.raw_data
WHERE track_external_urls_spotify = "spotify:artist:0rZRTXEmmPmx6gt92tBqIc";
/*
okay so here is something went wrong with the load part
track_external_urls_spotify is supposed to be an URL for the song 
but I noticed this spotify:artist:0rZRTXEmmPmx6gt92tBqIc which is an URI 
*/ 

CALL Search_All_Columns('raw_data', '0rZRTXEmmPmx6gt92tBqIc');
-- this is a stored procedure where you loosely searches the entire table


/*
after Exploring the data, I have found out some values on the table are incorrect
but most of the incorrect rows are still savagable so what I am going to do is make the 
songlists table
consisting of song_id song_title, artists_band,  duration, spotify url, spotify uri, genre
which are
track_id = song id
track_name = song title
track_album_artists_0_name = artists/band
track_duration_ms = duration
track_external_urls_spotify = spotify url
track_uri = spotify uri
and genre will be appended later on... maybe querying 3k+ songs is challenging and time consuming

Album table
track_album_id = album_id
track_album_name = album_name
track_album_artists_0_name = artists/band
track_album_images_1_url
track_album_images_2_url
*/






