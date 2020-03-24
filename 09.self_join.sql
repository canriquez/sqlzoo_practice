
/* 1.
How many stops are in the database. */

SELECT COUNT(id)
FROM stops

/* 2.
Find the id value for the stop 'Craiglockhart' */

SELECT id
FROM stops
WHERE name = 'Craiglockhart'

/* 3.
Give the id and the name for the stops on the '4' 'LRT' service. */

SELECT stops.id, stops.name
FROM stops
    LEFT JOIN route ON stop = id
WHERE company = 'LRT' AND num = '4'


/* Routes and stops
4.
The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53).
 Run the query and notice the two services that link these stops have a count of 2. 
Add a HAVING clause to restrict the output to these two routes. */

SELECT company, num, COUNT(*)
FROM route
WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) = 2

/* 5.
Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, 
without changing routes. 
Change the query so that it shows the services from Craiglockhart to London Road. */

SELECT a.company, a.num, a.stop, b.stop
FROM route a
    JOIN route b ON (a.company=b.company AND a.num=b.num)
WHERE a.stop IN (SELECT id
    FROM stops
    WHERE name = 'Craiglockhart')
    AND b.stop IN (SELECT id
    FROM stops
    WHERE name = 'London Road')

/* 6.
The query shown is similar to the previous one, however by joining two copies of the stops 
table we can refer to stops by name rather than by number. 
Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. 
If you are tired of these places try 'Fairmilehead' against 'Tollcross' */

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
    JOIN stops stopa ON (a.stop=stopa.id)
    JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name='London Road'



/* Using a self join
7.
Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith') */

SELECT a.company, a.num
FROM route AS a
    JOIN route AS b ON a.num = b.num
WHERE a.stop = 115 AND b.stop = 137
GROUP BY a.num

/* 8.
Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross' */

SELECT a.company, a.num
FROM route AS a
    JOIN route AS b ON a.num = b.num
    JOIN stops AS stopsa ON stopsa.id = a.stop
    JOIN stops AS stopsb ON stopsb.id = b.stop
WHERE stopsa.name = 'Craiglockhart' AND stopsb.name='Tollcross'
GROUP BY a.num

/* 9.
Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, 
including 'Craiglockhart' itself, offered by the LRT company. 
Include the company and bus no. of the relevant services. */

SELECT stopsb.name, a.company, a.num
FROM route AS a
    JOIN route AS b ON a.num = b.num AND a.company = b.company
    JOIN stops AS stopsa ON stopsa.id = a.stop
    JOIN stops AS stopsb ON stopsb.id = b.stop
WHERE stopsa.name = 'Craiglockhart'

/* 10.
Find the routes involving two buses that can go from Craiglockhart to Lochend.
Show the bus no. and company for the first bus, the name of the stop for the transfer,
and the bus no. and company for the second bus. */

/* MY BEST TRY SO FAR */

SELECT origin.num, origin.company, stopsf.name, finish.num, finish.company
FROM (SELECT b.stop, a.num, a.company
    FROM route AS a
        JOIN route AS b ON a.num = b.num
    WHERE a.stop = 53) as origin
    JOIN (SELECT b.stop, a.num, a.company
    FROM route AS a
        JOIN route AS b ON a.num = b.num
    WHERE a.stop = 147) AS finish ON origin.stop = finish.stop
    JOIN stops AS stopso ON stopso.id = origin.stop
    JOIN stops AS stopsf ON stopsf.id = finish.stop
GROUP BY origin.num, stopso.id, finish.num

/* Issues: Not a 100% working solution. Still working on it. Above is my best try so far.
There are issues with data grouping. Is a good approximation, but I have repeated results. */








