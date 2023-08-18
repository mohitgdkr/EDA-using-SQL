--Combining the 4 small tables into 1 large

CREATE table applestore_description_combined as 

SELECT * from appleStore_description1

union all 

SELECT * from appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4

--Checking the duplicates in both tables
SELECT COUNT(DISTINCT id) from AppleStore
SELECT COUNT(DISTINCT id) FROM applestore_description_combined

--Checking the missing values in key fields of both tables
SELECT COUNT(*) as MissingValues
from AppleStore
WHERE track_name is null or user_rating is null or prime_genre is null

sELECT COUNT(*) as MissingValues
from applestore_description_combined
WHERE track_name is null or app_desc is null

--Finding the number of apps per genre
SELECT prime_genre, COUNT(*) as NumApps
from AppleStore
GROUP by prime_genre
ORDER by NumApps desc

--Get an overview of the apps' ratings 
SELECT min(user_rating) as MinRating,
       max(user_rating) as MaxRating,
       round(avg(user_rating),2) as AvgRating
from AppleStore

--Whether paid apps have higher ratings than free apps
SELECT CASE
when price > 0 then 'paid'
when price = 0 THEN 'free'
end as App_type,
round(avg(user_rating),2) as Avg_Rating
from AppleStore
GROUP by App_type
ORDER by Avg_Rating desc

--Checking if apps with more supported languages have higher ratingsAppleStore
SELECT CASE
when lang_num > 30 then '>30 languages'
when lang_num BETWEEN 10 and 30 then '10-30 languages'
ELSE '<10 languages'
end as language_bucket,
round(avg(user_rating),2) as Avg_Rating
from AppleStore
GROUP by language_bucket
ORDER by Avg_Rating DESC

--Check genre with low ratings 
SELECT prime_genre,
       round(avg(user_rating),2) as Avg_Rating 
from AppleStore
GROUP by prime_genre
ORDER by Avg_Rating asc
LIMIT 10

--Check if there is correlation between the length of the app description and user ratings
SELECT CASE
when length(B.app_desc) < 500 then 'Short'
when length(B.app_desc) BETWEEN 500 and 1000 then 'Medium'
ELSE 'Long'
end as descript_length_bucket,
round(avg(A.user_rating),2) as Avg_Rating
FROM AppleStore as A 
JOIN applestore_description_combined as B 
ON A.id = B.id
GROUP by descript_length_bucket
order by Avg_Rating DESC

--Check the top-rated apps for each genre
SELECT prime_genre, track_name, user_rating
from (
  SELECT prime_genre, track_name, user_rating,
  rank() over(partition by prime_genre order by user_rating desc, rating_count_tot desc) as rank
  from AppleStore) as a 
WHERE a.rank = 1 

