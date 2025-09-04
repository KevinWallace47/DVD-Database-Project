# DVD-Database-Project

In this project, I used the well known MySQL sample database known as the Saklia DVD sample database. I decided to answer the question, which movie genres sell the most and which sell the least? To answer this question, i created 2 reports: a detailed report and a summary report. The detailed report aggregates the data from the 16 tables into one, creating 7 columns. rental_id, film_id, title, gere, payment_total, rental_month, and rental_day. I used this detailed report to answer the question I posed in my summary report.

I found that the highest selling genre of movies is Sports, followed by Foreign, and Family. The least selling genre of movies from this database, are music movies, followed by horror, and then classics.

INSTRUCTIONS:
To run these queries, start by running the CREATE TABLE detailedreport query, then run both of the CREATE functions for month_of_sale and day_of_sale under the --B Functions comment. After that, run the insert statement right above the --B Functions comment, below the CREATE TABLE detailed report query. After the detailed report has been created, we can create the summary report. Start by first running the CREATE TABLE summaryreport query under the comment --C. Then we can run the INSERT INTO statement right below it. After that, I wrote a trigger statement that will update the summary table if the detailed tale has been updated. Start by running the CREATE OR REPLACE FUNCTION insert_trigger_function() query, and then running the CREATE TRIGGER query. Lastly, I created a stored procedure called create_report_tables() that will automatically generate the detailed and summary reports. To create this, run everything under the --Stored procedure: comment, before the CALL statement.

NOTE: This database was originally made for MySQL, while my query was made in PostgreSQL so there may be some syntax issues If this code is run in MySQL.
