--Q1
--1/1 point (graded)
--Find the titles of all movies directed by Steven Spielberg.

select movie.title 
from movie
where director = 'Steven Spielberg';

--Q2
--1/1 point (graded)
--Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.

select distinct movie.year
from movie
join rating
on movie.mID = rating.mID
where rating.stars in (4, 5)
order by year;

--Q3
--1/1 point (graded)
--Find the titles of all movies that have no ratings.

select movie.title
from movie
where movie.mID in (select movie.mID
					from movie
					left join rating 
					on movie.mID = rating.mID
					where rating.mID is null);
          
--Q4
--1/1 point (graded)
--Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.

select reviewer.name
from reviewer
left join rating
on reviewer.rID = rating.rID
where rating.ratingDate is null;

--Q5
--1/1 point (graded)
--Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.

select reviewer.name, movie.title, rating.stars, rating.ratingDate
from movie
join rating
on movie.mID = rating.mID
join reviewer 
on reviewer.rID = rating.rID
order by reviewer.name asc, movie.title asc, rating.stars asc;

--Q6
--1/1 point (graded)
--For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.

select reviewer.name, movie.title
from reviewer
join 
(select r1.rID, r1.mID, r1.stars
from rating r1
join rating r2
on  r1.rID = r2.rID
where r1.rID || r1.mID = r2.rID || r2.mID and r1.stars > r2.stars and r1.ratingDate > r2.ratingDate) as r3
on reviewer.rID = r3.rID
join movie
on r3.mID = movie.mID;

--Q7
--1/1 point (graded)
--For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.

select movie.title, r3.stars
from (select r1.mID, r1.stars
		from rating r1
		join rating r2
		on r1.mID = r2.mID
		where r1.mID = r2.mID and r1.stars > r2.stars
		group by r1.mID
		order by r1.mID) as r3
join movie
on movie.mID = r3.mID
order by movie.title;

--Q8
--1/1 point (graded)
--For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.

select movie.title, t1.rating_spread
from
(select rating.mID, (max(rating.stars) - min(rating.stars)) as rating_spread
from rating
group by rating.mID) as t1
join movie
on movie.mID = t1.mID
order by t1.rating_spread desc, movie.title;

--Q9
--1/1 point (graded)
--Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)

select (avg(before.before_avg) - avg(after.after_avg))
from 

	(select avg(rating.stars) as before_avg
		from rating
		inner join movie
		on movie.mID = rating.mId
		where movie.year < 1980
		group by movie.mID) as before,
	
	(select avg(rating.stars) as after_avg
		from rating
		inner join movie
		on movie.mID = rating.mId
		where movie.year > 1980
		group by movie.mID) as after;
