-- Date
select 
CONCAT(`Year`, '-', LPAD(`Month (#)`, 2, '0'), '-', LPAD(`Day`, 2, '0')) AS FormattedDate
from maindata;

 -- year
select distinct year from maindata;

-- Month
select distinct `Month (#)` from maindata
order by `Month (#)` asc;

-- MonthFulName
SELECT distinct
    `Month (#)`,
    MONTHNAME(STR_TO_DATE(CONCAT('2024-', CAST(`Month (#)` AS UNSIGNED), '-01'), '%Y-%m-%d')) AS MonthName
FROM maindata
ORDER BY `Month (#)` ASC;

-- quarter
SELECT distinct
    `Month (#)`,
    CONCAT('Q', CEIL(CAST(`Month (#)` AS UNSIGNED) / 3)) AS Quarter
FROM maindata
ORDER BY  `Month (#)` ASC;

-- Year-month
SELECT 
    `Year`, 
    `Month (#)`,
    CONCAT(`Year`, '-', LPAD(`Month (#)`, 2, '0')) AS YearMonth
FROM maindata;

-- Yearly Load Factor
SELECT 
    `Year`, 
    ROUND(SUM(`TransportedPassengers`) / SUM(`AvailableSeats`) * 100, 2) AS YearlyLoadFactorPercentage
FROM maindata
GROUP BY `Year`;

-- Monthly Load Factor
SELECT 
    `Year`, 
    `Month`, 
    ROUND(SUM(`TransportedPassengers`) / SUM(`AvailableSeats`) * 100, 2) AS MonthlyLoadFactorPercentage
FROM maindata
GROUP BY `Year`, `Month`;

-- Quarterly Load Factor
SELECT 
    `Year`, 
    CASE 
        WHEN `Month` IN (1, 2, 3) THEN 'Q1'
        WHEN `Month` IN (4, 5, 6) THEN 'Q2'
        WHEN `Month` IN (7, 8, 9) THEN 'Q3'
        WHEN `Month` IN (10, 11, 12) THEN 'Q4'
    END AS Quarter,
    ROUND(SUM(`TransportedPassengers`) / SUM(`AvailableSeats`) * 100, 2) AS QuarterlyLoadFactorPercentage
FROM maindata
GROUP BY `Year`, Quarter;





-- Weekday no and Week name

SELECT 
    CONCAT(`Year`, '-', LPAD(`Month (#)`, 2, '0'), '-', LPAD(`Day`, 2, '0')) AS FormattedDate,
    CASE 
        WHEN DAYOFWEEK(STR_TO_DATE(CONCAT(`Year`, '-', LPAD(`Month (#)`, 2, '0'), '-', LPAD(`Day`, 2, '0')), '%Y-%m-%d')) = 1 THEN 7 
        ELSE DAYOFWEEK(STR_TO_DATE(CONCAT(`Year`, '-', LPAD(`Month (#)`, 2, '0'), '-', LPAD(`Day`, 2, '0')), '%Y-%m-%d')) - 1
    END AS WeekdayNumber,
    CASE 
        WHEN DAYOFWEEK(STR_TO_DATE(CONCAT(`Year`, '-', LPAD(`Month (#)`, 2, '0'), '-', LPAD(`Day`, 2, '0')), '%Y-%m-%d')) = 1 THEN 'Sunday'
        WHEN DAYOFWEEK(STR_TO_DATE(CONCAT(`Year`, '-', LPAD(`Month (#)`, 2, '0'), '-', LPAD(`Day`, 2, '0')), '%Y-%m-%d')) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(STR_TO_DATE(CONCAT(`Year`, '-', LPAD(`Month (#)`, 2, '0'), '-', LPAD(`Day`, 2, '0')), '%Y-%m-%d')) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(STR_TO_DATE(CONCAT(`Year`, '-', LPAD(`Month (#)`, 2, '0'), '-', LPAD(`Day`, 2, '0')), '%Y-%m-%d')) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(STR_TO_DATE(CONCAT(`Year`, '-', LPAD(`Month (#)`, 2, '0'), '-', LPAD(`Day`, 2, '0')), '%Y-%m-%d')) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(STR_TO_DATE(CONCAT(`Year`, '-', LPAD(`Month (#)`, 2, '0'), '-', LPAD(`Day`, 2, '0')), '%Y-%m-%d')) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(STR_TO_DATE(CONCAT(`Year`, '-', LPAD(`Month (#)`, 2, '0'), '-', LPAD(`Day`, 2, '0')), '%Y-%m-%d')) = 7 THEN 'Saturday'
    END AS WeekdayName
FROM maindata;

-- financial month and financial Quarter
SELECT 
    CONCAT(`Year`, '-', LPAD(`Month (#)`, 2, '0'), '-', LPAD(`Day`, 2, '0')) AS FormattedDate,
    CASE 
        WHEN `Month (#)` >= 4 THEN `Month (#)` - 3
        ELSE `Month (#)` + 9
    END AS FinancialMonth,
    CASE 
        WHEN `Month (#)` >= 4 AND `Month (#)` <= 6 THEN CONCAT('Q1')
        WHEN `Month (#)` >= 7 AND `Month (#)` <= 9 THEN CONCAT('Q2')
        WHEN `Month (#)` >= 10 AND `Month (#)` <= 12 THEN CONCAT('Q3')
        ELSE CONCAT('Q4')
    END AS FinancialQuarter
FROM maindata;

-- 2. yearly/monthly/quarterly based on load factor percentage

-- Yearly Load Factor
SELECT 
    `Year`, 
    CONCAT(ROUND((SUM(Transported_Passengers) / SUM(Available_Seats)) * 100, 2), '%') AS load_factor
FROM maindata
GROUP BY `Year`;

-- Monthly Load Factor
SELECT 
    `Year`, 
    `Month (#)`, 
     CONCAT(ROUND((SUM(Transported_Passengers) / SUM(Available_Seats)) * 100, 2), '%') AS load_factor
FROM maindata
GROUP BY `Year`, `Month (#)`
order by `Year`, `Month (#)`;

-- Quarterly Load Factor
SELECT 
    `Year`, 
    CASE 
        WHEN `Month (#)` IN (1, 2, 3) THEN 'Q1'
        WHEN `Month (#)` IN (4, 5, 6) THEN 'Q2'
        WHEN `Month (#)` IN (7, 8, 9) THEN 'Q3'
        WHEN `Month (#)` IN (10, 11, 12) THEN 'Q4'
    END AS Quarter,
    CONCAT(ROUND((SUM(Transported_Passengers) / SUM(Available_Seats)) * 100, 2), '%') AS load_factor
FROM maindata
GROUP BY `Year`, Quarter
order by year,Quarter asc;

-- 3. Find the load Factor percentage on a Carrier Name basis ( Transported passengers / Available seats)

SELECT 
    `Carrier_Name`, 
    SUM(`Transported_Passengers`) AS Total_Transported_Passengers,
    SUM(`Available_Seats`) AS Total_Available_Seats,
    CONCAT(ROUND((SUM(Transported_Passengers) / SUM(Available_Seats)) * 100, 2), '%') AS load_factor
FROM maindata
GROUP BY `Carrier_Name`
ORDER BY Load_factor DESC
LIMIT 5;

-- 4.Top 10 Carrier Names Based On Load Factor
 
 SELECT Carrier_Name, 
       CONCAT(ROUND((SUM(Transported_Passengers) / SUM(Available_Seats)) * 100, 2), '%') AS load_factor
FROM maindata
WHERE Transported_Passengers IS NOT NULL AND Available_Seats IS NOT NULL
GROUP BY Carrier_Name
ORDER BY load_factor DESC
LIMIT 10;

-- 5. Display top Routes ( from-to City) based on Number of Flights 

SELECT 
    From_To_City,
    COUNT(*) AS NumberOfFlights
FROM maindata
GROUP BY  From_To_City
ORDER BY NumberOfFlights DESC
LIMIT 10;  -- Change 


-- 6.Identify the how much load factor is occupied on Weekend vs Weekdays.

SELECT 
    CASE 
        WHEN DAYOFWEEK(STR_TO_DATE(CONCAT(`Year`, '-', LPAD(`Month (#)`, 2, '0'), '-', LPAD(`Day`, 2, '0')), '%Y-%m-%d')) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS DayType,
    CONCAT(ROUND((SUM(Transported_Passengers) / SUM(Available_Seats)) * 100, 2), '%') AS load_factor
FROM maindata
GROUP BY DayType;

SELECT 
    CASE 
        WHEN DAYOFWEEK(STR_TO_DATE(CONCAT(`Year`, '-', LPAD(`Month (#)`, 2, '0'), '-', LPAD(`Day`, 2, '0')), '%Y-%m-%d')) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS DayType,
    CONCAT(ROUND((SUM(Transported_Passengers) / SUM(Available_Seats)) * 100, 2), '%') AS load_factor,
    ROUND((SUM(Transported_Passengers) / SUM(Available_Seats)) * 100 / 100, 2) AS total_divided_by_100
FROM maindata
GROUP BY DayType;


SELECT 
    CASE 
        WHEN DAYOFWEEK(STR_TO_DATE(CONCAT(`Year`, '-', `Month (#)`, '-', `Day`), '%Y-%m-%d')) IN (1,2,3,4,5) THEN 'Weekday'
        WHEN DAYOFWEEK(STR_TO_DATE(CONCAT(`Year`, '-', `Month (#)`, '-', `Day`), '%Y-%m-%d')) IN (6, 7) THEN 'Weekend'
    END AS Day_Type,
    COUNT(*) AS Load_Count,
    CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM maindata)), 2), '%') AS Load_Percentage
FROM maindata
GROUP BY Day_Type
order by Load_Percentage desc;

-- 7. Use the filter to provide a search capability to find the flights between Source Country, Source State, Source City to Destination Country , Destination State, Destination City 

SELECT 
     Airline_ID, 
     Origin_Country, 
     Origin_State, 
     Origin_City, 
	 Destination_Country, 
     Destination_State, 
     Destination_City 
FROM maindata
WHERE 
    (Origin_Country LIKE IFNULL(origin_country, origin_country)) AND
    (origin_state LIKE IFNULL(origin_state, origin_state)) AND
    (origin_city LIKE IFNULL(origin_city, origin_city)) AND
    (Destination_Country LIKE IFNULL(destination_country, destination_country)) AND
    (Destination_State LIKE IFNULL(destination_state, destination_state)) AND
    (Destination_City LIKE IFNULL(destination_city, destination_city));
    
-- 8. Identify number of flights based on Distance groups
 SELECT 
    `Distance_Group_id`, 
    COUNT(*) AS NumberOfFlights
FROM maindata
GROUP BY `Distance_Group_id`
ORDER BY `Distance_Group_id` ASC;
    
    