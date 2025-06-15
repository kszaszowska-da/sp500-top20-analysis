/*
    This function checks whether columns in the specified table (from the given schema) contain NULL values.
    For each column, it generates a dynamic query to check for NULL presence.
    Returns the column name and a boolean indicating if the column contains NULLs.
*/
CREATE OR REPLACE FUNCTION fn_nulls_in_table(p_schema_name TEXT, p_table_name TEXT)
    RETURNS TABLE
            (
                col_name  TEXT,
                has_nulls BOOLEAN
            )
AS
$$
DECLARE
    col RECORD;
    sql TEXT;
BEGIN
    -- Iterate through each column in the specified table
    FOR col IN
        SELECT column_name
        FROM information_schema.columns
        WHERE table_schema = p_schema_name
          AND table_name = p_table_name
        LOOP
        -- Generate SQL query to check for NULLs in the current column
            sql := FORMAT(
                    'SELECT EXISTS (SELECT NULL FROM %I.%I WHERE %I IS NULL)',
                    p_schema_name, p_table_name, col.column_name
                   );
            -- Execute the query and store result in a variable
            EXECUTE sql INTO has_nulls;
            -- Store the column name
            col_name := col.column_name;
            -- Return result (column name and whether it contains NULLs)
            RETURN NEXT;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Example usage:
-- SELECT * FROM fn_nulls_in_table('public', 'xom');



/*
    This function finds duplicate dates in tables for each company in the given schema.
    For each company symbol (table name), it dynamically generates a query
    grouping records by the 'date' column and checks for duplicates (count > 1).
    Returns: company symbol (table name), date, and count of duplicates.
*/
CREATE OR REPLACE FUNCTION fn_find_all_date_duplicates(p_schema_name TEXT)
    RETURNS TABLE
            (
                company_symbol TEXT,
                date           DATE,
                count          BIGINT
            )
AS
$$
DECLARE
    rec_comp RECORD; -- record holding company symbol from _companies table
    sql      TEXT;   -- variable for dynamic SQL query
BEGIN
    -- Loop through all company symbols from _companies table
    FOR rec_comp IN SELECT symbol FROM _companies
    LOOP
        -- Constructing query to check date duplicates in the table named by the symbol in the given schema
        sql := FORMAT(
            'SELECT %L AS company_symbol, date, COUNT(*) AS count
             FROM %I.%I
             GROUP BY date
             HAVING COUNT(*) > 1',
            rec_comp.symbol, p_schema_name, rec_comp.symbol);
        -- Execute the dynamic query and add results to the returned table
        RETURN QUERY EXECUTE sql;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Example usage:
-- SELECT * FROM fn_find_all_date_duplicates('public');


-- View aggregating companies by sector, concatenating symbols and counting companies
CREATE OR REPLACE VIEW vw_sector_segmentation AS
SELECT sector,
       STRING_AGG(UPPER(symbol), ', ') AS company_symbols,
       COUNT(*)                        AS company_count
FROM _companies
GROUP BY sector
ORDER BY company_count DESC;


-- Function calculates average prices (open, high, low, close) and average volume for each company from the _companies table.
CREATE OR REPLACE FUNCTION fn_avg_prices_and_volume_per_company()
    RETURNS TABLE
            (
                company_symbol TEXT,
                avg_open       NUMERIC,
                avg_high       NUMERIC,
                avg_low        NUMERIC,
                avg_close      NUMERIC,
                avg_volume     NUMERIC
            )
AS
$$
DECLARE
    rec RECORD; -- Variable for iterating over company symbols
    sql TEXT; -- Variable storing dynamic SQL query
BEGIN
    FOR rec IN SELECT symbol FROM _companies
        LOOP
            -- Creating a dynamic SQL query for each company with average price and volume values over the selected period
            sql := FORMAT(
                    'SELECT UPPER(%L) AS company_symbol,
                            AVG(open) AS avg_open,
                            AVG(high) AS avg_high,
                            AVG(low) AS avg_low,
                            AVG(close) AS avg_close,
                            AVG(volume) AS avg_volume
                     FROM %I
                     WHERE date BETWEEN ''2014-01-01'' AND ''2024-12-31''',
                    rec.symbol,
                    rec.symbol
                   );
            -- Execute dynamic SQL and return the result as part of the result set
            RETURN QUERY EXECUTE sql;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Creating a view
CREATE OR REPLACE VIEW vw_avg_prices_and_volume_per_company AS
SELECT *
FROM fn_avg_prices_and_volume_per_company();


-- Function calculates average daily return percentage ((close - open) / open * 100) per company.
CREATE OR REPLACE FUNCTION fn_avg_daily_return_per_company()
    RETURNS TABLE
            (
                company_symbol TEXT,
                avg_daily_diff NUMERIC
            )
AS
$$
DECLARE
    rec RECORD; -- Variable for iterating over company symbols
    sql TEXT; -- Variable storing dynamic SQL query
BEGIN
    FOR rec IN SELECT symbol FROM _companies
        LOOP
            -- Creating a dynamic SQL query for each company to calculate the average daily return percentage
            sql := FORMAT(
                    'SELECT UPPER(%L) AS company_symbol, ROUND(AVG((close - open) / NULLIF(open, 0) * 100), 2)::NUMERIC AS avg_daily_diff FROM %I',
                    rec.symbol,
                    rec.symbol
                   );
            -- Execute dynamic SQL and return the result as part of the result set
            RETURN QUERY EXECUTE sql;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Creating a view
CREATE OR REPLACE VIEW vw_avg_daily_return_per_company AS
SELECT *
FROM fn_avg_daily_return_per_company();


-- Function returns average close price per company for each year 2014-2024
CREATE OR REPLACE FUNCTION fn_avg_yearly_close_per_company()
    RETURNS TABLE
            (
                company_symbol TEXT,
                year          INT,
                avg_close      NUMERIC
            )
AS
$$
DECLARE
    rec RECORD; -- Variable for iterating over company symbols
    sql TEXT; -- Variable storing dynamic SQL query
BEGIN
    FOR rec IN SELECT symbol FROM _companies
        LOOP
            -- Creating a dynamic query with average yearly closing prices per company for the years 2014–2024
            sql := FORMAT(
                    'SELECT UPPER(%L) AS company_symbol,
                            EXTRACT(year FROM date)::INT AS year,
                            ROUND(AVG(close), 2) AS avg_close
                     FROM %I
                     WHERE date BETWEEN ''2014-01-01'' AND ''2024-12-31''
                     GROUP BY year
                     ORDER BY year',
                    rec.symbol,
                    rec.symbol
                   );
            -- Execute dynamic SQL and return the result as part of the result set
            RETURN QUERY EXECUTE sql;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Creating a view
CREATE OR REPLACE VIEW vw_avg_yearly_close_per_company AS
SELECT *
FROM fn_avg_yearly_close_per_company();


/*
Function returns average close price per company for each year 2014-2024.
Uses CASE in aggregation to calculate averages per year.
 */
CREATE OR REPLACE FUNCTION fn_avg_yearly_close_per_company_pivot()
    RETURNS TABLE
            (
                company_symbol TEXT,
                avg_close_2014 NUMERIC,
                avg_close_2015 NUMERIC,
                avg_close_2016 NUMERIC,
                avg_close_2017 NUMERIC,
                avg_close_2018 NUMERIC,
                avg_close_2019 NUMERIC,
                avg_close_2020 NUMERIC,
                avg_close_2021 NUMERIC,
                avg_close_2022 NUMERIC,
                avg_close_2023 NUMERIC,
                avg_close_2024 NUMERIC
            )
AS
$$
DECLARE
    rec RECORD; -- Variable for iterating over company symbols
    sql TEXT; -- Variable storing dynamic SQL query
BEGIN
    FOR rec IN SELECT symbol FROM _companies
        LOOP
            -- Creating a dynamic query with average closing prices per company for the years 2014–2024
            sql := FORMAT(
                    'SELECT
                        UPPER(%L) AS company_symbol,
                        ROUND(AVG(CASE WHEN EXTRACT(YEAR FROM date) = 2014 THEN close END), 2) AS avg_close_2014,
                        ROUND(AVG(CASE WHEN EXTRACT(YEAR FROM date) = 2015 THEN close END), 2) AS avg_close_2015,
                        ROUND(AVG(CASE WHEN EXTRACT(YEAR FROM date) = 2016 THEN close END), 2) AS avg_close_2016,
                        ROUND(AVG(CASE WHEN EXTRACT(YEAR FROM date) = 2017 THEN close END), 2) AS avg_close_2017,
                        ROUND(AVG(CASE WHEN EXTRACT(YEAR FROM date) = 2018 THEN close END), 2) AS avg_close_2018,
                        ROUND(AVG(CASE WHEN EXTRACT(YEAR FROM date) = 2019 THEN close END), 2) AS avg_close_2019,
                        ROUND(AVG(CASE WHEN EXTRACT(YEAR FROM date) = 2020 THEN close END), 2) AS avg_close_2020,
                        ROUND(AVG(CASE WHEN EXTRACT(YEAR FROM date) = 2021 THEN close END), 2) AS avg_close_2021,
                        ROUND(AVG(CASE WHEN EXTRACT(YEAR FROM date) = 2022 THEN close END), 2) AS avg_close_2022,
                        ROUND(AVG(CASE WHEN EXTRACT(YEAR FROM date) = 2023 THEN close END), 2) AS avg_close_2023,
                        ROUND(AVG(CASE WHEN EXTRACT(YEAR FROM date) = 2024 THEN close END), 2) AS avg_close_2024
                     FROM %I
                     WHERE EXTRACT(YEAR FROM date) BETWEEN 2014 AND 2024',
                    rec.symbol,
                    rec.symbol
                   );
            -- Execute dynamic SQL and return the result as part of the result set
            RETURN QUERY EXECUTE sql;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Creating a view
CREATE OR REPLACE VIEW vw_avg_yearly_close_per_company_pivot AS
SELECT *
FROM fn_avg_yearly_close_per_company_pivot();


/*
Function returns average close price per company broken down by month.
Groups by month and orders ascending.
 */
CREATE OR REPLACE FUNCTION fn_avg_monthly_close_per_company()
    RETURNS TABLE
            (
                company_symbol TEXT,
                month          INT,
                avg_close      NUMERIC
            )
AS
$$
DECLARE
    rec RECORD; -- Variable for iterating over company symbols
    sql TEXT; -- Variable storing dynamic SQL query
BEGIN
    FOR rec IN SELECT symbol FROM _companies
        LOOP
            -- Creating a dynamic query with average monthly closing prices per company for the years 2014–2024
            sql := FORMAT(
                    'SELECT UPPER(%L) AS company_symbol,
                            EXTRACT(MONTH FROM date)::INT AS month,
                            ROUND(AVG(close), 2) AS avg_close
                     FROM %I
                     WHERE date BETWEEN ''2014-01-01'' AND ''2024-12-31''
                     GROUP BY month
                     ORDER BY month',
                    rec.symbol,
                    rec.symbol
                   );
            -- Execute dynamic SQL and return the result as part of the result set
            RETURN QUERY EXECUTE sql;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Creating a view
CREATE OR REPLACE VIEW vw_avg_monthly_close_per_company AS
SELECT *
FROM fn_avg_monthly_close_per_company();


-- Creating a pivot view with the monthly average closing prices of companies, where the columns represent the months (January to December)
CREATE OR REPLACE VIEW vw_avg_monthly_close_per_company_pivot AS
SELECT company_symbol,
       MAX(avg_close) FILTER (WHERE month = 1)  AS jan,
       MAX(avg_close) FILTER (WHERE month = 2)  AS feb,
       MAX(avg_close) FILTER (WHERE month = 3)  AS mar,
       MAX(avg_close) FILTER (WHERE month = 4)  AS apr,
       MAX(avg_close) FILTER (WHERE month = 5)  AS may,
       MAX(avg_close) FILTER (WHERE month = 6)  AS jun,
       MAX(avg_close) FILTER (WHERE month = 7)  AS jul,
       MAX(avg_close) FILTER (WHERE month = 8)  AS aug,
       MAX(avg_close) FILTER (WHERE month = 9)  AS sep,
       MAX(avg_close) FILTER (WHERE month = 10) AS oct,
       MAX(avg_close) FILTER (WHERE month = 11) AS nov,
       MAX(avg_close) FILTER (WHERE month = 12) AS dec
FROM fn_avg_monthly_close_per_company()
GROUP BY company_symbol
ORDER BY company_symbol;


/*
Function returns for each company the average closing price and the standard deviation of closing price
between 2014-01-01 and 2024-12-31.
*/
CREATE OR REPLACE FUNCTION fn_stddev_close_per_company()
    RETURNS TABLE
            (
                company_symbol TEXT,
                avg_close      NUMERIC,
                stddev_close   NUMERIC
            )
AS
$$
DECLARE
    rec RECORD; -- Variable for iterating over company symbols
    sql TEXT; -- Variable storing dynamic SQL query
BEGIN
    FOR rec IN SELECT symbol FROM _companies
        LOOP
            -- Creating a dynamic query with average and standard deviation of closing prices per company for the years 2014–2024
            sql := FORMAT(
                    'SELECT UPPER(%L) AS company_symbol,
                            ROUND(AVG(close), 2) AS avg_close,
                            ROUND(STDDEV_SAMP(close), 2) AS stddev_close
                     FROM %I
                     WHERE date BETWEEN ''2014-01-01'' AND ''2024-12-31''',
                    rec.symbol,
                    rec.symbol
                   );
            -- Execute dynamic SQL and return the result as part of the result set
            RETURN QUERY EXECUTE sql;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Creating a view
CREATE OR REPLACE VIEW vw_stddev_close_per_company AS
SELECT *
FROM fn_stddev_close_per_company();


/*
Function returns for each company the number of days when the closing price was higher than the opening price (up days),
and the number of days when the closing price was lower than the opening price (down days),
between 2014-01-01 and 2024-12-31.
*/
CREATE OR REPLACE FUNCTION fn_daily_change_direction_per_company()
    RETURNS TABLE
            (
                company_symbol TEXT,
                up_days        INT,
                down_days      INT
            )
AS
$$
DECLARE
    rec RECORD; -- Variable for iterating over company symbols
    sql TEXT; -- Variable storing dynamic SQL query
BEGIN
    FOR rec IN SELECT symbol FROM _companies
        LOOP
            -- Creating a dynamic query with counts of up and down closing days per company for the years 2014–2024
            sql := FORMAT(
                    'SELECT UPPER(%L) AS company_symbol,
                            COUNT(*) FILTER (WHERE close > open)::INT AS up_days,
                            COUNT(*) FILTER (WHERE close < open)::INT AS down_days
                     FROM %I
                     WHERE date BETWEEN ''2014-01-01'' AND ''2024-12-31''',
                    rec.symbol,
                    rec.symbol
                   );
            -- Execute dynamic SQL and return the result as part of the result set
            RETURN QUERY EXECUTE sql;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Creating a view
CREATE OR REPLACE VIEW vw_daily_change_direction_per_company AS
SELECT *
FROM fn_daily_change_direction_per_company();


-- View calculating percentage growth of average close price between 2014 and 2024
CREATE OR REPLACE VIEW vw_growth_percent_2014_2024_per_company AS
SELECT company_symbol,
       ROUND(((avg_close_2024 - avg_close_2014) / NULLIF(avg_close_2014, 0)) * 100, 2) AS percent_growth
FROM fn_avg_yearly_close_per_company_pivot()
WHERE avg_close_2014 IS NOT NULL
  AND avg_close_2024 IS NOT NULL;


-- View calculating absolute growth value of average close price between 2014 and 2024
CREATE OR REPLACE VIEW vw_growth_value_2014_2024_per_company AS
SELECT company_symbol,
       ROUND(avg_close_2024 - avg_close_2014, 2) AS value_growth
FROM fn_avg_yearly_close_per_company_pivot()
WHERE avg_close_2014 IS NOT NULL
  AND avg_close_2024 IS NOT NULL;

