# BrightTV Viewership Analytics Assessment

## BrightTV Viewership Analytics Project

### Project Overview

This project analyzes viewer activity data from the BrightTV streaming platform to generate meaningful insights that support business growth and customer engagement.

The main purpose of the analysis is to help the Customer Value Management (CVM) team understand how users interact with the platform, identify viewing patterns, and recommend strategies to increase content consumption and grow the subscription base.

The dataset contains user profile information and detailed viewing session records, where each record represents a single viewing session. The analysis focuses on measuring user behavior, viewing duration, and content engagement across different time periods.

According to the case study, the CEO's goal is to grow the company’s subscription base and increase platform usage, and this analysis supports that objective by identifying trends and opportunities in viewership data.

## Project Objectives

The main objectives of this project are:

Analyze user viewing behavior and engagement patterns
Measure total viewing time and session activity
Identify peak and low consumption periods
Determine factors that influence content consumption
Recommend content strategies to increase usage
Provide insights that support subscriber growth
Support data-driven decision-making for management
Dataset Description

The BrightTV dataset contains information about users and their viewing sessions on the streaming platform.

Each row in the dataset represents a single viewing session.

The dataset includes:

User ID
Session duration
Content title or category
Viewing date and time
Device or platform information
User profile details
Viewing activity records

Important note:

All timestamps in the dataset are recorded in UTC and must be converted to South African time for accurate analysis.

 ## Data Processing Steps

The following steps were performed during data preparation:

# Loaded the dataset into a database environment
# Converted time values from UTC to South African Standard Time (SAST)
# Cleaned the dataset and removed invalid records
# Handled missing or zero-duration sessions
# Standardized time and date formats
# Created calculated fields for analysis
# Prepared the dataset for visualization and reporting
# Key Calculated Fields

 ## The following calculated fields were created to support analysis:

Total Viewing Minutes
Duration in Minutes = TIME_TO_SEC(Duration) / 60

Total Viewing Hours
Duration in Hours = TIME_TO_SEC(Duration) / 3600

Session Count
Number of viewing sessions per user

Average Viewing Time
Average duration per session

Unique Viewers
Number of distinct users

Peak Viewing Period
Time interval with the highest viewing activity

These calculations help measure engagement, usage intensity, and viewing trends.

## Tools and Technologies Used

SQL
Databricks
Microsoft Excel
Power BI / Tableau
GitHub
Miro (for data architecture planning)

## Author 

Siphamandla Moyo
