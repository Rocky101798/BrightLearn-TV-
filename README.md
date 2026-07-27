# BrightTV Viewership Analytics

**Turning raw streaming data into the insights that grow a subscriber base.**

## Project Overview

BrightTV wants to know one thing above all: *what makes people watch more?*

This project digs into viewer activity data from the BrightTV streaming platform to answer that question — surfacing the patterns behind how, when, and why users engage with content. The goal is to give the Customer Value Management (CVM) team a clear, data-backed view of viewing behavior so they can boost engagement and grow the subscription base.

Each record in the dataset represents a single viewing session, capturing user behavior, viewing duration, and content engagement across different time periods. Per the case study, the CEO's mandate is clear: grow subscribers, grow usage. This analysis is built to support exactly that.

## Project Objectives

- Analyze user viewing behavior and engagement patterns
- Measure total viewing time and session activity
- Identify peak and low consumption periods
- Determine what factors drive (or kill) content consumption
- Recommend content strategies to increase usage
- Surface insights that support subscriber growth
- Enable data-driven decision-making for management

## Dataset Description

The BrightTV dataset captures users and their viewing sessions on the platform. Each row = one viewing session, including:

- User ID
- Session duration
- Content title or category
- Viewing date and time
- Device or platform information
- User profile details
- Viewing activity records

> **Note:** All timestamps are recorded in UTC and must be converted to South African time for accurate analysis.

## Data Processing Steps

- Loaded the dataset into a database environment
- Converted time values from UTC to South African Standard Time (SAST)
- Cleaned the dataset and removed invalid records
- Handled missing or zero-duration sessions
- Standardized time and date formats
- Created calculated fields for analysis
- Prepared the dataset for visualization and reporting

## Key Calculated Fields

| Metric | Formula / Definition |
|---|---|
| Total Viewing Minutes | `TIME_TO_SEC(Duration) / 60` |
| Total Viewing Hours | `TIME_TO_SEC(Duration) / 3600` |
| Session Count | Number of viewing sessions per user |
| Average Viewing Time | Average duration per session |
| Unique Viewers | Number of distinct users |
| Peak Viewing Period | Time interval with the highest viewing activity |

These calculations power the engagement, usage-intensity, and trend analysis behind every insight in this project.

## Tools and Technologies Used

- SQL
- Databricks
- Microsoft Excel
- PowerPoint (presentation)
- GitHub
- Miro (data architecture planning)
- **Live Dashboard:** [BrightTV Dashboard](https://siphamandla.lovable.app)

## Author

**Siphamandla Moyo**
