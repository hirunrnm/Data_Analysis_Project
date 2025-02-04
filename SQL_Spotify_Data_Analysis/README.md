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
![Screen Shot 2025-02-04 at 10 03 39 PM](https://github.com/user-attachments/assets/52400807-c623-4e58-8d48-23213bd2d9e9)


2. List all albums along with their respective artists.
```sql
SELECT DISTINCT(artist), album
FROM spotify
;
```
![Screen Shot 2025-02-04 at 10 07 37 PM](https://github.com/user-attachments/assets/4356db0d-b70e-4c1c-a233-3f64b15dfe57)


3. Get the total number of comments for tracks where `licensed = TRUE`.
```sql
SELECT SUM(comments) AS total_comments
FROM spotify
WHERE licensed = 'true';
```
![Screen Shot 2025-02-04 at 10 08 17 PM](https://github.com/user-attachments/assets/c2d460c5-1b1e-4309-81a5-254889a522e8)


4. Find all tracks that belong to the album type `single`.
```sql
SELECT DISTINCT(track)
FROM spotify
WHERE album_type = 'single';
```
![Screen Shot 2025-02-04 at 10 09 58 PM](https://github.com/user-attachments/assets/ee5f1a30-2f68-4125-a31f-ddbe1424a061)


5. Count the total number of tracks by each artist.
```sql
SELECT artist,
	COUNT(track) AS total_track
FROM spotify
GROUP BY artist
ORDER BY total_track DESC
;
```
![Screen Shot 2025-02-04 at 10 10 44 PM](https://github.com/user-attachments/assets/98d81923-5be8-43df-8a6f-6b3f23e29a51)


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
![Screen Shot 2025-02-04 at 10 11 22 PM](https://github.com/user-attachments/assets/75a6ce9b-af2a-4cdf-a85b-6a212e7f9fc3)


2. Find the top 5 tracks with the highest energy values.
```sql
SELECT track,
	MAX(energy) AS highest_energy
FROM spotify
GROUP BY track
ORDER BY highest_energy DESC
LIMIT 5;
```
![Screen Shot 2025-02-04 at 10 12 00 PM](https://github.com/user-attachments/assets/022b02cd-fd2a-4c8b-bd2c-a6aeca5f4575)


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
![Screen Shot 2025-02-04 at 10 12 40 PM](https://github.com/user-attachments/assets/4b8e52bf-0ae7-41df-b2b5-3a0c5e89be83)


4. For each album, calculate the total views of all associated tracks.
```sql
SELECT track,
	   album,
	   SUM(views) AS total_views
FROM spotify
GROUP BY track, album
ORDER BY total_views DESC;
```
![Screen Shot 2025-02-04 at 10 13 12 PM](https://github.com/user-attachments/assets/37741924-edb4-4fcf-bbf8-68b34932d031)


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
![Screen Shot 2025-02-04 at 10 13 50 PM](https://github.com/user-attachments/assets/ff079fca-f654-4972-8ad5-fc4c27ee846a)


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
![Screen Shot 2025-02-04 at 10 14 22 PM](https://github.com/user-attachments/assets/8adb147e-42b3-4f6a-a28e-a2fe13aa49e3)


2. Write a query to find tracks where the liveness score is above the average.
```sql
SELECT track,
       artist,
       liveness,
	   ROUND((SELECT AVG(liveness) FROM spotify)::numeric,2) AS avg_liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);
```
![Screen Shot 2025-02-04 at 10 15 26 PM](https://github.com/user-attachments/assets/1f83c37b-f955-483b-9489-5ce657d46ed3)


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
![Screen Shot 2025-02-04 at 10 16 00 PM](https://github.com/user-attachments/assets/20fd73fe-67ef-4b02-aec4-152354240425)


## Technology Stack
- **Database**: PostgreSQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- **Tools**: pgAdmin 4, PostgreSQL

---


