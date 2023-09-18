-- Overview Our Dataset
SELECT *
FROM dbo.imdb_top_1000;

---------------------------------------------------------------
---  (1)Cleaning Our Dataset  ---------------------------------
---------------------------------------------------------------

-- Delete unused column 'Poster_link'
alter table imdb_top_1000
drop column poster_link;


-- 'Released Year' show the rows that don't contain Numbers
select *
from dbo.imdb_top_1000
where Released_Year not like '%[0-9]%';


-- Update the wronge value
update dbo.imdb_top_1000
set Released_Year='1995'
where Released_Year not like '%[0-9]%';


-- Succesfully I can convert 'Released_Year' to (int) Manualy
update dbo.imdb_top_1000
set Released_Year = cast(Released_Year as int);


-- Remove the 'm' Letter in the end of each record
select SUBSTRING(Runtime,1,CHARINDEX('m',Runtime)-1) 
from dbo.imdb_top_1000;

update dbo.imdb_top_1000
set Runtime = SUBSTRING(Runtime,1,CHARINDEX('m',Runtime)-1);


-- Now I can convert 'Runtime' to (int) manualy to do Some Analysis
update dbo.imdb_top_1000
set Runtime = cast(Runtime as int);


-- Split 'Genre' Column into multiple columns with ','
Select
PARSENAME(REPLACE(Genre, ',', '.') , 1)
,PARSENAME(REPLACE(Genre, ',', '.') , 2)
,PARSENAME(REPLACE(Genre, ',', '.') , 3)
From dbo.imdb_top_1000

-----------------------------------------------------------------
-- Add Columns for splited 'Genre' -->  (Genre1,Genre2,Genre3)

alter table dbo.imdb_top_1000
add Genre1 nvarchar(10), Genre2 nvarchar(10),Genre3 nvarchar(10);

update dbo.imdb_top_1000
set Genre1 = trim(PARSENAME(REPLACE(Genre, ',', '.') , 1));

update dbo.imdb_top_1000
set Genre2 = trim(PARSENAME(REPLACE(Genre, ',', '.') , 2));

update dbo.imdb_top_1000
set Genre3 = trim(PARSENAME(REPLACE(Genre, ',', '.') , 3));


-- Standrize ('Music','Musical')  --> ('Music')
update dbo.imdb_top_1000
set Genre = case
    when Genre1 = 'Musical' then 'Music'
	else Genre1
	End

update dbo.imdb_top_1000
set Genre2 = case
    when Genre2 = 'Musical' then 'Music'
	else Genre2
	End

-----------------------------------------------------------------------
-- Approx the 'IMDB_Rating' to nearset 2 decimal only using ROUND()

update dbo.imdb_top_1000
set IMDB_Rating = ROUND(IMDB_Rating,2);

------------------------------------------------------------------------
-- Standrize 'null' in Meta_score 

alter table dbo.imdb_top_1000
add Edited_Meta int; 

update dbo.imdb_top_1000
set Edited_Meta = case
         when Meta_score is not null then Meta_score
		 when Meta_score is null then IMDB_Rating * 10
		 End

----------------------------------------------------------------
-- Now Our data is Ready for Exploration -----------------------
----------------------------------------------------------------
-- Analysing Data To Answer This Questions:
-- 1.What is the average IMDB rating for movies in the dataset?
-- 2.What is the most common genre for movies in the dataset?
-- 3.What is the year with the most movies in the dataset?
-- 4.What is the average runtime for movies in the dataset?
-- 5.Who is the most prolific director in the dataset (based on number of movies directed)?
-- 8.Analysis of the gross of a movie vs directors.
-- 9.Analysis of the gross of a movie vs Certificate
-- 10.What are the top 10 highest-rated movies by director?
-------------------------------------------------------------------------------------

-- 1.What is the average IMDB rating for movies in the dataset?

Select Round(AVG(IMDB_rating),2)
from dbo.imdb_top_1000;            --> 7.95

--------------------------------------------------------------------------------------

-- 2.What is the most common genre for movies in the dataset?
With GenreCTE As(
select Genre1 As Genre from dbo.imdb_top_1000
union all
select Genre2 from dbo.imdb_top_1000
union all
select Genre3 from dbo.imdb_top_1000
)
Select Top(5) Genre , COUNT(Genre) AS Genre_Count
From GenreCTE
group by Genre
order by Genre_Count Desc;

-------------------------------------------------------------

-- 3.What is the year with the most movies in the dataset?
Select Top(1) Released_Year , COUNT(Series_Title) as Movies_Number
from dbo.imdb_top_1000
Group by Released_Year
order by Movies_Number DESC;   --> 2014 : 32 Movies

-------------------------------------------------------------

-- 4.What is the average runtime for movies in the dataset?
Select AVG(Runtime)
from dbo.imdb_top_1000;   --> 122 Min

-------------------------------------------------------------

-- 5.Who are the 5 most prolific director?
Select Top(5) Director , COUNT(Director) as No_Movies
from dbo.imdb_top_1000
Group by Director
Order by No_Movies DESC;

-------------------------------------------------------------------

-- 6.Analysis of the gross of a movie vs directors.
update dbo.imdb_top_1000     /* Remove "," between numbers in 'Gross'  */
set Gross = case
            when Gross is not null then REPLACE(Gross,',','')
			when Gross is null then '0'
			end;

select Top(5) Director , SUM(Gross) as Sum_Gross
from dbo.imdb_top_1000
group by Director
ORDER BY Sum_Gross DESC;

--------------------------------------------------------------------

-- 7.Analysis of the gross of a movie vs Certificate
select Top(5) Certificate , SUM(Gross) as Sum_Gross
from dbo.imdb_top_1000
group by Certificate
ORDER BY Sum_Gross DESC;

---------------------------------------------------------------------

-- 8.What are the top 10 highest-rated movies by director?
select Top(10) Director  ,MAX(IMDB_Rating) as Rating
from dbo.imdb_top_1000
group by Director
ORDER BY Rating DESC;
----------------------------------------------------------------------

select *
from dbo.imdb_top_1000;
---------------------------------------------------------------------