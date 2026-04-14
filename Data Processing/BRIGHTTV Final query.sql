SELECT
-- ── Identifying Subscribers ────
    v.UserID,

  -- ── CHANNEL (standardised — fixes the SawSee and SuperSport duplicates) ───
CASE WHEN LOWER(v.Channel2) = 'sawsee' THEN 'SawSee'
    WHEN LOWER(v.Channel2) = 'supersport live events' THEN 'SuperSport Live Events'
    ELSE v.Channel2
END  AS Channel,

  -- ── DATE & TIME (converted from UTC to SAST by adding 2 hours) ───
-- RecordDate2 is stored as a string so we first used the TO_TIMESTAMP function to convert to a real date/time value
    DATE_FORMAT(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOUR,'yyyy-MM-dd HH:mm:ss') AS Session_DateTime_SAST,
    DATE_FORMAT(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOUR,'yyyy-MM-dd') AS Session_Date_SAST,
    DATE_FORMAT(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOUR,'MMM') AS Month_Name,
    DATE_FORMAT(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOUR,'EEEE') AS Day_Of_Week_Name,
    DATE_FORMAT(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOUR,'HH') AS Hour_Of_Day_SAST,

  -- ── TIME OF DAY BUCKET ────
CASE WHEN CAST(DATE_FORMAT(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOUR, 'HH') AS INT) BETWEEN 5  AND 11 THEN 'Morning'
    WHEN CAST(DATE_FORMAT(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOUR, 'HH') AS INT) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN CAST(DATE_FORMAT(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOUR, 'HH') AS INT) BETWEEN 18 AND 22 THEN 'Evening'
    ELSE 'Late Night'
END AS Time_Of_Day_Bucket,

  -- ── WEEKDAY VS WEEKEND ────
CASE WHEN DAYOFWEEK(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm') + INTERVAL 2 HOUR) IN (1, 7) THEN 'Weekend'
    ELSE 'Weekday'
END  AS Weekend_Flag,

  -- ── DURATION FIELDS ─────
    DATE_FORMAT(v.`Duration 2`, 'HH:mm:ss') AS Duration_Raw,
    ROUND((HOUR(v.`Duration 2`) * 3600 + MINUTE(v.`Duration 2`) * 60 + SECOND(v.`Duration 2`)) / 60.0, 2) AS Duration_In_Minutes,
    ROUND((HOUR(v.`Duration 2`) * 3600 + MINUTE(v.`Duration 2`) * 60 + SECOND(v.`Duration 2`))/ 3600.0, 4) AS Duration_In_Hours,
 
  -- ── SUBSCRIBER PROFILE (from user_profiles via LEFT JOIN) ─────────────────
CASE WHEN p.Gender IS NULL OR p.Gender = '' THEN 'Unknown'
    ELSE p.Gender
END AS Gender,
CASE WHEN p.Race IS NULL OR p.Race = '' THEN 'Unknown'
    ELSE p.Race
END AS Race,
  IFNULL(CASE WHEN p.Age < 5 OR p.Age > 99 THEN NULL ELSE p.Age END, 0) AS Age,
  IFNULL(CASE
            WHEN p.Age BETWEEN 5  AND 17 THEN 'Youth'
            WHEN p.Age BETWEEN 18 AND 24 THEN 'Young Adult'
            WHEN p.Age BETWEEN 25 AND 34 THEN 'Millennial'
            WHEN p.Age BETWEEN 35 AND 49 THEN 'Gen X'
            WHEN p.Age BETWEEN 50 AND 64 THEN 'Boomer'
            WHEN p.Age >= 65 THEN 'Senior'
            ELSE 'Unknown'
        END, 'Unknown')AS Age_Group,
 CASE WHEN p.Province IS NULL OR p.Province = '' THEN 'Unknown'
     ELSE p.Province
    END  AS Province,
CASE WHEN p.`Social Media Handle` IS NULL THEN 'No Handle on Record'
    ELSE 'Has Handle on Record'
    END AS Social_Media_Status,

  -- ── MATCH FLAG ───
-- Shows whether the session's UserID was found in user_profiles
CASE WHEN p.UserID IS NULL THEN 'No Profile Found'
    ELSE 'Matched'
    END AS Profile_Match_Status
 
  -- viewership is the main/driving table
FROM studies101.default.viewership AS v
 
  -- LEFT JOIN keeps all viewership rows even if no profile record exists
LEFT JOIN studies101.default.user_profiles AS p 
ON v.UserID = p.UserID
 
 -- Exclude zero-duration channel zaps
WHERE DATE_FORMAT(v.`Duration 2`, 'HH:mm:ss') <> '00:00:00'
ORDER BY Session_DateTime_SAST;
