/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.
 */

/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT DISTINCT name 
FROM Facilities 
WHERE membercost = 0.0 
ORDER By name ;

/* Q2: How many facilities do not charge a fee to members? */

4 Facilities

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance 
FROM Facilities 
WHERE membercost < (0.20*monthlymaintenance) 
;

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT * 
FROM Facilities 
WHERE facid IN (1, 5) 
;

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance,
CASE
	WHEN monthlymaintenance <=100 THEN 'cheap'
	WHEN monthlymaintenance >100 THEN 'expensive'
	END AS 'maintenance rating'
FROM Facilities
;

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT m.firstname, m.surname
FROM (SELECT firstname, surname, MAX(joindate) 
      FROM Members
      GROUP BY memid) j
	JOIN Members m
	ON j.firstname = m.firstname
;

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT  
	CONCAT(m.firstname, ' ', m.surname) as MemberName,
	f.name as court
FROM Members AS m
	INNER JOIN Bookings AS b
		ON m.memid = b.memid
		INNER JOIN Facilities AS f
			ON b.facid = f.facid
			WHERE (f.name LIKE '%Tennis Court%' AND m.memid != '0')
GROUP BY MemberName
ORDER BY MemberName;

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT
	f.name AS facility_name,
	CONCAT(m.firstname,' ', m.surname) AS name,
	CASE WHEN m.memid=0 AND f.guestcost > 30.0 THEN f.guestcost
		WHEN m.memid>0 AND f.membercost > 30.0 THEN f.membercost
		END AS cost
FROM Members AS m
	INNER JOIN Bookings AS b
		ON m.memid = b.memid
		INNER JOIN Facilities AS f
			ON b.facid = f.facid
			WHERE(b.starttime LIKE '2012-09-14%')
ORDER BY `cost`  DESC;

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT
	f.name AS facility_name,
	CONCAT(m.firstname,' ', m.surname) AS name,
	CASE WHEN m.memid=0 AND f.guestcost > 30.0 THEN f.guestcost
		WHEN m.memid>0 AND f.membercost > 30.0 THEN f.membercost
		END AS cost
FROM Members AS m
	INNER JOIN (	
        SELECT memid, facid
 		FROM Bookings
 		WHERE starttime LIKE '2012-09-14%') AS b
		ON m.memid = b.memid
			INNER JOIN Facilities AS f
				ON b.facid = f.facid
ORDER BY `cost`  DESC;

/* PART 2: SQLite
/* We now want you to jump over to a local instance of the database on your machine. 
*/
 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

	How to calculate the revenue?

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

SELECT 
    CONCAT(surname, ", " firstname) AS member, 
    recommendedby
FROM Members AS m
ORDER BY member DESC;

	How can I get the names of the recommenders using their member ids?
	THINGS TO TRY: https://dev.mysql.com/doc/refman/8.0/en/with.html 

SELECT
	CONCAT(surname, ", ", firstname) AS member,
	recommendedby AS rec_id,
	recommender
FROM Members AS m
WHERE (SELECT
       surname,
       firstname, 
       FROM Members
       WHERE recommendedby = memid) AS recommender
ORDER BY member DESC;

/* Q12: Find the facilities with their usage by member, but not guests */

	

/* Q13: Find the facilities usage by month, but not guests */

