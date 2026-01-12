--The total spend per country
SELECT 		"Country", SUM("AmtLiq" + "AmtVege"  +"AmtNonVeg" + "AmtPes" + "AmtChocolates" + "AmtComm") as Total_Spend
FROM 		marketing_data_cleaned
GROUP BY 	"Country"
ORDER BY 	Total_Spend DESC;


/* Which products are the most popular in each country
The query below works out 'Per Country' which product is spent on the most */

--Common table expression CTE below to work out amount spent per product
WITH Product_Spend AS
(SELECT 	"Country", SUM("AmtLiq") AS Liquor, SUM("AmtVege") AS Vegetable, 
			SUM("AmtNonVeg") AS Meat, SUM("AmtPes") AS Fish, SUM("AmtChocolates") AS Chocolate, 
			SUM("AmtComm") AS Commodity
FROM		marketing_data_cleaned
GROUP BY 	"Country"),
--CTE below unpivots the product columns to work out which is the most popular by country
Unpivot_Product AS
(SELECT 	a."Country", Pr.*, 
			DENSE_RANK() OVER(PARTITION BY a."Country" ORDER BY Product_Amount DESC) AS Ranking
FROM 		Product_Spend a
CROSS JOIN LATERAL (
VALUES 
       		(a.Liquor, 'Liquor'),
       		(a.Vegetable, 'Vegetable'),
			(a.Meat, 'Meat'),
			(a.Fish, 'Fish'),
			(a.Chocolate, 'Chocolate'),
       		(a.Commodity, 'Commodity') ) AS Pr(Product_Amount, Product))
--Main query below to show most popular product by country			   
SELECT 		"Country", Product_Amount, Product
FROM 		Unpivot_Product
WHERE		Ranking = 1
ORDER BY 	Product_Amount DESC;


/* which products are the most popular based on marital status
The query below works out 'By Marital Stauts' which product is spent on the most */

--Common table expression CTE below to work out amount spent per product
WITH 		Product_Spend AS
(SELECT 	CASE WHEN "Marital_Status" IN ('Absurd', 'Alone', 'YOLO')
			THEN 'Other' 
			ELSE "Marital_Status"  END "Marital_Status", 
			SUM("AmtLiq") AS Liquor, SUM("AmtVege") AS Vegetable, 
			SUM("AmtNonVeg") AS Meat, SUM("AmtPes") AS Fish, SUM("AmtChocolates") AS Chocolate, 
			SUM("AmtComm") AS Commodity
FROM		marketing_data_cleaned
GROUP BY 	"Marital_Status"),
--CTE below unpivots the product columns to work out which is the most popular by marital status
Unpivot_Product AS
(SELECT 	a."Marital_Status", Pr.*, 
			DENSE_RANK() OVER(PARTITION BY a."Marital_Status" ORDER BY Product_Amount DESC) AS Ranking
FROM 		Product_Spend a
CROSS JOIN LATERAL (
VALUES 
       		(a.Liquor, 'Liquor'),
       		(a.Vegetable, 'Vegetable'),
			(a.Meat, 'Meat'),
			(a.Fish, 'Fish'),
			(a.Chocolate, 'Chocolate'),
       		(a.Commodity, 'Commodity') ) AS Pr(Product_Amount, Product))
--Main query below to show most popular product by marital status			   
SELECT 		"Marital_Status", Product_Amount, Product
FROM 		Unpivot_Product
WHERE		Ranking = 1
ORDER BY 	Product_Amount DESC;




