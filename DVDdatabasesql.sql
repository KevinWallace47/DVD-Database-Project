-Business Question: Which movie categories make the most money?
--A1 Detailed Table:

-- C Creating the detailed report:
CREATE TABLE detailedreport(
	rental_id int,
	film_id int,
	title varchar(50),
	genre varchar(25),
	payment_total numeric(5,2),
	rental_month int,
	rental_day int
)
INSERT INTO detailedreport
SELECT
	r.rental_id,
	i.film_id,
	f.title AS title, 
	c.name AS genre,
	p.amount AS payment,
	month_of_sale(r.rental_date),
	day_of_sale(r.rental_date)
FROM rental AS r
INNER JOIN inventory AS i ON i.inventory_id = r.inventory_id
INNER JOIN film AS f ON f.film_id = f.film_id
INNER JOIN film_category AS fc ON fc.film_id = f.film_id
INNER JOIN category AS c ON c.category_id = fc.category_id
INNER JOIN payment AS p ON p.rental_id = r.rental_id
ORDER BY genre ASC, month_of_sale(r.rental_date) ASC



--B Functions, takes month and day out of the date for the detailed table:
CREATE OR REPLACE FUNCTION month_of_sale(rental_date TIMESTAMP WITHOUT TIME ZONE)
	RETURNS int
	LANGUAGE plpgsql
AS
$$
DECLARE month_of_total int;
BEGIN 
	SELECT EXTRACT(MONTH FROM rental_date) INTO month_of_total;
	RETURN month_of_total;
END;
$$

CREATE OR REPLACE FUNCTION day_of_sale(rental_date TIMESTAMP WITHOUT TIME ZONE)
	RETURNS int
	LANGUAGE plpgsql
AS
$$
DECLARE day_of_total int;
BEGIN
	SELECT EXTRACT(DAY FROM rental_date) INTO day_of_total;
	RETURN day_of_total;
END;
$$

-- C Creating the summary report:
CREATE TABLE summaryreport(
	Genre varchar(25),
	Total numeric(10,2)
)

INSERT INTO summaryreport
SELECT genre, SUM(payment_total)::money AS total
FROM detailedreport
GROUP BY genre
ORDER BY total DESC

SELECT * FROM summaryreport

-- E Trigger, created to update the summary table after an update has been applied to the 
--detailed table:
CREATE OR REPLACE FUNCTION insert_trigger_function()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
DELETE FROM summaryreport;
INSERT INTO summaryreport
SELECT genre, SUM(payment_total)::money AS total
FROM detailedreport
GROUP BY genre
ORDER BY total DESC;
RETURN NEW;
END;
$$

CREATE TRIGGER new_payment
	AFTER INSERT
	ON detailedreport
	FOR EACH STATEMENT
	EXECUTE PROCEDURE insert_trigger_function();
--Stored procedure:
CREATE OR REPLACE PROCEDURE create_report_tables()
LANGUAGE plpgsql
AS $$
BEGIN
DROP TABLE IF EXISTS detailedreport;
DROP TABLE IF EXISTS summaryreport;

CREATE TABLE detailedreport(
	rental_id int,
	film_id int,
	title varchar(50),
	genre varchar(25),
	payment_total numeric(5,2),
	rental_month int,
	rental_day int
);
INSERT INTO detailedreport
SELECT
	r.rental_id,
	i.film_id,
	f.title AS title, 
	c.name AS genre,
	p.amount AS payment,
	month_of_sale(r.rental_date),
	day_of_sale(r.rental_date)
FROM rental AS r
INNER JOIN inventory AS i ON i.inventory_id = r.inventory_id
INNER JOIN film AS f ON f.film_id = f.film_id
INNER JOIN film_category AS fc ON fc.film_id = f.film_id
INNER JOIN category AS c ON c.category_id = fc.category_id
INNER JOIN payment AS p ON p.rental_id = r.rental_id
ORDER BY genre ASC, month_of_sale(r.rental_date) ASC;

CREATE TABLE summaryreport(
	Genre varchar(25),
	Total numeric(10,2)
);
INSERT INTO summaryreport
SELECT genre, SUM(payment_total)::money AS total
FROM detailedreport
GROUP BY genre
ORDER BY total DESC;

RETURN;
END;
$$;

SELECT * FROM detailedreport
SELECT * FROM summaryreport


CALL create_report_tables();