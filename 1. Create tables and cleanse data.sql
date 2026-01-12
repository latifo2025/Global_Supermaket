--SQL script to create the marketing_data table
CREATE TABLE IF NOT EXISTS public.marketing_data
(
"ID" 				integer NOT NULL,
"Year_Birth" 		integer,
"Education" 		character varying(120),
"Marital_Status" 	character varying(120),
"Income" 			character varying,
"Kidhome" 			integer,
"Teenhome" 			integer,
"Dt_Customer" 		character varying,
"Recency" 			integer,
"AmtLiq" 			numeric,
"AmtVege" 			numeric,
"AmtNonVeg" 		numeric,
"AmtPes" 			numeric,
"AmtChocolates" 	numeric,
"AmtComm" 			numeric,
"NumDeals" 			integer,
"NumWebBuy" 		integer,
"NumWalkinPur" 		integer,
"NumVisits" 		integer,
"Response" 			integer,
"Complain" 			integer,
"Country" 			character varying(120),
"Count_success" 	integer,
CONSTRAINT 			"PK_Marketing" PRIMARY KEY ("ID"));


--copy data into the marketing_data table from the csv file
COPY 			marketing_data
FROM 			'C:\\Omar\\LSE\\Course 1\\Assignmnt\\LSE_DA101_Assignment_data\\marketing_data.csv'
DELIMITER 		','
CSV HEADER;


--create the ad_data table
CREATE TABLE IF NOT EXISTS public.ad_data
(
"ID" 				integer NOT NULL,
"Bulkmail_ad" 		integer,
"Twitter_ad" 		integer,
"Instagram_ad" 		integer,
"Facebook_ad" 		integer,
"Brochure_ad" 		integer,
CONSTRAINT 			"PK_AdID" PRIMARY KEY ("ID"),
CONSTRAINT 			"FK_MarketingID" FOREIGN KEY ("ID")
REFERENCES 			public."marketing_data" ("ID"));


--copy data into the ad_data table from the csv file
COPY 			ad_data
FROM 			'C:\\Omar\\LSE\\Course 1\\Assignmnt\\LSE_DA101_Assignment_data\\ad_data.csv'
DELIMITER 		','
CSV HEADER;


/* Remove duplicates from the marketing data table and create another table based on it 
called marketing_data_cleaned. The marketing data table had duplicates in all columns 
except the ID column. Use a common table expression CTE to store results of query 
which finds duplicates using the row_number() function. It partitions the data and duplicate rows are 
labelelled as 2. The main query then filters out the duplicates to show only unique rows  */
CREATE TABLE marketing_data_cleaned AS
WITH 		 find_duplicates AS --common table expression CTE to find duplicates
(
SELECT 		"ID","Year_Birth","Education","Marital_Status","Income","Kidhome","Teenhome","Dt_Customer",
			"Recency","AmtLiq","AmtVege","AmtNonVeg","AmtPes","AmtChocolates","AmtComm","NumDeals",
			"NumWebBuy","NumWalkinPur","NumVisits","Response","Complain","Country","Count_success",
			ROW_NUMBER() OVER(PARTITION BY "Year_Birth","Education","Marital_Status","Income","Kidhome",
			"Teenhome","Dt_Customer","Recency","AmtLiq","AmtVege","AmtNonVeg","AmtPes","AmtChocolates",
			"AmtComm","NumDeals","NumWebBuy","NumWalkinPur","NumVisits","Response","Complain","Country",
			"Count_success"
			ORDER BY "Year_Birth","Education","Marital_Status","Income","Kidhome","Teenhome","Dt_Customer",
			"Recency","AmtLiq","AmtVege","AmtNonVeg","AmtPes","AmtChocolates","AmtComm","NumDeals",
			"NumWebBuy","NumWalkinPur","NumVisits","Response","Complain","Country","Count_success") as count_duplicates
FROM 		marketing_data
)
--main query to bring back only unique rows
SELECT 		* 
FROM		find_duplicates
WHERE		count_duplicates <2;


--create a copy of the ad_data table but match rows from the marketing_data_cleaned table
CREATE TABLE 	ad_data_cleaned 
AS 
SELECT 			a.*
FROM 			ad_data a 
RIGHT JOIN 		marketing_data_cleaned m
ON 				a."ID" = m."ID";


--add a primary key to the marketing_data_cleaned table
ALTER TABLE 		marketing_data_cleaned
ADD CONSTRAINT 		"PK_MarketingID" PRIMARY KEY ("ID");


--add a primary key to the ad_data_cleaned table
ALTER TABLE 		ad_data_cleaned
ADD CONSTRAINT 		"PK_adID" PRIMARY KEY ("ID");


--add a foreign key to the ad_data_cleaned table
ALTER TABLE 		ad_data_cleaned
ADD CONSTRAINT 		"FK_MarketingID" FOREIGN KEY ("ID")
REFERENCES 			public."marketing_data_cleaned" ("ID");