SELECT *
FROM dbo.Car_Craches

                       /* Analyzing Questions */
-----------------------------------------------------------------------
/* 1.What is the most common type of car involved in car crashes?
   2.What is the most common cause of car crashes? 
   3.What are the most common days of the week that car crashes occur?
   4.What are the most common locations where car crashes occur?
   5.What are the most common times of day that car crashes occur?
   6.What are the most common causes of death in car crashes?
   7.What are the most common injuries sustained in car crashes that do not result in death?
   8.What are the most common types of vehicles involved in car crashes involving pedestrians?
   9.What are the most common types of vehicles involved in car crashes involving cyclists?
  10.What are the most common types of vehicles involved in car crashes involving motorcyclists?
  11.What are the most effective measures to prevent car crashes? */
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
/* 1.What is the most common type of car involved in car crashes?*/

SELECT VEHICLE_TYPE,
       COUNT(*) as VEHICLE_COUNT
FROM
(
    SELECT VEHICLE_TYPE_CODE_1 as VEHICLE_TYPE 
    FROM dbo.Car_Craches
    UNION ALL
    SELECT VEHICLE_TYPE_CODE_2 
    FROM dbo.Car_Craches
) as subQuery
GROUP BY VEHICLE_TYPE
ORDER BY VEHICLE_COUNT DESC;

------------------------------------------------------------------
/* 2.What is the most common cause of car crashes?*/

SELECT Crashes_Cause,
       COUNT(*) as Crashes_COUNT
FROM
(
    SELECT CONTRIBUTING_FACTOR_VEHICLE_1 as Crashes_Cause 
    FROM dbo.Car_Craches
    UNION ALL
    SELECT CONTRIBUTING_FACTOR_VEHICLE_2 
    FROM dbo.Car_Craches
) as subQuery
GROUP BY Crashes_Cause
ORDER BY Crashes_COUNT DESC;

----------------------------------------------------------
/* 3.What are the most common days of the week that car crashes occur? */

SELECT  
        DATENAME(WEEKDAY,CRASH_DATE) AS Week_Day
		,COUNT(COLLISION_ID) as Crashes_Count
FROM dbo.Car_Craches
group by DATENAME(WEEKDAY,CRASH_DATE)
order by Crashes_Count desc , DATENAME(WEEKDAY,CRASH_DATE)  desc;


SELECT 
        DATENAME(WEEKDAY,CRASH_DATE) as Week_Day
        ,ON_STREET_NAME
		,BOROUGH
		,COUNT(COLLISION_ID) as Crashes_Count
FROM dbo.Car_Craches
group by DATENAME(WEEKDAY,CRASH_DATE) , ON_STREET_NAME ,BOROUGH
order by Crashes_Count desc , DATENAME(WEEKDAY,CRASH_DATE)  desc; 
 
--------------------------------------------------------------------------------

/* 4.What are the most common locations where car crashes occur? */

SELECT Top(10)
        ON_STREET_NAME as Street_Name
		,COUNT(COLLISION_ID) as Crashes_Count
		, BOROUGH as state
FROM dbo.Car_Craches
group by ON_STREET_NAME , BOROUGH
order by Crashes_Count desc; 

-----------------------------------------------------------------------------------
/* 5.What are the most common times of day that car crashes occur? */

SELECT Top(15)
        ON_STREET_NAME
		,BOROUGH
        ,CRASH_TIME
		,COUNT(COLLISION_ID) as Crashes_Count
FROM dbo.Car_Craches
group by ON_STREET_NAME,CRASH_TIME,BOROUGH
order by Crashes_Count desc; 

SELECT  
        CRASH_TIME
		,COUNT(COLLISION_ID) as Crashes_Count
FROM dbo.Car_Craches
group by CRASH_TIME
order by Crashes_Count desc; 

-------------------------------------------------------------------------------
/* 6.What are the most common causes of death in car crashes? */

SELECT 
   CONTRIBUTING_FACTOR_VEHICLE_1 as Crashes_Cause
   ,SUM(NUMBER_OF_PERSONS_KILLED) as Persons_Dead
FROM dbo.Car_Craches
where NUMBER_OF_PERSONS_KILLED > 0
group by CONTRIBUTING_FACTOR_VEHICLE_1
Order by Persons_Dead Desc;


SELECT 
   CONTRIBUTING_FACTOR_VEHICLE_2 as Crashes_Cause
   ,SUM(NUMBER_OF_PERSONS_KILLED) as Persons_Dead
FROM dbo.Car_Craches
where NUMBER_OF_PERSONS_KILLED > 0
group by CONTRIBUTING_FACTOR_VEHICLE_2
Order by Persons_Dead Desc;


SELECT Crashes_Cause,
       SUM(NUMBER_OF_PERSONS_KILLED) as Persons_Dead
FROM
(
    SELECT CONTRIBUTING_FACTOR_VEHICLE_1 as Crashes_Cause ,NUMBER_OF_PERSONS_KILLED 
    FROM dbo.Car_Craches
	where NUMBER_OF_PERSONS_KILLED > 0
    UNION ALL
    SELECT CONTRIBUTING_FACTOR_VEHICLE_2 , NUMBER_OF_PERSONS_KILLED
    FROM dbo.Car_Craches
	where NUMBER_OF_PERSONS_KILLED > 0 
	and CONTRIBUTING_FACTOR_VEHICLE_2 <> CONTRIBUTING_FACTOR_VEHICLE_1

) as subQuery
GROUP BY Crashes_Cause
ORDER BY Persons_Dead DESC;

-------------------------------------------------------------------
/* 7.What are the most common injuries sustained in car crashes that do not result in death? */

SELECT Crashes_Cause,
       SUM(NUMBER_OF_PERSONS_INJURED) as Persons_Injurd
FROM
(
    SELECT CONTRIBUTING_FACTOR_VEHICLE_1 as Crashes_Cause ,NUMBER_OF_PERSONS_INJURED 
    FROM dbo.Car_Craches
	where NUMBER_OF_PERSONS_INJURED > 0
    UNION ALL
    SELECT CONTRIBUTING_FACTOR_VEHICLE_2 , NUMBER_OF_PERSONS_INJURED
    FROM dbo.Car_Craches
	where NUMBER_OF_PERSONS_INJURED > 0 
	and CONTRIBUTING_FACTOR_VEHICLE_2 <> CONTRIBUTING_FACTOR_VEHICLE_1

) as subQuery
GROUP BY Crashes_Cause
ORDER BY Persons_Injurd DESC;

------------------------------------------------------------------------------
/* 8.What are the most common types of vehicles involved in car crashes involving pedestrians? */

SELECT VEHICLE_TYPE,
       COUNT(*) as Car_Crashes_Involving_Pedestrians
FROM
(
    SELECT VEHICLE_TYPE_CODE_1 as VEHICLE_TYPE 
    FROM dbo.Car_Craches
	Where NUMBER_OF_PEDESTRIANS_INJURED > 0 Or NUMBER_OF_PEDESTRIANS_KILLED > 0 
    UNION ALL
    SELECT VEHICLE_TYPE_CODE_2 
    FROM dbo.Car_Craches
	Where NUMBER_OF_PEDESTRIANS_INJURED > 0 Or NUMBER_OF_PEDESTRIANS_KILLED > 0
) as subQuery
GROUP BY VEHICLE_TYPE
ORDER BY Car_Crashes_Involving_Pedestrians DESC;

------------------------------------------------------------------------------------
/* 9.What are the most common types of vehicles involved in car crashes involving cyclists? */

SELECT VEHICLE_TYPE,
       COUNT(*) as Car_Crashes_Involving_Cyclists
FROM
(
    SELECT VEHICLE_TYPE_CODE_1 as VEHICLE_TYPE 
    FROM dbo.Car_Craches
	Where NUMBER_OF_CYCLIST_INJURED > 0 Or NUMBER_OF_CYCLIST_KILLED > 0 
    UNION ALL
    SELECT VEHICLE_TYPE_CODE_2 
    FROM dbo.Car_Craches
	Where NUMBER_OF_CYCLIST_INJURED > 0 Or NUMBER_OF_CYCLIST_KILLED > 0 
) as subQuery
GROUP BY VEHICLE_TYPE
ORDER BY Car_Crashes_Involving_Cyclists DESC;

---------------------------------------------------------------------------------------
/* 10.What are the most common types of vehicles involved in car crashes involving motorcyclists? */

SELECT VEHICLE_TYPE,
       COUNT(*) as Car_Crashes_Involving_MOTORISTS
FROM
(
    SELECT VEHICLE_TYPE_CODE_1 as VEHICLE_TYPE 
    FROM dbo.Car_Craches
	Where [NUMBER_OF_MOTORIST_INJURED] > 0 Or [NUMBER_OF_MOTORIST_KILLED] > 0 
    UNION ALL
    SELECT VEHICLE_TYPE_CODE_2 
    FROM dbo.Car_Craches
	Where [NUMBER_OF_MOTORIST_INJURED] > 0 Or [NUMBER_OF_MOTORIST_KILLED] > 0
) as subQuery
GROUP BY VEHICLE_TYPE
ORDER BY Car_Crashes_Involving_MOTORISTS DESC;

------------------------------------------------------------------------------------------
/* 11.What are the most effective measures to prevent car crashes? */
/* Ans: Show the least Types of Cars Involved in Crashes */

SELECT VEHICLE_TYPE,
       COUNT(*) as VEHICLE_COUNT
FROM
(
    SELECT VEHICLE_TYPE_CODE_1 as VEHICLE_TYPE 
    FROM dbo.Car_Craches
    UNION ALL
    SELECT VEHICLE_TYPE_CODE_2 
    FROM dbo.Car_Craches
) as subQuery
GROUP BY VEHICLE_TYPE
Having COUNT(*) < 2
ORDER BY VEHICLE_COUNT;

----------------------------------------------------------------------------------
------------------------------  /* The End */  -----------------------------------
----------------------------------------------------------------------------------