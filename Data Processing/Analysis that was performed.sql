---This is to see the dataset in full for USER_PROFILE. 
SELECT * FROM studies101.default.user_profiles;

--This is to see how many subscribers there are 
SELECT COUNT(*) AS Total_profile_records,
      COUNT(DISTINCT UserID) AS Unique_subscribers
FROM studies101.default.user_profiles;

--This is pretty much to see the gender breakdown and fill in the NULL with unknown
SELECT IFNULL(Gender,'Unknown') AS Gender,
      COUNT(*) AS Total_subscribers
FROM studies101.default.user_profiles
GROUP BY Gender 
ORDER BY Total_subscribers DESC;

---This is to see the race breakdown 
SELECT IFNULL(Race, 'Unknown') AS Race,
      COUNT(*) AS Total_subscribers
FROM studies101.default.user_profiles
GROUP BY Race
ORDER BY Total_subscribers DESC;

---This is to see the age distribution 
SELECT  COUNT(*) AS Total_subscribers, 
        ROUND(AVG(Age),1) AS Average_Age,
    CASE WHEN Age BETWEEN 5 AND 17 THEN 'Youth'
         WHEN Age BETWEEN 18 AND 24 THEN 'Young_Adult'
         WHEN Age BETWEEN 25 AND 34 THEN 'Millennial'
         WHEN Age BETWEEN 35 AND 49 THEN 'Gen x'
         WHEN Age BETWEEN 50 AND 64 THEN 'Boomer' 
         WHEN Age >= 65 THEN 'Senior'
         ELSE 'Unknown'
    END AS Age_Groups
FROM studies101.default.user_profiles 
GROUP BY Age_Groups
ORDER BY Age_Groups;

--This is to see where the subscribers are mostly located 
SELECT IFNULL(Province, 'Unknown') AS Province, 
      COUNT(*) AS Total_subscribers
FROM studies101.default.user_profiles
GROUP BY Province 
ORDER BY Total_subscribers DESC;

---This is to see the how many subscribers have a social media handle on record
SELECT COUNT(*) AS Total_subscribers,
     CASE WHEN 'Social Media Handle' IS NULL THEN 'No Handle on Record'
          ELSE 'Has Handle on Record'
    END AS Social_Media_Status
FROM studies101.default.user_profiles
GROUP BY Social_Media_Status;

--- Put both gender and race together to see the the most dominant demographic 
 SELECT IFNULL(Gender,'Unknown') AS Gender, 
        IFNULL(Race, 'Unknown') AS RACE,
        COUNT(*) AS Total_subscribers
FROM studies101.default.user_profiles
GROUP BY Gender, Race
ORDER BY Total_subscribers DESC;


---=====================================================================================
---This is to see the full dataset for VIEWERSHIP=======================================
---=====================================================================================
SELECT * FROM studies101.default.viewership;

---This is to see how much total viewing time is in the dataset 
SELECT 
    ROUND(SUM(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0, 0) AS Total_Minutes_Viewed,
    COUNT(*) AS Total_Sessions,
    COUNT(DISTINCT UserID) AS Unique_Viewers,
    ROUND(AVG(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0, 2)  AS Avg_Minutes_Per_Session
FROM studies101.default.viewership
WHERE DATE_FORMAT(`Duration 2`, 'HH:MM:SS') <> '00:00:00'
;

---This is to see the duration in minutes
SELECT UserID, 
      Channel2 AS Channel,
      ROUND((HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0, 2) AS Duration_In_Minutes
FROM studies101.default.viewership
WHERE DATE_FORMAT(`Duration 2`, 'HH:MM:SS') <> '00:00:00'
LIMIT 20;

---same thing as the above but we are seeing the duration in hours
SELECT UserID, 
      Channel2 AS Channel,
      DATE_FORMAT(`Duration 2`,'HH:MM:SS') AS Raw_duration, 
      ROUND((HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 3600.0, 4) AS Duration_In_Hours
FROM studies101.default.viewership
WHERE DATE_FORMAT(`Duration 2`, 'HH:MM:SS') <> '00:00:00'
LIMIT 20;

--This is to see how many viewing sessions each subscriber had across the full dataset
SELECT UserID,
      COUNT(*) AS Session_count 
FROM studies101.default.viewership
WHERE DATE_FORMAT(`Duration 2`, 'HH:MM:SS') <> '00:00:00'
GROUP BY UserID
ORDER BY Session_count DESC;

--This is to parse the RecordDate2 string and extract date and time
SELECT 
    TO_TIMESTAMP(`RecordDate2`, 'yyyy/MM/dd HH:mm') AS Parsed_Timestamp,
    DATE_FORMAT(TO_TIMESTAMP(`RecordDate2`, 'yyyy/MM/dd HH:mm'), 'yyyy-MM-dd') AS Date,
    DATE_FORMAT(TO_TIMESTAMP(`RecordDate2`, 'yyyy/MM/dd HH:mm'), 'HH:mm:ss') AS Time
FROM studies101.default.viewership
LIMIT 20;

--This is to see the average viewing time per session
SELECT
    ROUND(AVG(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0,2) AS Avg_Session_Minutes
FROM studies101.default.viewership
WHERE DATE_FORMAT(`Duration 2`, 'HH:MM:SS') <> '00:00:00';

--This is to see the unique viewers
SELECT COUNT(DISTINCT UserID) AS Unique_Viewers
FROM studies101.default.viewership
WHERE DATE_FORMAT(`Duration 2`, 'HH:MM:SS') <> '00:00:00';

---This is to convert RecordDate2 to a timestamp as it is a string

SELECT  DATE_FORMAT(SessionTime, 'yyyy-MM-dd') AS Date,
      DATE_FORMAT(SessionTime, 'HH:mm:ss') AS Time
FROM (
    SELECT
    TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm') AS SessionTime
    FROM studies101.default.viewership
);

--This is to show the peak viewing periods
SELECT DATE_FORMAT(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOUR, 'HH') AS Hour_of_day_SAST,
      COUNT(*) AS Total_Sessions,
CASE 
      WHEN CAST(DATE_FORMAT(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOUR, 'HH') AS INT) BETWEEN 5 AND 11 THEN 'Morning'
     WHEN CAST(DATE_FORMAT(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOUR, 'HH') AS INT) BETWEEN 12 AND 17 THEN 'Afternoon'
     WHEN CAST(DATE_FORMAT(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOUR, 'HH') AS INT) BETWEEN 18 AND 22 THEN 'Evening'
     ELSE 'Late Night'
END AS Time_of_day_bucket,
 ROUND(SUM(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0, 0) AS Total_Minutes_Viewed
FROM studies101.default.viewership
GROUP BY Hour_of_day_SAST
ORDER BY Total_Minutes_Viewed DESC;

---Now i am combining all fields(MINUTES, HOURS AND AVERAGE MINUTES) to show one row 
SELECT COUNT(*) AS Total_Viewers,
      COUNT(DISTINCT UserID) AS Unique_Viewers,
      ROUND(SUM(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0, 0) AS Total_Minutes_Viewed,
      ROUND((HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 3600.0, 2) AS Total_Hours_Viewed,
      ROUND(AVG(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0, 2) AS Avg_Session_Minutes
FROM studies101.default.viewership
WHERE DATE_FORMAT(`Duration 2`, 'HH:MM:SS') <> '00:00:00'
GROUP BY Total_Hours_Viewed;

---Total hours and minutes viewed by channels 
SELECT 
CASE WHEN LOWER(Channel2) = 'sawsee' THEN 'SawSee'
      WHEN LOWER(Channel2) = 'supersport live events' THEN 'SuperSport Live Events'
        ELSE Channel2
END AS Channels,
COUNT(*) AS Total_Viewers,
      COUNT(DISTINCT UserID) AS Unique_Viewers,
      ROUND(SUM(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0, 0) AS Total_Minutes_Viewed,
      ROUND((HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 3600.0, 2) AS Total_Hours_Viewed,
      ROUND(AVG(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0, 2) AS Avg_Session_Minutes
FROM studies101.default.viewership
WHERE DATE_FORMAT(`Duration 2`, 'HH:MM:SS') <> '00:00:00'
GROUP BY Total_Hours_Viewed, Channels;

--Viewership trends by month 
SELECT DATE_FORMAT(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOUR, 'MM') AS Month_number,
       DATE_FORMAT(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOUR, 'MMM') AS Month_name,
       COUNT(*) AS Sessions_count,
       COUNT(DISTINCT UserID) AS Unique_Viewers,
       ROUND(SUM(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0, 0) AS Total_Minutes_Viewed,
       ROUND(AVG(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0, 2) AS Avg_Session_Minutes
FROM studies101.default.viewership
WHERE DATE_FORMAT(`Duration 2`, 'HH:MM:SS') <> '00:00:00'
GROUP BY Month_number, 
      Month_name;

--- This is to see the viewership trend by the week 
SELECT DAYOFWEEK(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOURS) AS Day_Of_Week_Number,
      DATE_FORMAT(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOURS, 'EEEE') AS Day_Of_Week_Name,
      COUNT(*) AS Session_Count,
      COUNT(DISTINCT UserID) AS Unique_Viewers,
      ROUND(SUM(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0, 0) AS Total_Minutes_Viewed,
      ROUND(AVG(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0, 2) AS Average_Session_Minutes,
      COUNT(DISTINCT DATE_FORMAT(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOURS, 'yyyy-MM-dd')) AS Number_Of_Days,
      ROUND(SUM( HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0 / COUNT(DISTINCT DATE_FORMAT(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOURS,'yyyy-MM-dd')), 0) AS Average_Daily_Minutes
FROM studies101.default.viewership
WHERE DATE_FORMAT(`Duration 2`, 'HH:MM:SS') <> '00:00:00'
GROUP BY Day_Of_Week_Number,
      Day_Of_Week_Name
ORDER BY Day_Of_Week_Number;



---This is to see the comparison between weekday and weekend( when do subscribers watch more )
SELECT
CASE WHEN  DAYOFWEEK(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOURS) IN ('0','6') THEN 'Weekend' ELSE 'Weekday'
END  AS Weekend_Flag,
    COUNT(*) AS Session_Count,
    COUNT(DISTINCT UserID) AS Unique_Viewers,
    ROUND(SUM(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.00,0) AS Total_Minutes_Viewed,
    ROUND(AVG(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0 ,2) AS Average_Session_Minutes
FROM studies101.default.viewership
WHERE DATE_FORMAT(`Duration 2`, 'HH:MM:SS') <> '00:00:00'
GROUP BY Weekend_Flag
ORDER BY Weekend_Flag;

---This is to see the 10 lowest consumption days
SELECT DATE_FORMAT(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOUR, 'yyyy-MM-dd') AS Session_Date_SAST,
    DATE_FORMAT(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOUR, 'EEEE')AS Day_Of_Week,
    COUNT(*)AS Session_Count,
    ROUND(SUM(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0, 0) AS Total_Minutes_Viewed
FROM studies101.default.viewership
WHERE DATE_FORMAT(`Duration 2`, 'HH:MM:SS') <> '00:00:00'
GROUP BY Session_Date_SAST, 
      Day_Of_Week
ORDER BY Total_Minutes_Viewed ASC
LIMIT 10;

