/* 1962 movies
1.
List the films where the yr is 1962 [Show id, title] */

SELECT id, title
FROM movie
WHERE yr=1962

/*  When was Citizen Kane released?
2.
Give year of 'Citizen Kane'. */

SELECT yr
FROM movie
WHERE title = "Citizen Kane"

/* Star Trek movies
3.
List all of the Star Trek movies, include the id, title and yr (all of 
these movies include the words Star Trek in the title). 
Order results by year. */

SELECT id, title, yr
FROM movie
WHERE title LIKE "Star Trek%"
ORDER BY yr

/* id for actor Glenn Close
4.
What id number does the actor 'Glenn Close' have? */

SELECT id
FROM actor
WHERE name = 'Glenn Close'

/* id for Casablanca
5.
What is the id of the film 'Casablanca' */

SELECT id
FROM movie
WHERE title = 'Casablanca'

/* Cast list for Casablanca
6.
Obtain the cast list for 'Casablanca'.

what is a cast list?
Use movieid=11768, (or whatever value you got from the previous question) */

SELECT name
FROM casting
    JOIN actor ON id = actorid
WHERE movieid = 11768

/* Alien cast list
7.
Obtain the cast list for the film 'Alien' */

SELECT name
FROM casting
    JOIN actor ON id = actorid
WHERE movieid IN (SELECT movie.id
FROM movie
WHERE title = 'Alien')

/* Harrison Ford movies
8.
List the films in which 'Harrison Ford' has appeared */

SELECT title
FROM movie
WHERE id IN (SELECT movieid
FROM casting
    JOIN actor ON id = actorid
WHERE name = 'Harrison Ford')

/* Harrison Ford as a supporting actor
9.
List the films where 'Harrison Ford' has appeared - but not in the starring role.
[Note: the ord field of casting gives the position of the actor. 
If ord=1 then this actor is in the starring role] */

SELECT title
FROM movie
WHERE id IN (SELECT movieid
FROM casting
    JOIN actor ON id = actorid
WHERE name = 'Harrison Ford'
    AND casting.ord !=1)


/* Lead actors in 1962 movies
10.
List the films together with the leading star for all 1962 films. */

SELECT movie.title, actor.name
FROM movie
    JOIN casting
    ON casting.movieid = movie.id
    JOIN actor
    ON actor.id = casting.actorid
WHERE movie.yr = 1962
    AND casting.ord = 1



/* Harder Questions

Busy years for Rock Hudson
11.
Which were the busiest years for 'Rock Hudson', show the year 
and the number of movies he made each year for any year in which he made more than 2 movies. */


SELECT movie.yr, count(actor.name)
FROM casting
    JOIN movie
    ON casting.movieid = movie.id
    JOIN actor
    ON actor.id = casting.actorid
WHERE actor.name = 'Rock Hudson'
GROUP BY movie.yr
HAVING  count(actor.name) > 2


/* Lead actor in Julie Andrews movies
12.
List the film title and the leading actor for all of the films 'Julie Andrews' played in.
Did you get "Little Miss Marker twice"? */

SELECT movie.title, x.name
FROM (SELECT actor.name, movieid, actorid, ord
    FROM casting JOIN actor ON actor.id = casting.actorid) AS x
    JOIN movie ON movie.id = x.movieid
WHERE movie.id IN (SELECT movieid
    FROM casting
        JOIN actor ON casting.actorid = actor.id
    WHERE actor.name = 'Julie Andrews')
    AND x.ord = 1


/* Actors with 15 leading roles
13.
Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles. */

SELECT name
FROM (SELECT actorid
    FROM casting
    WHERE ord =1
    GROUP BY actorid
    HAVING count(*) >= 15 ) as x
    JOIN actor ON x.actorid = id
ORDER BY name


/* 14.
List the films released in the year 1978 ordered by the number of actors in the cast, then by title. */

SELECT title, count(actorid)
FROM movie
    JOIN casting ON movie.id= movieid
WHERE id IN (SELECT id
FROM movie
WHERE yr = 1978)
GROUP BY title
ORDER BY count(actorid) DESC, title


/* 15.
List all the people who have worked with 'Art Garfunkel'. */

SELECT name
FROM casting
    JOIN actor ON actorid = actor.id
    JOIN movie ON movie.id = movieid
WHERE movie.id IN
(SELECT movieid
    FROM casting
        JOIN actor ON casting.actorid = actor.id
    WHERE actor.name = 'Art Garfunkel')
    AND name != 'Art Garfunkel'