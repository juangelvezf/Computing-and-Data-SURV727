
<!-- rnb-text-begin -->

---
title: "Fundamentals of Computing and Data Display"
subtitle: "Exercise"
author: "Christoph Kern and Ruben Bach"
output: html_notebook
---

## Setup


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxucm0obGlzdD1scygpKSBcbmxpYnJhcnkodGlkeXZlcnNlKVxubGlicmFyeShEQkkpXG5saWJyYXJ5KGRicGx5cilcbmxpYnJhcnkoYmlncnF1ZXJ5KVxuYGBgIn0= -->

```r
rm(list=ls()) 
library(tidyverse)
library(DBI)
library(dbplyr)
library(bigrquery)
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


## Database connection

In this notebook we use Google BigQuery, "Google's fully managed, petabyte scale, low cost analytics data warehouse". Instruction on how to connect to Google BigQuery can be found here:

https://github.com/r-dbi/bigrquery (see 'Billing project')

https://db.rstudio.com/databases/big-query/

After running the steps needed and initializing a project, paste your project ID into the following chunk.


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuYnFfYXV0aChwYXRoID0gXCJteS1wcm9qZWN0LXN1cnY3MjctNGE0YWY2YmE4N2I1NC5qc29uXCIpXG5cbmBgYCJ9 -->

```r
bq_auth(path = "my-project-surv727-4a4af6ba87b54.json")

```

<!-- rnb-source-end -->

<!-- rnb-output-begin eyJkYXRhIjoiRXJyb3IgaW4gYnFfYXV0aChwYXRoID0gXCJteS1wcm9qZWN0LXN1cnY3MjctNGE0YWY2YmE4N2I1NC5qc29uXCIpIDogXG4gIGNvdWxkIG5vdCBmaW5kIGZ1bmN0aW9uIFwiYnFfYXV0aFwiXG4ifQ== -->

```
Error in bq_auth(path = "my-project-surv727-4a4af6ba87b54.json") : 
  could not find function "bq_auth"
```



<!-- rnb-output-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


First, set up the connection to the database. This time we use the Chicago crime database, which is a BigQuery version of the Chicago crime API we used in earlier classes.


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuY29uIDwtIGRiQ29ubmVjdChcbiAgYmlncnF1ZXJ5OjpiaWdxdWVyeSgpLFxuICBwcm9qZWN0ID0gXCJiaWdxdWVyeS1wdWJsaWMtZGF0YVwiLFxuICBkYXRhc2V0ID0gXCJjaGljYWdvX2NyaW1lXCIsXG4gIGJpbGxpbmcgPSBwcm9qZWN0XG4pXG5jb25cbmBgYCJ9 -->

```r
con <- dbConnect(
  bigrquery::bigquery(),
  project = "bigquery-public-data",
  dataset = "chicago_crime",
  billing = project
)
con
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


Show tables that are available.


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuZGJMaXN0VGFibGVzKGNvbilcbmBgYCJ9 -->

```r
dbListTables(con)
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


## SQL and dbplyr

Information on the `crime` table can be found here:

https://cloud.google.com/bigquery/public-data/chicago-crime-data

Write a first query that counts the number of rows of the `crime` table in the year 2016. The following code chunks expect SQL code.


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgc3FsXG5TRUxFQ1QgY291bnQoKikgYXMgbnVtYmVyX29mX3Jvd3NcbkZST00gY3JpbWVcblxuYGBgIn0= -->

```sql
SELECT count(*) as number_of_rows
FROM crime

```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


Next, count the number of arrests grouped by `primary_type` in 2016. Note that is a somewhat similar task as above, with some adjustments on which rows should be considered. Sort the results, i.e. list the number of arrests in a descending order.


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgc3FsXG5cblxuU0VMRUNUIGNvdW50KHVuaXF1ZV9rZXkpIGFzIG51bWJlcl9vZl9hcnJlc3QsIHByaW1hcnlfdHlwZVxuRlJPTSBjcmltZVxuV0hFUkUgYXJyZXN0PVRSVUUgYW5kIHllYXI9MjAxNlxuR1JPVVAgQlkgcHJpbWFyeV90eXBlXG5PUkRFUiBCWSBudW1iZXJfb2ZfYXJyZXN0IERFU0NcbkxJTUlUIDIwO1xuXG5gYGAifQ== -->

```sql


SELECT count(unique_key) as number_of_arrest, primary_type
FROM crime
WHERE arrest=TRUE and year=2016
GROUP BY primary_type
ORDER BY number_of_arrest DESC
LIMIT 20;

```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


We can also use the `date` for grouping. Count the number of arrests grouped by hour of the day in 2016. You can extract the latter information from `date` via `EXTRACT(HOUR FROM date)`. Which time of the day is associated with the most arrests? 


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgc3FsXG5cblNFTEVDVCBjb3VudCh1bmlxdWVfa2V5KSBhcyBudW1iZXJfb2ZfYXJyZXN0LCBFWFRSQUNUIChIT1VSIGZyb20gZGF0ZSkgYXMgaG91cl9vZl90aGVfZGF5XG5GUk9NIGNyaW1lXG5XSEVSRSB5ZWFyPTIwMTYgQU5EIGFycmVzdD1UUlVFXG5HUk9VUCBCWSBob3VyX29mX3RoZV9kYXk7IFxuYGBgIn0= -->

```sql

SELECT count(unique_key) as number_of_arrest, EXTRACT (HOUR from date) as hour_of_the_day
FROM crime
WHERE year=2016 AND arrest=TRUE
GROUP BY hour_of_the_day; 
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


Focus only on `HOMICIDE` and count the number of arrests for this incident type, grouped by year. List the results in descending order.


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgc3FsXG5TRUxFQ1QgY291bnQodW5pcXVlX2tleSkgYXMgbnVtYmVyX29mX2FycmVzdCwgeWVhclxuRlJPTSBjcmltZVxuV0hFUkUgcHJpbWFyeV90eXBlPSdIT01JQ0lERScgQU5EIGFycmVzdD1UUlVFIFxuR1JPVVAgQlkgeWVhclxuT1JERVIgQlkgbnVtYmVyX29mX2FycmVzdCBERVNDO1xuXG5gYGAifQ== -->

```sql
SELECT count(unique_key) as number_of_arrest, year
FROM crime
WHERE primary_type='HOMICIDE' AND arrest=TRUE 
GROUP BY year
ORDER BY number_of_arrest DESC;

```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


Find out which districts have the highest numbers of arrests in 2015 and 2016. That is, count the number of arrests in 2015 and 2016, grouped by year and district. Again, list the results in descending order (within year).


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgc3FsXG5TRUxFQ1QgY291bnQodW5pcXVlX2tleSkgYXMgbnVtYmVyX29mX2FycmVzdHMsIHllYXIsIGRpc3RyaWN0XG5GUk9NIGNyaW1lXG5XSEVSRSAoeWVhciA9MjAxNSBvciB5ZWFyID0gMjAxNikgYW5kIGFycmVzdCA9IFRSVUVcbkdST1VQIEJZIHllYXIsIGRpc3RyaWN0XG5PUkRFUiBCWSB5ZWFyLCBudW1iZXJfb2ZfYXJyZXN0cyBERVNDO1xuYGBgIn0= -->

```sql
SELECT count(unique_key) as number_of_arrests, year, district
FROM crime
WHERE (year =2015 or year = 2016) and arrest = TRUE
GROUP BY year, district
ORDER BY year, number_of_arrests DESC;
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


Now, try to compute the difference between the number of arrests in 2016 and 2015 by district. Order the results such that the district with the highest decrease in arrests comes first.


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgc3FsXG5TRUxFQ1QgZGlzdHJpY3QsIFNVTShjYXNlIHdoZW4geWVhcj0yMDE2IGFuZCBhcnJlc3Q9VFJVRSB0aGVuIDEgZW5kKS1TVU0oY2FzZSB3aGVuIHllYXI9MjAxNSBhbmQgYXJyZXN0PVRSVUUgdGhlbiAxIGVuZCkgYXMgZGlmZlxuRlJPTSBjcmltZVxuR1JPVVAgQlkgZGlzdHJpY3Rcbk9SREVSIEJZIGRpZmY7XG5gYGAifQ== -->

```sql
SELECT district, SUM(case when year=2016 and arrest=TRUE then 1 end)-SUM(case when year=2015 and arrest=TRUE then 1 end) as diff
FROM crime
GROUP BY district
ORDER BY diff;
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


Lets switch to writing queries from within R via the `DBI` package. Create a query object that counts the number of arrests grouped by `primary_type` of district 11 in year 2016. The results should be displayed in descending order.


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuc3FsIDwtIFwiU0VMRUNUIGNvdW50KGFycmVzdCksIHByaW1hcnlfdHlwZSwgeWVhclxuRlJPTSBgY3JpbWVgXG5XSEVSRSB5ZWFyID0gMjAxNiBhbmQgZGlzdHJpY3QgPSAxMSBhbmQgYXJyZXN0PVRSVUVcbkdyb3VwIEJZIHByaW1hcnlfdHlwZSx5ZWFyO1wiXG5gYGAifQ== -->

```r
sql <- "SELECT count(arrest), primary_type, year
FROM `crime`
WHERE year = 2016 and district = 11 and arrest=TRUE
Group BY primary_type,year;"
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


Execute the query.


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuZGJHZXRRdWVyeShjb24sIHNxbClcbmBgYCJ9 -->

```r
dbGetQuery(con, sql)
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


Try to write the very same query, now using the `dbplyr` package. For this, you need to first map the `crime` table to a tibble object in R.


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuY3IgPC0gZHBseXI6OnRibChjb24sICdjcmltZScpXG5cbmBgYCJ9 -->

```r
cr <- dplyr::tbl(con, 'crime')

```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


Again, count the number of arrests grouped by `primary_type` of district 11 in year 2016, now using `dplyr` syntax.


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuXG5jciAlPiUgXG4gIGdyb3VwX2J5KHByaW1hcnlfdHlwZSkgJT4lXG4gIGZpbHRlcihkaXN0cmljdD09MTEgJiBhcnJlc3Q9PVRSVUUgJiB5ZWFyPT0yMDE2ICklPiVcbiAgc3VtbWFyaXplKGNvdW50PW4oKSkgJT4lIFxuICBhcnJhbmdlKGRlc2MoY291bnQpKVxuXG5gYGAifQ== -->

```r

cr %>% 
  group_by(primary_type) %>%
  filter(district==11 & arrest==TRUE & year==2016 )%>%
  summarize(count=n()) %>% 
  arrange(desc(count))

```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


Count the number of arrests grouped by `primary_type` and `year`, still only for district 11. Arrange the result by `year`.


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuY3IgJT4lIFxuICBncm91cF9ieShwcmltYXJ5X3R5cGUseWVhcikgJT4lXG4gIGZpbHRlcihkaXN0cmljdD09MTEgJiBhcnJlc3Q9PVRSVUUpJT4lXG4gIHN1bW1hcml6ZShjb3VudD1uKCkpICU+JSBcbiAgYXJyYW5nZSh5ZWFyKVxuXG5gYGAifQ== -->

```r
cr %>% 
  group_by(primary_type,year) %>%
  filter(district==11 & arrest==TRUE)%>%
  summarize(count=n()) %>% 
  arrange(year)

```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


Assign the results of the query above to a local R object.


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxucTwtIGNyICU+JSBcbiAgZ3JvdXBfYnkocHJpbWFyeV90eXBlLHllYXIpICU+JVxuICBmaWx0ZXIoZGlzdHJpY3Q9PTExICYgYXJyZXN0PT1UUlVFKSU+JVxuICBzdW1tYXJpemUoY291bnQ9bigpKSAlPiUgXG4gIGFycmFuZ2UoeWVhciklPiVcbiAgY29sbGVjdCgpXG5gYGAifQ== -->

```r
q<- cr %>% 
  group_by(primary_type,year) %>%
  filter(district==11 & arrest==TRUE)%>%
  summarize(count=n()) %>% 
  arrange(year)%>%
  collect()
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


Confirm that you pulled the data to the local environment by displaying the first ten rows of the saved data set.


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuaGVhZChxLDEwKVxuYGBgIn0= -->

```r
head(q,10)
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


Close the connection.


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuZGJEaXNjb25uZWN0KGNvbilcbmBgYCJ9 -->

```r
dbDisconnect(con)
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->

