-- 2024 Spotify Data Analysis Project

-- create table
-- -------------------
CREATE TABLE spotify 
(
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);


-- Exploratory Data Analysis

SELECT COUNT(*)
FROM spotify
;

SELECT COUNT(DISTINCT(artist))
FROM spotify
;

SELECT COUNT(DISTINCT(album))
FROM spotify
;

SELECT COUNT(DISTINCT(artist))
FROM spotify
;

SELECT DISTINCT(album_type)
FROM spotify
;

SELECT 
	MAX(duration_min),
	MIN(duration_min)
FROM spotify
;

SELECT *
FROM spotify
WHERE duration_min = 0
;

DELETE 
FROM spotify
WHERE duration_min = 0
;

SELECT DISTINCT(channel)
FROM spotify
;

SELECT DISTINCT(most_played_on)
FROM spotify
;


-- Data Analysis

-- 1. Retrieve the names of all tracks that have more than 1 billion streams.
SELECT track
FROM spotify
WHERE stream > 1000000000
;


-- 2. List all albums along with their respective artists.
SELECT artist,
DISTINCT(album)	  
FROM spotify
;


--3. Get the total number of comments for tracks where licensed = TRUE.
SELECT SUM(comments) AS total_comments
FROM spotify
WHERE licensed = 'true';


-- 4. Find all tracks that belong to the album type single.
SELECT track
FROM spotify
WHERE album_type = 'single';


-- 5. Count the total number of tracks by each artist.
SELECT artist,
	COUNT(track) AS total_track
FROM spotify
GROUP BY artist
ORDER BY total_track DESC
;


-- 6.Calculate the average danceability of tracks in each album.
SELECT album,
	ROUND(AVG(danceability)::numeric, 2) as avg_danceability
FROM spotify
GROUP BY album
ORDER BY avg_danceability DESC
;


-- 7.Find the top 5 tracks with the highest energy values.
SELECT track,
	MAX(energy) AS highest_energy
FROM spotify
GROUP BY track
ORDER BY highest_energy DESC
LIMIT 5;


-- 8.List all tracks along with their views and likes where official_video = TRUE.
SELECT track,
	SUM(views) AS total_views,
	SUM(likes) AS total_likes
FROM spotify
WHERE official_video = true
GROUP BY track
ORDER BY total_views DESC;


-- 9.For each album, calculate the total views of all associated tracks.
SELECT track,
	   album,
	   SUM(views) AS total_views
FROM spotify
GROUP BY track, album
ORDER BY total_views DESC;


-- 10.Retrieve the track names that have been streamed on Spotify more than YouTube.
WITH stream_on_youtube AS (
    SELECT track, SUM(stream) AS youtube_stream
    FROM spotify
    WHERE most_played_on = 'Youtube'
	GROUP BY track
),
	stream_on_spotify AS (
	SELECT track, SUM(stream) AS spotify_stream
	FROM spotify
	WHERE most_played_on = 'Spotify'
	GROUP BY track
)
SELECT yt.track,
	   sf.spotify_stream,
       yt.youtube_stream 
FROM stream_on_youtube AS yt
JOIN stream_on_spotify AS sf
    ON yt.track = sf.track
WHERE spotify_stream > youtube_stream
ORDER BY spotify_stream DESC;


-- 11.Find the top 3 most-viewed tracks for each artist using window functions.
SELECT track,
	   artist,
	   views,
	   rank
FROM (
	SELECT track,
		   artist,
		   views,
		   DENSE_RANK() OVER(PARTITION BY artist ORDER BY views DESC) AS rank
	FROM spotify
	WHERE views IS NOT NULL
) AS most_view_rank
WHERE rank <= 3;


-- 12.Write a query to find tracks where the liveness score is above the average.
SELECT track,
       artist,
       liveness,
	   ROUND((SELECT AVG(liveness) FROM spotify)::numeric,2) AS avg_liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);


-- 13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH energy_stats AS (
    SELECT album,
           MAX(energy) AS max_energy,
           MIN(energy) AS min_energy
    FROM spotify
    GROUP BY album
)
SELECT album,
       ROUND((max_energy - min_energy)::numeric,2) AS energy_diff
FROM energy_stats
ORDER BY energy_diff DESC;



    

