-- Netflix project

DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix
( 
	show_id	VARCHAR(6),
    type VARCHAR(10),
    title VARCHAR(150),
    director VARCHAR(208),
    casts VARCHAR(1000),
	country VARCHAR(150),
    date_added VARCHAR(150),
    release_year INT,
    rating VARCHAR(10),
	duration VARCHAR(15),
    listed_in VARCHAR(100),
    description VARCHAR(250)
);

SELECT * FROM netflix;

SELECT COUNT(*) as total_content
FROM netflix;

SELECT DISTINCT type
FROM netflix;

--count the number of movies vs TV shows
SELECT
type,
COUNT(*) AS total_content
from netflix
GROUP BY type

--Find the most common rating for movies and TV shows

SELECT 
 type,
 rating
 
FROM

(SELECT 
 type,
 rating,
 count(*),
 Rank() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS ranking
FROM netflix
GROUP BY 1, 2) AS t1
WHERE 
  ranking = 1
  
-- List all movies released in a specific year

SELECT * FROM netflix WHERE release_year = 2020;
 
-- Find the top 5 countries with the most content on Netflix

SELECT 
country,
Count(show_id) as total_content
FROM netflix
GROUP BY 1

SELECT 
  UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
  COUNT(show_id) as total_content
  FROM netflix
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 5
  
 -- IDENTIFY THE LONGEST MOVIE
 
 SELECT * FROM netflix
 WHERE 
     type = 'Movie'
	 AND
	 duration = (SELECT MAX(duration) FROM netflix)

-- FIND CONTENT ADDED IN THE LAST 5 YEARS

SELECT *
FROM netflix
WHERE 
TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS'

	
SELECT CURRENT_DATE - INTERVAL '5 years'

-- FIND ALL THE MOVIES/TV SHOWS BY DIRECTOR 'Rajiv Chilaka'

SELECT * FROM netflix WHERE director = 'Rajiv Chilaka';

--LIST ALL TV SHOWS WITH MORE THAN 5 SEASONS

SELECT
 *
 FROM netflix
 WHERE 
     type = 'TV Show'
	 AND
	 SPLIT_PART(duration, ' ', 1) ::numeric > 5 

--COUNT THE NUMBER OF CONTENT ITEMS IN EACH GENRE

SELECT
  UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
  COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1

--FIND EACH YEAR AND THE AVERAGE NUMBERS OF CONTENT RELEASE BY INDIA ON NETFLIX, RETURN TOP 5 YEAR WITH HIGHEST AVERAGE CONTENT RELEASE.

SELECT 
EXTRACT(YEAR FROM TO_DATE(date_added, ' Month DD, YYYY')) as year,
COUNT(*) as yearly_content,
ROUND(
COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100, 2) as avg_content
FROM netflix
where country = 'India'
GROUP BY 1


--LIST ALL THE MOVIES THAT ARE DOCUMENTARIES

SELECT * FROM netflix
where listed_in ILIKE '%documentaries'

--FIND ALL CONTENT WITHOUT A DIRECTOR

SELECT
director,
COUNT(*) as NO_director
FROM netflix 
where director IS NULL
GROUP BY 1

--FIND HOW MANY MOVIES ACTOR 'Salman Khan' appeared in last 10 years!

SELECT * FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND
release_year >  EXTRACT(YEAR FROM CURRENT_DATE) - 10

--FIND THE TOP 10 ACTORS WHO HAVE APPEARED IN THE HIGHEST NUMBER OF MOVIES PRODUCED IN INDIA.

 SELECT 
 UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
 COUNT(*) as total_content
 FROM netflix
 GROUP BY 1
 ORDER BY 2
 LIMIT 10
 
 --CATEGORIZE THE CONTENT BASED ON THE PRESENCE OF THE KEYWORDS 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
 WITH new_table
 AS
 (
 SELECT *, 
 CASE
 WHEN 
  description ILIKE '%KILL%' OR 
  description ILIKE '%VIOLENCE' THEN 'Bad_content'
  ELSE 'Good_content'
 END category
FROM netflix
	 )
	 
SELECT category, COUNT(*) AS total_content
FROM new_table
GROUP BY 1
 





