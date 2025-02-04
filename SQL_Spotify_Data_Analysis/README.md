# Spotify Advanced SQL Project
Project Category: Advanced
[Click Here to get Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

![spotify-podcast-1](https://github.com/user-attachments/assets/8e9e47c0-d0dd-494d-8f08-d4a35dda185d)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
-- create table
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
```
## Project Steps

### 1. Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

### 4. Querying the Data
After the data is inserted, various SQL queries can be written to explore and analyze the data. Queries are categorized into **easy**, **medium**, and **advanced** levels to help progressively develop SQL proficiency.

#### Easy Queries
- Simple data retrieval, filtering, and basic aggregations.
  
#### Medium Queries
- More complex queries involving grouping, aggregation functions, and joins.
  
#### Advanced Queries
- Nested subqueries, window functions, CTEs, and performance optimization.
  
---

## 13 Practice Questions

### Easy Level
1. Retrieve the names of all tracks that have more than 1 billion streams.
```sql
SELECT track
FROM spotify
WHERE stream > 1000000000
;
```
![Screen Shot 2025-02-04 at 10 00 38 PM](https://github.com/user-attachments/assets/6e1d4f29-5691-4e4b-b396-31415deaf7c2)

2. List all albums along with their respective artists.
```sql
SELECT artist,
DISTINCT(album)	  
FROM spotify
;
```

3. Get the total number of comments for tracks where `licensed = TRUE`.
```sql
SELECT SUM(comments) AS total_comments
FROM spotify
WHERE licensed = 'true';
```

4. Find all tracks that belong to the album type `single`.
```sql
SELECT track
FROM spotify
WHERE album_type = 'single';
```

5. Count the total number of tracks by each artist.
```sql
SELECT artist,
	COUNT(track) AS total_track
FROM spotify
GROUP BY artist
ORDER BY total_track DESC
;
```

### Medium Level
1. Calculate the average danceability of tracks in each album.
```sql
SELECT album,
	ROUND(AVG(danceability)::numeric, 2) as avg_danceability
FROM spotify
GROUP BY album
ORDER BY avg_danceability DESC
;
```

2. Find the top 5 tracks with the highest energy values.
```sql
SELECT track,
	MAX(energy) AS highest_energy
FROM spotify
GROUP BY track
ORDER BY highest_energy DESC
LIMIT 5;
```

3. List all tracks along with their views and likes where `official_video = TRUE`.
```sql
SELECT track,
	SUM(views) AS total_views,
	SUM(likes) AS total_likes
FROM spotify
WHERE official_video = true
GROUP BY track
ORDER BY total_views DESC;
```

4. For each album, calculate the total views of all associated tracks.
```sql
SELECT track,
	   album,
	   SUM(views) AS total_views
FROM spotify
GROUP BY track, album
ORDER BY total_views DESC;
```

5. Retrieve the track names that have been streamed on Spotify more than YouTube.
```sql
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
```

### Advanced Level
1. Find the top 3 most-viewed tracks for each artist using window functions.
```sql
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
```

2. Write a query to find tracks where the liveness score is above the average.
```sql
SELECT track,
       artist,
       liveness,
	   ROUND((SELECT AVG(liveness) FROM spotify)::numeric,2) AS avg_liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);
```

3. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
```sql
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
```

## Technology Stack
- **Database**: PostgreSQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- **Tools**: pgAdmin 4, PostgreSQL

---


