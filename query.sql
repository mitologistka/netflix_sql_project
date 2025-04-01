-- Delete the table if it exists.
DROP TABLE if EXISTS NETFLIX;

CREATE TABLE netflix (
    show_id VARCHAR(6),
    type    VARCHAR(10),	
    title	VARCHAR(150),
    director VARCHAR(210),
    casts	VARCHAR(1000),
    country	VARCHAR(150),
    date_added VARCHAR(50),
    release_year	INT,
    rating	VARCHAR(10),
    duration	VARCHAR(15),
    listed_in	VARCHAR(100),
    description VARCHAR(250)
);

SELECT * FROM NETFLIX;

-- Checking if the table has the same number of rows.
SELECT COUNT(*) AS total_content
FROM NETFLIX;

-- View unique values in a column.
SELECT 
	DISTINCT type
FROM netflix;

-- 15 Business Problems
-- 1. Count the number of movies vs TV shows
SELECT 
	type, 
	COUNT(*) AS total_content
FROM netflix
GROUP BY type;

-- 2. Find the Most Common Rating for Movies and TV Shows
SELECT	
	type,
	rating
FROM 
(
		SELECT 
			type,
			rating, 
			count(*),
			RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS ranking
		FROM netflix
		GROUP BY 1, 2
) as t1
WHERE 
	ranking = 1;

-- 3. List All Movies Released in a Specific Year (e.g., 2020)
SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020;

-- 4. Find the Top 5 Countries with the Most Content on Netflix

SELECT 
    TRIM(unnest(STRING_TO_ARRAY(country, ','))) AS new_country,
    count(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 5. Identify the Longest Movie

select title,  
	substring(duration, 1,position ('m' in duration)-1)::int duration
from Netflix
where type = 'Movie' and duration is not null
order by 2 desc
limit 1;

-- 6. Find Content Added in the Last 5 Years
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';

-- List All TV Shows with More Than 5 Seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;

 -- 9. Count the Number of Content Items in Each Genre
 SELECT 
	TRIM(unnest(STRING_TO_ARRAY(listed_in, ','))) AS new_list,
	count(show_id) as eq
 FROM netflix
GROUP BY 1
ORDER BY 2 DESC;

-- 10.Find each year and the average numbers of content release in Poland on netflix
SELECT 
	EXTRACT(YEAR FROM  TO_DATE(date_added, 'Month DD, YYYY')) AS year,
	COUNT(*) as yearly_content,
	ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM NETFLIX WHERE country = 'Poland') * 100 
	,2) as avg_content_per_year
FROM netflix
WHERE country = 'Poland'
GROUP BY 1;

-- 11. List All Movies that are Documentaries
SELECT * from netflix;
SELECT 
	title
FROM netflix
WHERE 
	listed_in ILIKE '%documentaries%';

-- 12. Find All Content Without a Director
SELECT * 
FROM NETFLIX
WHERE director IS null;

-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT * 
FROM NETFLIX
WHERE 
	casts ILIKE '%Salman Khan%'
	AND
	release_year > extract(YEAR from current_date) - 10;

-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT 
	TRIM(unnest(STRING_TO_ARRAY(casts, ','))) AS new_casts,
	COUNT(*)
FROM NETFLIX
WHERE country = 'Poland'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

/*
 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords 
in the description field. Label content containing these keywords as "bad" and 
all other content as 'good'. Count how may content fall intro each category.
*/
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;



	


