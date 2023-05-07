USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(*) AS total_rows_dirmap FROM director_mapping;
 -- total_rows_dirmap = 3867

SELECT COUNT(*) AS total_rows_genre FROM genre;
 -- total_rows_genre = 14662

SELECT COUNT(*) AS total_rows_movie FROM movie;
 -- total_rows_movie = 7997

SELECT COUNT(*) AS total_rows_names FROM names;
 -- total_rows_names = 25735
 
SELECT COUNT(*) AS total_rows_ratings FROM ratings;
 -- total_rows_ratings = 7997

SELECT COUNT(*) AS total_rows_rolmap FROM role_mapping;
 -- total_rows_rolmap = 15615
 

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT COUNT(*)-COUNT(id) AS id_nulls, 
       COUNT(*)-COUNT(title) AS title_nulls, 
       COUNT(*)-COUNT(year) AS year_nulls,
       COUNT(*)-COUNT(date_published) AS date_published_null,
       COUNT(*)-COUNT(duration) AS duration_nulls, 
       COUNT(*)-COUNT(country) AS country_nulls, 
       COUNT(*)-COUNT(worlwide_gross_income) AS worlwide_gross_income_nulls,
       COUNT(*)-COUNT(languages) AS languages_null,
       COUNT(*)-COUNT(production_company) AS production_company_nulls
FROM movie;

   /* It can be observed that not all the columns in MOVIE table has NULL values. Only Country, Worlwide_gross_income, Languages and 
   Production_company columns has 20, 3724, 194, 528 Null values respectively. */



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+

Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT Year, count(ID) 	number_of_movies
FROM movie
GROUP BY year
ORDER BY year;

SELECT MONTH(date_published) month_num ,count(ID) number_of_movies
FROM movie
GROUP BY MONTH(date_published)
ORDER BY MONTH(date_published);

       /* It can be concluded from above that in 2017 highest number of movies were produced than 2018 & 2019. Also on the basis of 
        monthwise data it can be observed that highest number of movies are produced in the month of March. */


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT
	COUNT(id) AS total_movies,
	Year
FROM 
	movie 
WHERE 
	(country LIKE '%USA%' OR country LIKE '%India%') AND 
    year = 2019;
    
    -- Total movies produced in India and USA in the year 2019 are 1059.

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM genre;



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,COUNT(ID) number_of_movies
FROM genre GR
INNER JOIN movie MV ON GR.movie_id = MV.id
GROUP BY genre
ORDER BY number_of_movies DESC
LIMIT 1;



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH ct_genre AS
(
	SELECT movie_id, 
			COUNT(genre) AS number_of_movies
	FROM genre
	GROUP BY movie_id
	HAVING number_of_movies = 1
)
SELECT COUNT(movie_id) AS number_of_movies
FROM ct_genre;

	-- 3289 movies have exactly one genre from the data set.
    
    
/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre, ROUND(AVG(duration),2) avg_duration
FROM genre GR
INNER JOIN movie MV ON GR.movie_id = MV.id
GROUP BY genre
ORDER BY avg_duration DESC;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH CTE_genre AS (
SELECT genre,COUNT(ID) movie_count,RANK() OVER(ORDER BY COUNT(movie_id) DESC) genre_rank
FROM genre GR
INNER JOIN movie MV ON GR.movie_id = MV.id
GROUP BY genre
)

SELECT genre,movie_count,genre_rank
FROM CTE_genre
WHERE genre = 'thriller';


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT
	ROUND(MIN(avg_rating),0) AS min_avg_rating,
    ROUND(MAX(avg_rating),0) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM ratings;   

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH Top_movies_CTE AS
(
SELECT
	M.title,
    R.avg_rating,
    DENSE_RANK() OVER(ORDER BY R.avg_rating DESC) AS movie_rank
FROM 
	movie M
INNER JOIN
	ratings R
ON M.id = R.movie_id
)
SELECT * FROM top_movies_CTE WHERE movie_rank <= 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,COUNT(movie_id) movie_count
FROM ratings RT 
GROUP BY median_rating
ORDER BY median_rating;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	production_company,
	COUNT(ID) movie_count,
    DENSE_RANK()OVER(ORDER BY COUNT(ID) DESC) prod_company_rank
FROM movie MV
INNER JOIN ratings RT ON RT.movie_id = MV.ID
WHERE avg_rating > 8 AND MV.Production_Company IS NOT NULL
GROUP BY production_company;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	G.genre,
    COUNT(M.id) AS movie_count
FROM 
	movie M
INNER JOIN
	Genre G
ON M.id = G.movie_id
INNER JOIN
	ratings R
ON G.movie_id = R.movie_id
WHERE 
	M.year = 2017 and 
    MONTH(M.date_published) = '03' and 
    M.country = 'USA' and 
    R.total_votes > 1000
GROUP BY G.genre
ORDER BY movie_count DESC;


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title, avg_rating, genre
FROM movie MV 
INNER JOIN genre GR ON GR.movie_id = MV.ID
INNER JOIN ratings RT ON RT.movie_id = MV.ID

WHERE avg_rating > 8
  AND title LIKE 'The%'
ORDER BY avg_rating DESC;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
	median_rating, 
    COUNT(movie_id) AS movie_count
FROM movie MV
INNER JOIN ratings RT ON RT.movie_id = MV.ID
WHERE date_published BETWEEN '2018-04-01' AND '2019-04-01'
  AND median_rating = 8
GROUP BY median_rating;
  

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT country, SUM(total_votes) total_votes
FROM movie MV
INNER JOIN ratings RT ON RT.movie_id = MV.ID
WHERE country IN('germany' ,'italy')
GROUP BY country
ORDER BY total_votes DESC;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
	SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) ID_Count,
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) name_Count,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) height_Count,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) date_of_birth_Count,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) known_for_movies_Count
FROM names;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_genres_CTE AS(
	SELECT genre,COUNT(GR.movie_id) count_genre
    FROM genre GR
    INNER JOIN ratings RT ON RT.movie_id = GR.movie_id
    WHERE avg_rating > 8
    GROUP BY genre
    ORDER BY COUNT(GR.movie_id) DESC
    LIMIT 3
),
director_CTE AS(
	SELECT name,COUNT(MV.id) movie_count,RANK() OVER(ORDER BY COUNT(MV.id) DESC) AS director_rank
    FROM names NM
    INNER JOIN director_mapping DM ON DM.name_id = NM.id
    INNER JOIN movie MV ON MV.ID = DM.movie_id
    INNER JOIN genre GR ON GR.movie_id = MV.ID
    INNER JOIN ratings RT ON RT.movie_id = GR.movie_id,top_genres_CTE
    WHERE avg_rating > 8  AND GR.genre IN (top_genres_CTE.genre)
    GROUP BY name
)
SELECT name director_name,movie_count
FROM director_CTE
WHERE director_rank <= 3;

	-- The top directors are James Mangold, Anthony Russo, Joe Russo and Soubin Shahir.
    

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
	N.name,
    COUNT(R.movie_id) AS movie_count
FROM 
	ratings R
		INNER JOIN 
    role_mapping RM USING (movie_id)
		INNER JOIN 
	names N ON RM.name_id = N.id
WHERE R.median_rating >= 8 AND RM.category = 'actor'
GROUP BY N.name
ORDER BY movie_count DESC
LIMIT 2;

-- Top 2 actors with Median Rating of atleast are Mammootty and Mohanlal.


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	production_company,
    SUM(total_votes) vote_count,
    RANK()OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie MV
INNER JOIN ratings RT ON RT.movie_id = MV.ID
GROUP BY production_company
LIMIT 3;

	-- Top 3 Production houses are Marvel Studios, 20th Century Fox and Warner Bros.
    
    
/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT     n.name   AS actor_name,
           ROUND(AVG(r.total_votes)) AS total_votes,
           COUNT(m.id) AS movie_counts,
           ROUND((SUM(r.total_votes*r.avg_rating)/SUM(r.total_votes)),2)      AS actor_avg_rating,
           RANK() OVER(ORDER BY ROUND((SUM(r.total_votes*r.avg_rating)/SUM(r.total_votes)),2) DESC, 
						ROUND(AVG(r.total_votes)) DESC) AS actor_rank
FROM       movie m
INNER JOIN ratings r ON         m.id=r.movie_id
INNER JOIN role_mapping rm ON         m.id=rm.movie_id
INNER JOIN names n ON         n.id=rm.name_id
WHERE      country='India'
AND        category='actor'
GROUP BY   actor_name
HAVING     COUNT(m.id)>=5
LIMIT      5;

	-- Top actor is Vijay Sethupati followed by Fahadh Faasil and Yogi Babu.
    
 -- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT     n.name   AS actress_name,
           Round(AVG(r.total_votes))    AS total_votes,
           Count(m.id)   AS movie_counts,
           ROUND(Sum(r.total_votes *r.avg_rating)/Sum(r.total_votes),2) AS actress_avg_rating,
           RANK() OVER(ORDER BY sum(r.total_votes*r.avg_rating)/sum(r.total_votes) DESC, round(AVG(r.total_votes)) DESC) AS actress_rank
FROM       movie m
INNER JOIN ratings r 		ON         m.id=r.movie_id
INNER JOIN role_mapping rm  ON         m.id=rm.movie_id
INNER JOIN names n 			ON         n.id=rm.name_id
WHERE      country='India' AND languages='Hindi'AND category='actress'
GROUP BY   actress_name
HAVING     count(m.id)>=3
LIMIT      5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT m.title,
       r.avg_rating,
       CASE
         WHEN r.avg_rating > 8 THEN 'Superhit Movie'
         WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit Movie'
         WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch Movie'
         ELSE 'Flop Movie'
       END AS category
FROM   movie m
INNER JOIN ratings r ON m.id = r.movie_id
INNER JOIN genre g ON m.id = g.movie_id
WHERE  g.genre = 'Thriller'; 


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_avg_duration
AS
  (SELECT   genre,
			(AVG(duration)) AS avg_duration
             FROM       movie m
             INNER JOIN genre g
             ON         m.id=g.movie_id
             GROUP BY   genre)
  SELECT   genre, ROUND(avg_duration),
           ROUND(SUM(avg_duration) OVER w,1)  AS running_total_duration,
           ROUND(AVG(avg_duration) OVER w,2)  AS moving_avg_duration
  FROM     genre_avg_duration 
  WINDOW w AS (ORDER BY genre ROWS UNBOUNDED PRECEDING) ;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top3_genre_CTE AS
( 	
	SELECT genre, COUNT(movie_id) AS number_of_movies
    FROM genre AS g
    INNER JOIN movie AS m
    ON g.movie_id = m.id
    GROUP BY genre
    ORDER BY COUNT(movie_id) DESC
    LIMIT 3
),
top5_movies AS
(SELECT genre,
			year,
			title AS movie_name,
            CASE
				WHEN LEFT(worlwide_gross_income,3) = 'INR' THEN CONCAT('$ ',ROUND(CONVERT(SUBSTR(worlwide_gross_income, 4, LENGTH(worlwide_gross_income)),float)/69.98))  -- Assuming 1 USD = 69.98 INR
				ELSE worlwide_gross_income                 
			END AS worlwide_gross_income,
            
			ROW_NUMBER() OVER(PARTITION BY year ORDER BY CASE
				WHEN LEFT(worlwide_gross_income,3) = 'INR' THEN ROUND(CONVERT(SUBSTR(worlwide_gross_income, 4, LENGTH(worlwide_gross_income)),float)/69.98)  
				ELSE ROUND(CONVERT(SUBSTR(worlwide_gross_income, 3, LENGTH(worlwide_gross_income)),float))                 
			END DESC) AS movie_rank
	FROM movie AS m 
    INNER JOIN genre AS g 
    ON m.id= g.movie_id
	WHERE genre IN (SELECT genre FROM top3_genre_CTE)
)
SELECT *
FROM top5_movies
WHERE movie_rank<=5;

	-- Since the data was having currency in INR & USD values, to analyse the data efficeintly we have convrted into single currency from INR into USD.


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	production_company,
	COUNT(id) AS movie_count,
    ROW_NUMBER() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
WHERE median_rating >= 8
AND POSITION(',' IN languages) > 0 
AND production_company IS NOT NULL
GROUP BY production_company
LIMIT 2;

	-- Top 2 production houses with most superhits in multilingual movies are "Star Cinema" and "Twentieth Century Fox".
    
    
-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top3_actress_CTE AS
(SELECT 
	N.name AS actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(M.id) AS movie_count,
    AVG(R.avg_rating) AS actress_avg_rating,
    ROW_NUMBER() OVER(ORDER BY AVG(R.avg_rating) DESC, SUM(total_votes) DESC ) AS actress_rank
FROM
	names N
INNER JOIN role_mapping RM
ON N.id = RM.name_id
INNER JOIN	ratings R
ON RM.movie_id = R.movie_id
INNER JOIN movie M
ON R.movie_id = M.id
INNER JOIN genre G
ON M.id = G.movie_id
WHERE R.avg_rating > 8 AND G.genre = 'Drama' AND RM.category = 'actress'
GROUP BY N.name
)
SELECT * FROM top3_actress_CTE WHERE actress_rank <=3 ;


	-- Top 3 actresses of Drama genre are Sangeetha Bhat, Fatmire Sahiti and Adriana Matoshi respectively.

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH ctf_date_summary AS
(
	SELECT d.name_id,
		   NAME,
		   d.movie_id,
		   duration,
		   r.avg_rating,
		   total_votes,
		   m.date_published,
		   LEAD(date_published,1) OVER(PARTITION BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
	FROM director_mapping AS d
	INNER JOIN names AS n ON n.id = d.name_id
	INNER JOIN movie AS m ON m.id = d.movie_id
	INNER JOIN ratings AS r ON r.movie_id = m.id 
),
top_director_summary AS
(
	SELECT *, DATEDIFF(next_date_published, date_published) AS date_difference
	FROM ctf_date_summary
)
SELECT 	name_id AS director_id,
		NAME AS director_name,
		COUNT(movie_id) AS number_of_movies,
		ROUND(AVG(date_difference),2) AS avg_inter_movie_days,
		ROUND(AVG(avg_rating),2) AS avg_rating,
		SUM(total_votes) AS total_votes,
		MIN(avg_rating) AS min_rating,
		MAX(avg_rating) AS max_rating,
		SUM(duration) AS total_duration
FROM top_director_summary
GROUP BY director_id
ORDER BY COUNT(movie_id) DESC
LIMIT 9;

	-- Andrew Jones is the top director so RSVP movies should prefer him for their next project.


